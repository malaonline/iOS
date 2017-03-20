//
//  MemberServiceModel.swift
//  mala-ios
//
//  Created by Elors on 1/12/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class MemberServiceModel: BaseObjectModel {

    // MARK: - Property
    var detail: String?
    var enbaled: Bool = false
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    override init(dict: [String: Any]) {
        super.init(dict: dict)
        setValuesForKeys(dict)
    }
    
    convenience init(name: String?, detail: String?) {
        self.init()
        self.name = name
        self.detail = detail
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("SchoolModel - Set for UndefinedKey: \(key)")
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["detail", "enbaled"]
        return super.description + dictionaryWithValues(forKeys: keys).description
    }
}
