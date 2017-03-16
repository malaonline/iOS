//
//  MAService.swift
//  mala-ios
//
//  Created by 王新宇 on 13/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {

    @discardableResult
    func sendSMS(phone: String, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.sendSMS(phone: phone), failureHandler: failureHandler) { json in
            let sent = (json["sent"] as? Bool) ?? false
            completion(sent)
        }
    }
    
    @discardableResult
    func verifySMS(phone: String, code: String, failureHandler: failureHandler? = nil, completion: @escaping (LoginUser?) -> Void) -> Cancellable {
        return self.sendRequest(.verifySMS(phone: phone, code: code), failureHandler: failureHandler) { json in
            guard let verified = json["verified"] as? Bool, verified == true else {
                completion(nil)
                return
            }
            
            if
                let firstLogin = json["first_login"] as? Bool,
                let accessToken = json["token"] as? String,
                let parentID = json["parent_id"] as? Int,
                let userID = json["user_id"] as? Int,
                let profileID = json["profile_id"] as? Int {
                let user = LoginUser(accessToken: accessToken, userID: userID, parentID: parentID, profileID: profileID, firstLogin: firstLogin, avatarURLString: "")
                completion(user)
            }
            completion(nil)
        }
    }
}


