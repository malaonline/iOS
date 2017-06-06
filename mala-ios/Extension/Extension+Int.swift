//
//  Extension+Int.swift
//  mala-ios
//
//  Created by 王新宇 on 3/7/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import Foundation

// MARK: - Convenience
extension Int {
    public var money: String {
        get {
            #if USE_PRD_SERVER
                return String(format: "%@", String(Int(self)/100))
            #else
                return String(format: "%@", String(Double(self)/100))
            #endif
        }
    }
    /// 优惠前总价中文文字
    public var priceCNY: String {
        get {
            return self == 0 ? "￥0.00" : String(format: "￥%.2f", Double(self)/100)
        }
    }
    /// 优惠后最终价格中文文字
    public var amountCNY: String {
        get {
            if self == 0 {
                /// 若原总价不为零，则返回0.01（至少需支付1分钱完成支付逻辑）
                return MalaCurrentCourse.getOriginalPrice() == 0 ? "￥0.00" : "￥0.01"
            }
            return String(format: "￥%.2f", Double(self)/100)
        }
    }
    
    public var moneyInt: Int {
        get {
            return Int(Double(self)/100)
        }
    }
    
    public var liveCoursePrice: String {
        get {
            #if USE_PRD_SERVER
                return String(format: "¥%@", String(Int(self)/100))
            #else
                return String(format: "¥%@", String(Double(self)/100))
            #endif
        }
    }
}
