//
//  OrderForm.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

/// 订单模型
class OrderForm: BaseObjectModel {
    
    // MARK: - Property
    
    // MARK: 创建订单参数
    /// 老师id
    var teacher: Int = 0
    
    /// 学校id
    var school: Int = 0
    
    /// 年级id
    var grade: Int = 0
    
    /// 学科id
    var subject: Int = 0
    
    /// 奖学金券id
    var coupon: Int = 0
    
    /// 课程小时数
    var hours: Int = 0
    
    /// 所选上课时间区块id
    var weeklyTimeSlots: [Int]? = []
    
    /// 直播课程id（实际对应某一间教室／班级）
    var liveClassId: Int? = 0
    
    /// 直播课程模型
    var liveClass: LiveClassModel?
    
    // MARK: 订单结果参数
    /// 订单编号
    var orderId: String?
    
    /// 下单用户id（家长）
    var parent: Int = 0
    
    /// 优惠前价格／全价
    var total: Int = 0
    
    /// 优惠后价格／实际支付价格
    var price: Int = 0
    
    /// 订单状态
    /// -see: MalaOrderStatus
    var status: String?
    
    /// 是否被抢买标记
    /// 例如: 若支付过程中课程被抢买，此参数应为为false
    var isTimeslotAllocated: Bool?
    
    // MARK: 订单显示信息
    /// 老师姓名
    var teacherName: String?
    
    /// 学科名
    var subjectName: String?
    
    /// 年级名
    var gradeName: String?
    
    /// 上课地点
    var schoolName: String?
    
    /// 上课地点 - 详细地址
    var schoolAddress: String?
    
    /// 老师头像URL
    var avatarURL: String?
    
    /// 优惠后价格／实际支付价格
    var amount: Int = 0
    
    /// 是否已建档测评标记
    var evaluated: Bool?
    
    /// 上课时间表
    var timeSlots: [[TimeInterval]]? = []
    
    /// 支付渠道
    var chargeChannel: String? = "other"
    
    /// 创建订单时间
    var createdAt: TimeInterval? = 0
    
    /// 支付时间
    var paidAt: TimeInterval? = 0
    
    /// 上课老师是否上架标记
    var isTeacherPublished: Bool?  = false
    
    /// 订单创建失败结果
    var result: Bool?
    
    /// 订单创建失败错误码
    var code: Int?
    
    /// 直播课程标记
    var isLiveCourse: Bool?
    
    /// 支付渠道（枚举）
    var channel: MalaPaymentChannel {
        set{
            self.chargeChannel = newValue.rawValue
        }
        get{
            if let channel = MalaPaymentChannel(rawValue: self.chargeChannel ?? "other") {
                return channel
            }else {
                return .Other
            }
        }
    }
    
    /// 订单状态
    var orderStatus: MalaOrderStatus? {

        if let status = status {
            switch status {
            case "u":
                /// 待支付
                return .penging
                
            case "p":
                /// 已完成(不可退费)
                if
                    let timeSlots = timeSlots,
                    let slots = timeSlots.first,
                    let lastSlots = slots.first,
                    lastSlots <= Date().timeIntervalSince1970,
                    isLiveCourse == true {
                    return .finished
                }
                /// 已支付(进行中, 可退费)
                if isLiveCourse == true {
                    return .paidRefundable
                }
                /// 已支付(进行中, 不可退费)
                if isLiveCourse == false {
                    return .paid
                }
                break
                
            case "r":
                /// 已退款
                return .refund
                
            case "d":
                /// 已取消
                return .canceled
                
            case "c":
                /// 订单预览
                return .confirm
                
            default:
                return nil
            }
        }else {
            return nil
        }
        return nil
    }
    
    var attrAddressString: NSMutableAttributedString {
        get {
            return makeAddressAttrString(schoolName, schoolAddress)
        }
    }
    
    var attrTeacherString: NSMutableAttributedString {
        get {
            return makeTeacherAttrString(liveClass?.lecturerName, liveClass?.assistantName)
        }
    }
    
    
    // MARK: - Instance Method
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
    
    /// convenience method for create a order model with liveClass id
    /// usually use to create a live course order
    ///
    /// - parameter classId: id of live class(course)
    ///
    /// - returns: order model
    convenience init(classId: Int) {
        self.init()
        self.liveClassId = classId
    }
    
    /// convenience method for create a order model with errorCode when request failure
    ///
    /// - parameter result: always return false when request failure
    /// - parameter code:   errorCode
    ///
    /// - returns: order model
    convenience init(result: Bool, code: Int) {
        self.init()
        self.result = result
        self.code = code
    }
    
    /// convenience method for create a order model when request success
    ///
    /// - parameter id:     id
    /// - parameter amount: money that user paid
    ///
    /// - returns: order model
    convenience init(id: Int, amount: Int) {
        self.init()
        self.id = id
        self.amount = amount
    }
    
    
    // MARK: - Override
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "teacher_name", let string = value as? String {
            teacherName = string
            return
        }
        if key == "teacher_avatar", let string = value as? String {
            avatarURL = string
            return
        }
        if key == "school_id", let int = value as? Int {
            school = int
            return
        }
        if key == "school", let string = value as? String {
            schoolName = string
            return
        }
        if key == "school_address", let string = value as? String {
            schoolAddress = string
            return
        }
        if key == "grade" {
            if let string = value as? String { gradeName = string } else { gradeName = "" }
            return
        }
        if key == "order_id", let string = value as? String {
            orderId = string
            return
        }
        if key == "to_pay", let int = value as? Int {
            amount = int
            return
        }
        if key == "created_at", let timeInterval = value as? TimeInterval {
            createdAt = timeInterval
            return
        }
        if key == "paid_at", let timeInterval = value as? TimeInterval {
            paidAt = timeInterval
            return
        }
        if key == "charge_channel", let string = value as? String {
            chargeChannel = string
            return
        }
        if key == "is_teacher_published", let bool = value as? Bool {
            isTeacherPublished = bool
            return
        }
        if key == "is_timeslot_allocated", let bool = value as? Bool {
            isTimeslotAllocated = bool
            return
        }
        if key == "timeslots", let array = value as? [[TimeInterval]] {
            timeSlots = array
            return
        }
        if key == "live_class", let dict = value as? [String: AnyObject] {
            liveClass = LiveClassModel(dict: dict)
            return
        }
        if key == "is_live", let bool = value as? Bool {
            isLiveCourse = bool
            return
        }
        super.setValue(value, forKey: key)
    }
    
    
    // MARK: - Description
    override var description: String {
        let keys = ["id"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    
    // MARK: - Dictionary Method
    /// 快速转出[一对一]订单参数字典
    func jsonDictionary() -> JSON {
        
        let teacher = self.teacher
        let school = self.school
        let grade = self.grade
        let subject = self.subject
        let hours = self.hours
        let coupon = self.coupon
        let timeslots = (self.weeklyTimeSlots ?? [])
        
        var json: JSON = [
            "teacher": teacher ?? 0,
            "school": school,
            "grade": grade,
            "subject": subject,
            "hours": hours,
            "coupon": coupon,
            "weekly_time_slots": timeslots,
        ]
        if coupon == 0 {
            json["coupon"] = NSNull()
        }
        return json
    }
    
    /// 快速转出[双师直播]订单参数字典
    func jsonForLiveCourse() -> JSON {
        return [
            "live_class": liveClassId ?? 0
        ]
    }
}
