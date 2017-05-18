//
//  TeacherDetailModel.swift
//  mala-ios
//
//  Created by Elors on 12/29/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class TeacherDetailModel: BaseObjectModel {
    
    // MARK: - Property
    var avatar: String?
    var gender: String?
    var degree: String?
    var teaching_age: Int = 0
    var level: Int = 1
    var subject: String?
    var grades: [String] = []
    var tags: [String] = []
    var photo_set: [String]? = []
    var achievement_set: [AchievementModel?] = []
    var highscore_set: [HighScoreModel?] = []
    var prices: [GradePriceModel?] = []
    var min_price: Int = 0
    var max_price: Int = 0
    var published: Bool = false
    var favorite: Bool = false
    
    // 分享信息
    var shareText: String {
        get {
            guard let teacherName = name, let teacherSubject = subject else {
            return "优秀的麻辣老师"
            }
            return String(format: "%@，%@老师，%@！", teacherName, teacherSubject, tags.joined(separator: "，"))
        }
    }
    // 分享链接
    var shareURL: URL? {
        get {
            #if USE_PRD_SERVER
                return URL(string: String(format: "https://www.malalaoshi.com/wechat/teacher/?teacherid=%d", id))
            #elseif USE_STAGE_SERVER
                return URL(string: String(format: "https://stage.malalaoshi.com/wechat/teacher/?teacherid=%d", id))
            #else
                return URL(string: String(format: "http://dev.malalaoshi.com/wechat/teacher/?teacherid=%d", id))
            #endif
            
        }
    }
    
    
    // 视图变量
    var teachingAgeString: String {
        get {
            return String(format: "%d年", teaching_age)
        }
    }
    var levelString: String {
        get {
            return String(format: "T%d", level)
        }
    }
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    override init(dict: [String: Any]) {
        super.init(dict: dict)
        setValuesForKeys(dict)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("TeacherDetailModel - Set for UndefinedKey: \(key)")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "highscore_set" {
            if let dicts = value as? [[String: AnyObject]] {
                var tempDict: [HighScoreModel?] = []
                for dict in dicts {
                    let set = HighScoreModel(dict: dict)
                    tempDict.append(set)
                }
                highscore_set = tempDict
            }
            return
        }
        if key == "achievement_set" {
            if let dicts = value as? [[String: AnyObject]] {
                var tempDict: [AchievementModel?] = []
                for dict in dicts {
                    let set = AchievementModel(dict: dict)
                    tempDict.append(set)
                }
                achievement_set = tempDict
            }
            return
        }
        if key == "prices" {
            if let dicts = value as? [[String: AnyObject]] {
                var tempDict: [GradePriceModel?] = []
                for dict in dicts {
                    let set = GradePriceModel(dict: dict)
                    tempDict.append(set)
                }
                prices = tempDict
            }
            return
        }
        super.setValue(value, forKey: key)
    }
}
