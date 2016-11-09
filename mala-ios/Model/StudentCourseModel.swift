//
//  StudentCourseModel.swift
//  mala-ios
//
//  Created by 王新宇 on 3/17/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

open class StudentCourseModel: BaseObjectModel {

    // MARK: - Property
    /// 上课时间
    var start: TimeInterval = 0
    
    /// 下课时间
    var end: TimeInterval = 0
    
    /// 学科
    var subject: String = ""
    
    /// 年级
    var grade: String = ""
    
    /// 上课地点
    var school: String = ""
    
    /// 是否完成标记
    var isPassed: Bool = false
    
    /// 授课老师
    var teacher: TeacherModel?
    
    /// 课程评价
    var comment: CommentModel?
    
    /// 是否过期标记
    var isExpired: Bool = false
    
    /// 主讲老师
    var lecturer: TeacherModel?
    
    /// 是否时直播课程标记
    var isLiveCourse: Bool? = false
    
    // MARK: Convenience Property
    /// 是否评价标记
    var isCommented: Bool? = false
    
    /// 日期对象
    var date: Date {
        get {
            return Date(timeIntervalSince1970: end)
        }
    }
    
    /// 课程状态
    var status: CourseStatus {
        get {
            // 设置课程状态
            if date.isToday && !isPassed {
                return .Today
            }else if date.isEarlierThanOrEqual(to: Date()) || isPassed {
                return .Past
            }else {
                return .Future
            }
        }
    }
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    convenience init(id: Int, start: TimeInterval, end: TimeInterval, subject: String, grade: String, school: String, is_passed: Bool, is_commented: Bool = false, is_expired: Bool) {
        self.init()
        self.id = id
        self.start = start
        self.end = end
        self.subject = subject
        self.grade = grade
        self.school = school
        self.isPassed = is_passed
        self.isCommented = is_commented
        self.isExpired = is_expired
    }
    
    
    // MARK: - Override
    open override func setValue(_ value: Any?, forKey key: String) {
        if key == "is_passed", let bool = value as? Bool {
            isPassed = bool
            return
        }
        if key == "is_expired", let bool = value as? Bool {
            isExpired = bool
            return
        }
        if key == "is_live", let bool = value as? Bool {
            isLiveCourse = bool
            return
        }
        if key == "teacher", let dict = value as? [String: AnyObject] {
            teacher = TeacherModel(dict: dict)
            return
        }
        if key == "comment", let dict = value as? [String: AnyObject] {
            comment = CommentModel(dict: dict)
            return
        }
        if key == "lecturer", let dict = value as? [String: AnyObject] {
            lecturer = TeacherModel(dict: dict)
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("StudentCourseModel - Set for UndefinedKey: \(key)")
    }
}
