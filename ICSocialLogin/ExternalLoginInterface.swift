//
//  ExternalLogin.swift
//
//
//  Created by Digital Khrisna on 3/2/17.
//  Copyright © 2017 Codigo. All rights reserved.
//

public enum ExternalLoginCompletionStatus: Int {
    case badRequest = 400
    case success = 200
}

public enum ExternalSource {
    case facebook
    case twitter
}


typealias ExternalLoginCompletion = (_ success: Bool, _ status: ExternalLoginCompletionStatus, _ message: String) -> Void

public protocol ExternalLoginDelegate {
    func onSuccess(_ id: String, name: String, email: String, from: ExternalSource) -> Void
    func onSuccess(userInfo: [String : Any], from: ExternalSource) -> Void
    func onFailed(with error: NSError?, and message: String, from: ExternalSource) -> Void
    func onCancel(from: ExternalSource) -> Void
}

extension ExternalLoginDelegate {
    func onSuccess(userInfo: [String : Any], from: ExternalSource) -> Void {
        
    }
}
