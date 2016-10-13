//
//  MalaDataCenter.swift
//  mala-ios
//
//  Created by 王新宇 on 3/3/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

///  获取第一个可用的优惠券对象
///
///  - parameter coupons: 优惠券模型数组
func getFirstUnusedCoupon(_ coupons: [CouponModel]) -> CouponModel? {
    for coupon in coupons {
        if coupon.status == .unused {
            return coupon
        }
    }
    return nil
}

///  根据时间戳(优惠券有效期)判断优惠券是否过期
///
///  - parameter timeStamp: 有效期时间戳
///
///  - returns: Bool
func couponIsExpired(_ timeStamp: TimeInterval) -> Bool {
    let date = Date(timeIntervalSince1970: timeStamp)
    let result = Date().compare(date)
    
    switch result {
        // 有效期大于当前时间，未过期
    case .orderedAscending:
        return false
        
        // 时间相同，已过期（考虑到后续操作所消耗的时间）
    case .orderedSame:
        return true
        
        // 当前时间大于有效期，已过期
    case .orderedDescending:
        return true
    }
}


///  根据支付方式获取AppURLScheme
///
///  - parameter channel: 支付手段
///
///  - returns: URLScheme
func getURLScheme(_ channel: MalaPaymentChannel) -> String {
    switch channel {
    case .Alipay:
        return MalaAppURLScheme.Alipay.rawValue
        
    case .Wechat:
        return MalaAppURLScheme.Wechat.rawValue
        
    case .Other:
        return ""
    }
}
