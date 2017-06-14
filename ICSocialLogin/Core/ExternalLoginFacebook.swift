//
//  ExternalLogin.swift
//
//
//  Created by Digital Khrisna on 3/2/17.
//  Copyright © 2017 Codigo. All rights reserved.
//

import FacebookLogin
import FacebookCore

public enum FacebookPermission {
    case publicProfile
    case email
    case userFriends
    case custom(String)
    
    func toReadPermissions() -> ReadPermission {
        switch self {
        case .publicProfile:
            return ReadPermission.publicProfile
        case .email:
            return ReadPermission.email
        case .userFriends:
            return ReadPermission.userFriends
        case .custom(let value):
            return ReadPermission.custom(value)
        }
    }
}


open class ExternalLoginFacebook {
    
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
}
