//
//  AchievementModel.swift
//  mala-ios
//
//  Created by 王新宇 on 2/17/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class AchievementModel: NSObject {

    // MARK: - Property
    var title: String?
    var img: URL?
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    convenience init(title: String, img: URL) {
        self.init()
        self.title = title
        self.img = img
    }
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("AchievementModel - Set for UndefinedKey: \(key)")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "img" {
            if let urlString = value as? String {
                img = URL(string: urlString)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["title", "img"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
