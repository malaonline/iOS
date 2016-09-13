//
//  BaseObjectModel.swift
//  mala-ios
//
//  Created by Elors on 15/12/21.
//  Copyright © 2015年 Mala Online. All rights reserved.
//

import UIKit

public class BaseObjectModel: NSObject, NSCoding {

    // MARK: - Property
    var id: Int = 0
    var name: String?
    

    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as? Int ?? 0
        self.name = aDecoder.decodeObjectForKey("name") as? String
    }
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    
    // MARK: - Override
    override public func setValue(value: AnyObject?, forUndefinedKey key: String) {
        println("BaseObjectModel - Set for UndefinedKey: \(key)")
    }
    
    
    // MARK: - Coding
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
    }
    
    
    // MARK: - Description
    override public var description: String {
        let keys = ["id", "name"]
        return dictionaryWithValuesForKeys(keys).description
    }
}
