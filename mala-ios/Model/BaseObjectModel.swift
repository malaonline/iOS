//
//  BaseObjectModel.swift
//  mala-ios
//
//  Created by Elors on 15/12/21.
//  Copyright © 2015年 Mala Online. All rights reserved.
//

import UIKit

open class BaseObjectModel: NSObject, NSCoding {

    // MARK: - Property
    var id: Int = 0
    var name: String?
    

    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int ?? 0
        self.name = aDecoder.decodeObject(forKey: "name") as? String
    }
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    
    // MARK: - Override
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("BaseObjectModel - Set for UndefinedKey: \(key)")
    }
    
    // MARK: - Coding
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
    
    
    // MARK: - Description
    override open var description: String {
        let keys = ["id", "name"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
