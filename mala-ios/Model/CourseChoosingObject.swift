//
//  CourseChoosingObject.swift
//  mala-ios
//
//  Created by 王新宇 on 2/24/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

// MARK: - 课程购买模型
class CourseChoosingObject: NSObject {
    
    // MARK: - Property
    /// 授课年级
    dynamic var grade: GradeModel? {
        didSet {
            println("MalaCurrentCourse - Grade - \(grade)")
            switchGradePrices()
        }
    }
    /// 上课时间
    dynamic var selectedTime: [ClassScheduleDayModel] = [] {
        didSet {
            isBeginEditing = true
            originalPrice = getOriginalPrice()
        }
    }
    /// 上课小时数
    dynamic var classPeriod: Int = 2 {
        didSet {
            isBeginEditing = true
            originalPrice = getOriginalPrice()
        }
    }
    /// 优惠券
    dynamic var coupon: CouponModel? {
        didSet {
            originalPrice = getOriginalPrice()
        }
    }
    /// 全部年级价格阶梯数据
    dynamic var grades: [GradeModel]? {
        didSet {
            originalPrice = getOriginalPrice()
        }
    }
    /// 当前年级价格阶梯
    dynamic var prices: [GradePriceModel]? = [] {
        didSet {
            originalPrice = getOriginalPrice()
        }
    }
    /// 原价
    dynamic var originalPrice: Int = 0
    /// 是否已开始选课标记(未开始选课时，还需支付数额返回0)
    var isBeginEditing: Bool = false
    
    
    // MARK: - API
    /// 切换当前价格梯度（与年级相对应）
    func switchGradePrices() {
        
        guard let currentGradeId = grade?.id, let grades = grades else {
            return
        }
        
        for grade in grades {
            if grade.id == currentGradeId {
                prices = grade.prices
                break
            }else {
                println("无与用户所选年级相对应的价格阶梯")
            }
        }
    }
    
    ///  根据当前选课条件获取价格, 选课条件不正确时返回0
    ///
    ///  - returns: 原价
    func getOriginalPrice() -> Int {
        // 验证[当前年级价格阶梯]［上课时间］［课时］
        if prices != nil && prices!.count > 0 && selectedTime.count != 0 && classPeriod >= selectedTime.count*2 {
            return prices![0].price * classPeriod
        }else {
            return 0
        }
    }
    
    /// 根据[所选课时][价格梯度]计算优惠后单价
    func calculatePrice() -> Int {
        for priceLevel in (prices ?? []) {
            if classPeriod >= priceLevel.min_hours && classPeriod <= priceLevel.max_hours {
                return priceLevel.price
            }
        }
        return 0
    }
    
    /// 获取最终需支付金额
    func getAmount() -> Int? {
        
        // 未开始选课时，还需支付数额返回0(例如初始化状态)
        if !isBeginEditing {
            return 0
        }
        
        // 根据价格阶梯计算优惠后价格
        var amount = calculatePrice() * classPeriod
        
        //  循环其他服务数组，计算折扣、减免
        //  暂时注释，目前仅有奖学金折扣
        /* for object in MalaServiceObject {
            switch object.priceHandleType {
            case .Discount:
                amount = amount - (object.price ?? 0)
                break
            case .Reduce:
                
                break
            }
        } */
        
        // 计算其他优惠服务
        if coupon != nil {
            amount = amount - (coupon?.amount ?? 0)
        }
        // 确保需支付金额不小于零
        amount = amount < 0 ? 0 : amount
        return amount
    }
    
    /// 重置选课模型
    func reset() {
        grade = nil
        selectedTime.removeAll()
        classPeriod = 2
        coupon = nil
        grades = nil
        prices = nil
        originalPrice = 0
        isBeginEditing = false
    }
}
