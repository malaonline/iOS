//
//  UserMessageCenterModel.swift
//  mala-ios
//
//  Created by 王新宇 on 16/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class UserMessageCenterModel: NSObject {
    
    // message
    var tocomments: Int = 0
    var unpaid: Int = 0
    
    // user exercise record
    var exerciseRecord: UserExerciseRecord?
    
    
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
        if key == "tocomment_num", let number = value as? Int {
            tocomments = number
            return
        }
        if key == "unpaid_num", let number = value as? Int {
            unpaid = number
            return
        }
        if key == "exercise_mistakes" {
            if let dict = value as? [String: AnyObject] {
                exerciseRecord = UserExerciseRecord(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    // MARK: - Description
    override open var description: String {
        let keys = ["tocomments", "unpaid", "exerciseRecord"]
        return "\n"+dictionaryWithValues(forKeys: keys).description+"\n"
    }
}
