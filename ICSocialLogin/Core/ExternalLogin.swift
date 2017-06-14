//
//  ExternalLogin.swift
//  ICSocialLogin
//
//  Created by Digital Khrisna on 6/14/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import FacebookLogin
import FacebookCore
import TwitterKit

open class ExternalLogin {
    
    var delegate: ExternalLoginDelegate?
    var context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
    
    func loginFacebook(permission: [FacebookPermission], completion: ExternalLoginCompletion? = nil) {
        
        var fbPermissions = [ReadPermission]()
        for fbPerm in permission {
            fbPermissions.append(fbPerm.toReadPermissions())
        }
        
        let loginManager = LoginManager()
        loginManager.loginBehavior = .systemAccount
        loginManager.logIn(fbPermissions, viewController: self.context){
            (loginResult) in
            switch loginResult {
            case .failed(let error):
                self.delegate?.onFailed(with: error as NSError?, and: "An error occured", from: .facebook)
                
                if let cpl = completion {
                    cpl(false, ExternalLoginCompletionStatus.badRequest, "Failed")
                }
            case .cancelled:
                self.delegate?.onCancel(from: .facebook)
                
                if let cpl = completion {
                    cpl(false, ExternalLoginCompletionStatus.badRequest, "Failed")
                }
            case .success( _, _, _):
                let params = ["fields" : "id, email, name"]
                let graphRequest = GraphRequest(graphPath: "me", parameters: params)
                graphRequest.start({ (urlResponse, requestResult) in
                    switch requestResult{
                    case .failed( _):
                        self.delegate?.onFailed(with: nil, and: "Failed on graph request", from: .facebook)
                        break
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {
                            guard let id = responseDictionary["id"] as? String else {
                                return
                            }
                            
                            guard let name = responseDictionary["name"] as? String else {
                                return
                            }
                            
                            self.delegate?.onSuccess(id, name: name, email: "", from: .facebook)
                            self.delegate?.onSuccess(userInfo: responseDictionary, from: .facebook)
                            
                            if let cpl = completion {
                                cpl(true, ExternalLoginCompletionStatus.success, "success")
                            }
                        }
                        break
                    }
                })
            }
        }
    }
    
    func loginTwitter(completion: ExternalLoginCompletion? = nil){
        
        Twitter.sharedInstance().logIn(completion: {
            (session, error) in
            if let unwrappedSession = session {
                self.delegate?.onSuccess(unwrappedSession.userID, name: unwrappedSession.userName, email: "", from: .twitter)
                
                if let cpl = completion {
                    cpl(true, ExternalLoginCompletionStatus.success, "success")
                }
                
            } else {
                print("Login failed")
                
                self.delegate?.onFailed(with: nil, and: "Login twitter failed", from: .twitter)
                
                if let cpl = completion {
                    cpl(false, ExternalLoginCompletionStatus.badRequest, "failed")
                }
            }
        })
    }
}
