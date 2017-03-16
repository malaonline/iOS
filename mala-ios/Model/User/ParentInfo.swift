//
//  ParentInfo.swift
//  mala-ios
//
//  Created by 王新宇 on 16/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

///  家长账号信息结构体
struct ParentInfo: CustomStringConvertible {
    let id: Int
    let studentName: String?
    let schoolName: String?
    
    var description: String {
        return "parentInfo(id: \(id), studentName: \(studentName), schoolName: \(schoolName)"
    }
}
