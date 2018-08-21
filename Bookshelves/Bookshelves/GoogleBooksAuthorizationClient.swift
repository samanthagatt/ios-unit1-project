//
//  GoogleBooksAuthorizationClient.swift
//  BooksAuth
//
//  Created by Andrew R Madsen on 8/20/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import GTMAppAuth

private let gtmAuthKeychainName = "BooksAuth-GTMAuthorization"
private let issuer = URL(string: "https://accounts.google.com")!
private let clientID = "541474744860-bvmc0ctfnethiectoo6tnr5qg70ene8i.apps.googleusercontent.com"
private let redirectURI = URL(string: "com.googleusercontent.apps.541474744860-bvmc0ctfnethiectoo6tnr5qg70ene8i:/oauthredirect")!
private let bookScopeURL = URL(string: "https://www.googleapis.com/auth/books")!

final class GoogleBooksAuthorizationClient {
    
    static let shared = GoogleBooksAuthorizationClient()
    
    init() {
        loadGTMAuthState()
    }
    
    func authorizeIfNeeded(presenter: UIViewController, completion: @escaping (Error?) -> Void) {
        
        if let authState = authorization?.authState, authState.isAuthorized {
            // Already authorized, so no need to do it again.
            completion(nil)
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { (configuration, error) in
            if let error = error, configuration == nil {
                NSLog("Error retrieving discovery document: \(error)")
                return
            }
            guard let configuration = configuration else { return }
            
            // Create a request for authorization
            let authRequest = OIDAuthorizationRequest(configuration: configuration,
                                                      clientId: clientID,
                                                      scopes: [OIDScopeOpenID, OIDScopeProfile, bookScopeURL.absoluteString],
                                                      redirectURL: redirectURI,
                                                      responseType: OIDResponseTypeCode,
                                                      additionalParameters: nil)
            
            // Perform the request
            self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: authRequest, presenting: presenter) { (authState, error) in
                if let error = error, authState == nil {
                    NSLog("Authorization error: \(error)")
                    return
                }
                guard let authState = authState else {
                    self.authorization = nil
                    return
                }
                self.authorization = GTMAppAuthFetcherAuthorization(authState: authState)
            }
        }
    }
    
    func addAuthorization(to request: URLRequest, completion: @escaping (URLRequest?, Error?) -> Void) {
        
        let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        
        guard let auth = authorization else {
            NSLog("Need to authorize first")
            let error = NSError(domain: OIDOAuthAuthorizationErrorDomain, code: OIDErrorCodeOAuthAuthorization.unauthorizedClient.rawValue, userInfo: nil)
            completion(nil, error)
            return
        }
        
        auth.authorizeRequest(mutableRequest) { (error) in
            if let error = error {
                NSLog("Unable to authorize request: \(error)")
                completion(nil, error)
                return
            }
            
            let newRequest = (mutableRequest.copy() as! NSURLRequest) as URLRequest
            completion(newRequest, nil)
        }
    }
    
    func resumeAuthorizationFlow(with url: URL) -> Bool {
        guard let currentFlow = currentAuthorizationFlow else {
            return false
        }
        
        return currentFlow.resumeAuthorizationFlow(with: url)
    }
    
    func resetAuthorization() {
        authorization = nil
    }
    
    // MARK: - Private
    
    private func loadGTMAuthState() {
        authorization = GTMAppAuthFetcherAuthorization(fromKeychainForName: gtmAuthKeychainName)
    }
    
    private func saveGTMAuthState() {
        if let auth = authorization {
            GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: gtmAuthKeychainName)
        } else {
            GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: gtmAuthKeychainName)
        }
    }
    
    // MARK: - Properties
    
    var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    private(set) var authorization: GTMAppAuthFetcherAuthorization? {
        didSet {
            saveGTMAuthState()
        }
    }
    
}
