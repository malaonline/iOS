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
    
    
    // only for exercise-group
    var desc: String?
    
    /// first letter that object name transform in mandarin latin, default is "#".
    var firstLetter: String {
        get {
            return name?.applyingTransform(StringTransform.mandarinToLatin, reverse: false)?
                .applyingTransform(StringTransform.stripCombiningMarks, reverse: false)?.subStringToIndex(1) ?? "#"
        }
    }
    

    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.id = Int(aDecoder.decodeInt32(forKey: "id"))
        self.name = aDecoder.decodeObject(forKey: "name") as? String
    }
    
    convenience init(id: Int, name: String, desc: String = "") {
        self.init()
        self.id = id
        self.name = name
        self.desc = desc
    }
    
    
    // MARK: - Override
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("BaseObjectModel - Set for UndefinedKey: \(key)")
    }
    
    override open func setValue(_ value: Any?, forKey key: String) {
        if key == "title", let string = value as? String {
            name = string
            return
        }
        // only for option
        if key == "text", let string = value as? String {
            name = string
            return
        }
        if key == "description", let string = value as? String {
            desc = string
            return
        }
        super.setValue(value, forKey: key)
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
