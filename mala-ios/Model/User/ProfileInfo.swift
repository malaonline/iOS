//
//  ProfileInfo.swift
//  mala-ios
//
//  Created by 王新宇 on 16/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

///  个人账号信息结构体
struct ProfileInfo: CustomStringConvertible {
    let id: Int
    let gender: String?
    let avatar: String?
    
    var description: String {
        return "parentInfo(id: \(id), gender: \(gender as Optional), avatar: \(avatar as Optional)"
    }
}
