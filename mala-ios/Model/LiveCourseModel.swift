//
//  LiveCourseModel.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseModel: BaseObjectModel {

    // MARK: - Property
    var teacherName: String?
    var assistantName: String?
    var teacherLabel: String?
    var courseName: String?
    var courseInfo: String?
    
    
    // MARK: - Instance Method
    override init() {
        super.init()
    }
    
    override init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
