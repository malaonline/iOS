//
//  UserExerciseRecord.swift
//  mala-ios
//
//  Created by 王新宇 on 16/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class UserExerciseRecord: NSObject, NSCoding {
    
    var student: String = ""
    var school: String = ""
    var mistakes: UserExerciseMistake?
    
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init()
        self.student = aDecoder.decodeObject(forKey: "student") as? String ?? ""
        self.school = aDecoder.decodeObject(forKey: "school") as? String ?? ""
        self.mistakes = aDecoder.decodeObject(forKey: "mistakes") as? UserExerciseMistake
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "numbers" {
            if let dict = value as? [String: AnyObject] {
                mistakes = UserExerciseMistake(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    // MARK: - Coding
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(student, forKey: "student")
        aCoder.encode(school, forKey: "school")
        aCoder.encode(mistakes, forKey: "mistakes")
    }
    
    // MARK: - Description
    override open var description: String {
        let keys = ["student", "school", "mistakes"]
        return "\n"+dictionaryWithValues(forKeys: keys).description+"\n"
    }
}
