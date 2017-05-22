//
//  GradeModel.swift
//  mala-ios
//
//  Created by Elors on 12/21/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class GradeModel: BaseObjectModel {

    // MARK: - Property
    var subset: [GradeModel]? = []
    var subjects: [NSNumber] = []
    
    /// 价格阶梯
    var prices: [GradePriceModel]? = []
    
    
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
    
    convenience init(id: Int, name: String, prices: [[String: AnyObject]]) {
        self.init()
        self.id = id
        self.name = name
        self.setValue(prices, forKey: "prices")
    }
    
    convenience init(id: Int, name: String, price: [GradePriceModel]) {
        self.init()
        self.id = id
        self.name = name
        self.prices = price
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("GradeModel - Set for UndefinedKey: \(key)")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "subset" {
            if let dicts = value as? [[String: AnyObject]] {
                var tempDict: [GradeModel]? = []
                for dict in dicts {
                    let set = GradeModel(dict: dict)
                    tempDict?.append(set)
                }
                subset = tempDict
            }
            return
        }
        if key == "prices" {
            if let dicts = value as? [[String: AnyObject]] {
                var tempDict: [GradePriceModel]? = []
                for dict in dicts {
                    let set = GradePriceModel(dict: dict)
                    tempDict?.append(set)
                }
                prices = tempDict
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["id", "name", "subset", "subjects"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
