//
//  UserExerciseMistake.swift
//  mala-ios
//
//  Created by 王新宇 on 16/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class UserExerciseMistake: NSObject {

    var total: Int = 0
    var english: Int = 0
    var math: Int = 0
    
    
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
    
    
    // MARK: - Description
    override open var description: String {
        let keys = ["total", "english", "math"]
        return "\n"+dictionaryWithValues(forKeys: keys).description+"\n"
    }
}
