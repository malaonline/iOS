//
//  GradePriceModel.swift
//  mala-ios
//
//  Created by Elors on 12/29/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class GradePriceModel: NSObject {

    // MARK: - Property
    var grade: BaseObjectModel?
    var price: Int = 0
    
    // 阶梯定价
    var min_hours: Int = 0
    var max_hours: Int = 0
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    convenience init(name: String, id: Int, price: Int) {
        self.init()
        let grade = BaseObjectModel(id: id, name: name)
        self.grade = grade
        self.price = price
    }
    
    convenience init(minHours: Int, maxHours: Int, price: Int) {
        self.init()
        self.min_hours = minHours
        self.max_hours = maxHours
        self.price = price
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("GradePriceModel - Set for UndefinedKey: \(key)")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "grade" {
            if let dict = value as? [String: AnyObject] {
                let model = BaseObjectModel(dict: dict)
                grade = model
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["min_hours", "max_hours", "price"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
