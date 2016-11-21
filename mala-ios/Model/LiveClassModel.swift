//
//  LiveClassModel.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveClassModel: BaseObjectModel {

    // MARK: - Property
    var lecturerAvatar: String?
    var lecturerName: String?
    var lecturerTitle: String?
    var assistantAvatar: String?
    var assistantName: String?
    var assistantPhone: String?
    var roomCapacity: Int?
    
    var schoolName: String?
    var schoolAddress: String?
    var courseName: String?
    var courseStart: TimeInterval?
    var courseEnd: TimeInterval?
    var courseGrade: String?
    var courseFee: Int?
    var courseLessons: Int?
    
    var coursePeriod: String?
    var courseDesc: String?
    var studentsCount: Int?
    var lecturerBio: String?
    
    
    var attrAddressString: NSMutableAttributedString {
        get {
            let string = (schoolName ?? "") + "\n" + (schoolAddress ?? "")
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: string)
            let location = (string as NSString).range(of: "\n").location
            let length = string.characters.count
            let leftLength = length - location
            
            attrString.addAttribute(
                NSForegroundColorAttributeName,
                value: MalaColor_636363_0,
                range: NSMakeRange(0, location)
            )
            attrString.addAttribute(
                NSFontAttributeName,
                value: UIFont.systemFont(ofSize: 14),
                range: NSMakeRange(0, location)
            )
            attrString.addAttribute(
                NSForegroundColorAttributeName,
                value: MalaColor_939393_0,
                range: NSMakeRange(location, leftLength)
            )
            attrString.addAttribute(
                NSFontAttributeName,
                value: UIFont.systemFont(ofSize: 12),
                range: NSMakeRange(location, leftLength)
            )
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            attrString.addAttribute(
                NSParagraphStyleAttributeName,
                value: paragraphStyle,
                range: NSMakeRange(0, length)
            )
            return attrString
        }
    }
    
    
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

    override func setValue(_ value: Any?, forKey key: String) {
        // 老师信息
        if key == "lecturer_avatar", let string = value as? String {
            lecturerAvatar = string
            return
        }
        if key == "lecturer_name", let string = value as? String {
            lecturerName = string
            return
        }
        if key == "lecturer_title", let string = value as? String {
            lecturerTitle = string
            return
        }
        if key == "assistant_avatar", let string = value as? String {
            assistantAvatar = string
            return
        }
        if key == "assistant_name", let string = value as? String {
            assistantName = string
            return
        }
        if key == "assistant_phone", let string = value as? String {
            assistantPhone = string
            return
        }
        if key == "room_capacity", let int = value as? Int {
            roomCapacity = int
            return
        }
        // 班级信息
        if key == "school_name", let string = value as? String {
            schoolName = string
            return
        }
        if key == "school_address", let string = value as? String {
            schoolAddress = string
            return
        }
        if key == "course_name", let string = value as? String {
            courseName = string
            return
        }
        if key == "course_start", let timeInterval = value as? TimeInterval {
            courseStart = timeInterval
            return
        }
        if key == "course_end", let timeInterval = value as? TimeInterval {
            courseEnd = timeInterval
            return
        }
        if key == "course_grade", let string = value as? String {
            courseGrade = string
            return
        }
        if key == "course_fee", let int = value as? Int {
            courseFee = int
            return
        }
        if key == "course_lessons", let int = value as? Int {
            courseLessons = int
            return
        }
        // 详细信息
        if key == "course_period", let string = value as? String {
            coursePeriod = string
            return
        }
        if key == "course_description", let string = value as? String {
            courseDesc = string
            return
        }
        if key == "students_count", let int = value as? Int {
            studentsCount = int
            return
        }
        if key == "lecturer_bio", let string = value as? String {
            lecturerBio = string
            return
        }
        super.setValue(value, forKey: key)
    }
}
