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

    
    /// 获取验证码
    ///
    /// - Parameters:
    ///   - phone:          手机号码
    ///   - failureHandler: 失败处理闭包
    ///   - completion:     成功处理闭包
    /// - Returns:          Cancellable
    @discardableResult
    func sendSMS(phone: String, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.sendSMS(phone: phone), failureHandler: failureHandler, completion: { json in
            let sent = (json["sent"] as? Bool) ?? false
            completion(sent)
        })
    }
    
    /// 验证短信验证码
    ///
    /// - Parameters:
    ///   - phone:          手机号码
    ///   - code:           验证码
    ///   - failureHandler: 失败处理闭包
    ///   - completion:     成功处理闭包
    /// - Returns:          Cancellable
    @discardableResult
    func verifySMS(phone: String, code: String, failureHandler: failureHandler? = nil, completion: @escaping (LoginUser?) -> Void) -> Cancellable {
        return self.sendRequest(.verifySMS(phone: phone, code: code), failureHandler: failureHandler, completion: { json in
            guard let verified = json["verified"] as? Bool, verified == true else {
                completion(nil)
                return
            }
            
            if let firstLogin = json["first_login"] as? Bool,
               let accessToken = json["token"] as? String,
               let parentID = json["parent_id"] as? Int,
               let userID = json["user_id"] as? Int,
               let profileID = json["profile_id"] as? Int {
                completion(LoginUser(accessToken: accessToken, userID: userID, parentID: parentID, profileID: profileID, firstLogin: firstLogin, avatarURLString: ""))
            }
            completion(nil)
        })
    }
    
    /// 获取个人账号信息
    ///
    /// - Parameters:
    ///   - id:             个人信息id
    ///   - failureHandler: 失败处理闭包
    ///   - completion:     成功处理闭包
    /// - Returns:          Cancellable
    @discardableResult
    func userProfile(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (ProfileInfo?) -> Void) -> Cancellable {
        return self.sendRequest(.profileInfo(id: id), failureHandler: failureHandler, completion: { json in
            guard let _ = json["id"] else {
                completion(nil)
                return
            }
            if let id = json["id"] as? Int,
               let gender = json["gender"] as? String? {
                completion(ProfileInfo(id: id, gender: gender, avatar: (json["avatar"] as? String) ?? ""))
                return
            }
            completion(nil)
        })
    }
    }
}


