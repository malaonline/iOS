//
//  ExerciseMistakeRecord.swift
//  mala-ios
//
//  Created by 王新宇 on 18/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class ExerciseMistakeRecord: BaseObjectModel {
    
    var submitOption: Int = 0
    var updatedAt: TimeInterval = 0
    var exerciseGroup: BaseObjectModel?
    var exercise: Exercise?
    
    
    // MARK: - Instance Method
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
    
    init(id: Int, submit: Int, updatedAt: TimeInterval, group: BaseObjectModel, exercise: Exercise) {
        super.init()
        self.id = id
        self.submitOption = submit
        self.updatedAt = updatedAt
        self.exerciseGroup = group
        self.exercise = exercise
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "submit_option", let number = value as? Int {
            submitOption = number
            return
        }
        if key == "updated_at", let number = value as? TimeInterval {
            updatedAt = number
            return
        }
        if key == "question_group" {
            if let dict = value as? [String: AnyObject] {
                exerciseGroup = BaseObjectModel(dict: dict)
            }
            return
        }
        if key == "question" {
            if let dict = value as? [String: AnyObject] {
                exercise = Exercise(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
}
