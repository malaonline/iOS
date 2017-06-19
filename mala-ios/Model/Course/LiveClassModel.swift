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
    var courseStart: TimeInterval? {
        didSet {
            guard let date = courseStart, date != 0 else { return }
            seasonType = getSeasonType(withStartDate: date)
        }
    }
    var courseEnd: TimeInterval?
    var courseGrade: String?
    var courseFee: Int?
    var courseLessons: Int?
    
    var coursePeriod: String?
    var courseDesc: String?
    var studentsCount: Int?
    var lecturerBio: String?
    var isPaid: Bool = true
    
    var subjectString: String?
    var seasonType: LiveCourseSeason? {
        didSet {
            guard let season = seasonType,
                  let start = courseStart else { return }
            let startDate = Date(timeIntervalSince1970: start)
            let nextSeason = LiveCourseSeason(rawValue: MACurrentSeason.rawValue+1) ?? .spring
            
            if season == MACurrentSeason && startDate.isEarlier(than: Date()) {
                signState = .inClass
            }else if (season == MACurrentSeason && startDate.isLater(than: Date())) || (season == nextSeason) {
                signState = .enrolling
            }else {
                signState = .preEnrollment
            }
        }
    }
    var signState: LiveCourseSignState?
    
    
    // MARK: - Ca Property
    var attrCourseTitle: NSMutableAttributedString? {
        get {
            guard let courseTitle = self.courseName else { return nil }
            
            let rangeLocation = (courseTitle as NSString).range(of: "(").location
            if rangeLocation <= courseTitle.characters.count {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: courseTitle)
                attrString.addAttribute(
                    NSFontAttributeName,
                    value: UIFont.systemFont(ofSize: 18),
                    range: NSMakeRange(0, rangeLocation)
                )
                attrString.addAttribute(
                    NSFontAttributeName,
                    value: UIFont.systemFont(ofSize: 14),
                    range: NSMakeRange(rangeLocation, courseTitle.characters.count - rangeLocation)
                )
                return attrString
            }else {
                return nil
            }
        }
    }
    var firstSubjectChart: String? {
        get {
            return subjectString?.subStringToIndex(1)
        }
    }
    var subjectColor: UIColor {
        get {
            guard let chart = firstSubjectChart else { return UIColor(named: .liveMathPurple) }
            switch chart {
            case "数":   return UIColor(named: .liveEnglishGreen)
            case "英":   return UIColor(named: .liveMathPurple)
            default:     return UIColor(named: .liveMathPurple)
            }
        }
    }
    var remaining: Int {
        get {
            return (roomCapacity ?? 0) - (studentsCount ?? 0)
        }
    }
    var attrAddressString: NSMutableAttributedString {
        get {
            return makeAddressAttrString(schoolName, schoolAddress)
        }
    }
    
    // 分享信息
    var shareText: String {
        get {
            guard let teacherName = lecturerName, let courseName = courseName else {
                return "火爆的双师直播课程"
            }
            return String(format: "%@%@%@", teacherName, "在麻辣老师为您讲授", courseName)
        }
    }
    // 分享链接
    var shareURL: URL? {
        get {
            #if USE_PRD_SERVER
                return URL(string: String(format: "https://www.malalaoshi.com/wechat/order/course_choosing/?step=live_class_page&liveclassid=%d", id))
            #elseif USE_STAGE_SERVER
                return URL(string: String(format: "https://stage.malalaoshi.com/wechat/order/course_choosing/?step=live_class_page&liveclassid=%d", id))
            #else
                return URL(string: String(format: "https://dev.malalaoshi.com/wechat/order/course_choosing/?step=live_class_page&liveclassid=%d", id))
            #endif
            
        }
    }
    
    
    // MARK: - Instance Method
    override init() {
        super.init()
    }
    
    override init(dict: [String: Any]) {
        super.init(dict: dict)
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
        if key == "course_subject", let string = value as? String {
            subjectString = string
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
        if key == "is_paid", let bool = value as? Bool {
            isPaid = bool
            return
        }
        super.setValue(value, forKey: key)
    }
}
