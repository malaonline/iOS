//
//  CommentModel.swift
//  mala-ios
//
//  Created by 王新宇 on 3/21/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

open class CommentModel: BaseObjectModel {

    // MARK: - Property
    /// 课时数
    var timeslot: Int = 0
    /// 评分
    var score: Int = 0
    /// 评价内容
    var content: String = ""
    
    
    // MARK: - Constructed
    override init() {
        super.init()
    }
    
    override init(dict: [String: Any]) {
        super.init(dict: dict)
        setValuesForKeys(dict)
    }
    
    convenience init(id: Int, timeslot: Int, score: Int, content: String) {
        self.init()
        self.id = id
        self.timeslot = timeslot
        self.score = score
        self.content = content
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        println("CommentModel - Set for UndefinedKey: \(key)")
    }
    
    
    // MARK: - Description
    override open var description: String {
        let keys = ["id", "timeslot", "score", "content"]
        return "\n"+dictionaryWithValues(forKeys: keys).description+"\n"
    }
}
