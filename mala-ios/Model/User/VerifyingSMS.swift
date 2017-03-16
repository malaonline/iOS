//
//  VerifyingSMS.swift
//  mala-ios
//
//  Created by 王新宇 on 16/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

///  SMS验证结果结构体
struct VerifyingSMS: CustomStringConvertible {
    let verified: String
    let first_login: String
    let token: String?
    let parent_id: String
    let reason: String?
    
    var description: String {
        return "VerifyingSMS(verified: \(verified), first_login: \(first_login), token: \(token), parent_id: \(parent_id), reason: \(reason))"
    }
}
