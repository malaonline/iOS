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
    var teacherAvatar: String?
    var assistantAvatar: String?
    var teacherName: String?
    var assistantName: String?
    var teacherTitle: String?
    var courseName: String?
    var courseGrade: String?
    var classLevel: Int?
    
    
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
    
    convenience init(teacherAvatar: String?, assistantAvatar: String?, teacherName: String?, assistantName: String?, teacherTitle: String?, courseName: String?, courseGrade: String?, classLevel: Int?) {
        self.init()
        self.teacherAvatar = teacherAvatar
        self.assistantAvatar = assistantAvatar
        self.teacherName = teacherName
        self.assistantName = assistantName
        self.teacherTitle = teacherTitle
        self.courseName = courseName
        self.courseGrade = courseGrade
        self.classLevel = classLevel
    }
}
