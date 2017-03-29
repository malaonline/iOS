//
//  LoginUser.swift
//  mala-ios
//
//  Created by 王新宇 on 16/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

///  登陆用户信息结构体
struct LoginUser: CustomStringConvertible {
    let accessToken: String
    let userID: Int
    let parentID: Int?
    let profileID: Int
    let firstLogin: Bool?
    let avatarURLString: String?
    
    var description: String {
        return "LoginUser(accessToken: \(accessToken), userID: \(userID), parentID: \(parentID as Optional), profileID: \(profileID as Optional))" +
        ", firstLogin: \(firstLogin as Optional)), avatarURLString: \(avatarURLString as Optional))"
    }
}
