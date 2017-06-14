//
//  ExternalLogin.swift
//
//
//  Created by Digital Khrisna on 3/2/17.
//  Copyright © 2017 Codigo. All rights reserved.
//

import TwitterKit

open class ExternalLoginTwitter {
    
    var delegate: ExternalLoginDelegate?
    
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
