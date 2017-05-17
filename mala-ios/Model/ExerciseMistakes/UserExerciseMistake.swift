//
//  UserExerciseMistake.swift
//  mala-ios
//
//  Created by 王新宇 on 16/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class UserExerciseMistake: NSObject, NSCoding {

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
        self.total = aDecoder.decodeObject(forKey: "total") as? Int ?? 0
        self.english = aDecoder.decodeObject(forKey: "english") as? Int ?? 0
        self.math = aDecoder.decodeObject(forKey: "math") as? Int ?? 0
    }
    
    // MARK: - Coding
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(total, forKey: "total")
        aCoder.encode(english, forKey: "english")
        aCoder.encode(math, forKey: "math")
    }
    
    // MARK: - Description
    override open var description: String {
        let keys = ["total", "english", "math"]
        return "\n"+dictionaryWithValues(forKeys: keys).description+"\n"
    }
}
