//
//  Exercise.swift
//  mala-ios
//
//  Created by 王新宇 on 18/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class Exercise: BaseObjectModel {

    var solution: Int = 0
    var explanatioin: String = ""
    var options: [BaseObjectModel] = []
    
    
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
    
    init(id: Int, title: String, solution: Int, exp: String, options: [BaseObjectModel]) {
        super.init()
        self.id = id
        self.name = title
        self.solution = solution
        self.explanatioin = exp
        self.options = options
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "solution", let number = value as? Int {
            solution = number
            return
        }
        if key == "explanation", let string = value as? String {
            explanatioin = string
            return
        }
        if key == "options" {
            if let dicts = value as? [[String: AnyObject]] {
                for dict in dicts {
                    options.append(BaseObjectModel(dict: dict))
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
}
