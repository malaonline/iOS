//
//  UserExerciseRecord.swift
//  mala-ios
//
//  Created by 王新宇 on 16/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class UserExerciseRecord: NSObject {
    
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
        fatalError("init(coder:) has not been implemented")
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
    
    
    // MARK: - Description
    override open var description: String {
        let keys = ["student", "school", "mistakes"]
        return "\n"+dictionaryWithValues(forKeys: keys).description+"\n"
    }
}
