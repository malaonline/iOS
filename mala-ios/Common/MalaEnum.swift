//
//  MalaEnum.swift
//  mala-ios
//
//  Created by 王新宇 on 3/2/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

///  验证码操作
///
///  - Send:   发送验证码
///  - Verify: 验证
enum VerifyCodeMethod: String {
    case Send = "send"
    case Verify = "verify"
}

///  支付操作
///
///  - Pay: 支付
enum PaymentMethod: String {
    case Pay = "pay"
}

///  支付手段
///  - See: [取值范围](https://www.pingxx.com/api#api-charges)
///  - Wechat:  微信支付
///  - Alipay:  支付宝手机支付
///  - QRPay:   扫码支付
///  - WxQR:    微信扫码支付
///  - AliQR:   支付宝扫码支付
enum MalaPaymentChannel: String {
    case Wechat = "wx"
    case Alipay = "alipay"
    case QRPay  = "qrPay"
    case WxQR   = "wx_pub_qr"
    case AliQR  = "alipay_qr"
    case Other  = "other"
}

///  跳转URLScheme
///
///  - Wechat: 微信
///  - Alipay: 支付宝
enum MalaAppURLScheme: String {
    case Wechat = "wx"
    case Alipay = "malalaoshitoalipay"
}

///  订单状态
///
///  - penging:             待付款
///  - paid:                已付款(不可退费)
///  - paidRefundable:      已付款(可退费)
///  - finished:            已付款(不可退费)
///  - refunding:           退费审核中
///  - refund:              已退费
///  - canceled:            已关闭
///  - confirm:             确认订单(for 订单预览)
enum MalaOrderStatus: String {
    case penging        = "u"
    case paid           = "p"
    case paidRefundable = "pl"
    case finished       = "f"
    case refunding      = "ri"
    case refund         = "r"
    case canceled       = "d"
    case confirm        = "c"
}

///  奖学金状态
///
///  - Unused:      未使用
///  - Used:        已使用
///  - Expired:     已过期
///  - Disabled:    已冻结
enum CouponStatus: Int {
    case unused
    case used
    case expired
    case disabled
}

///  价钱优惠类型
///
///  - Discount: 折扣 例如: [-] [￥400]
///  - Reduce:   免除 例如: [￥400(删除线)] [￥0]
///  - None: 不显示
enum PriceHandleType: Int {
    case discount
    case reduce
    case none
}

///  其他服务类型
///
///  - Coupon:           优惠券
///  - EvaluationFiling: 测评建档
enum OtherServiceType {
    case coupon
    case evaluationFiling
}

///  用户信息类型
///
///  - StudentName:       学生姓名
///  - StudentSchoolName: 学生学校姓名
public enum userInfoType {
    case studentName
    case studentSchoolName
}

///  通知类型
///
///  - Changed:     调课完成 -> 课表
///  - Stoped:      退费成功 -> 订单详情
///  - Finished:    课程结束 -> 我的评价
///  - Starting:    上课通知 -> 课表
///  - Maturity:    奖学金到期 -> 我的奖学金
///  - Livecourse:  双师课程活动 -> 课表
public enum RemoteNotificationType: Int {
    case changed = 1
    case refunds = 2
    case finished = 3
    case starting = 4
    case maturity = 5
    case livecourse = 6
}


// MARK: - ClassSchedule
///  课程进度状态
///
///  - past:   已过去
///  - today:  今天
///  - future: 未上
public enum CourseStatus: String {
    case Past = "past"
    case Today = "today"
    case Future = "future"
}


// MARK: - Study Report
///  学习报告状态
///
///  - Error:        数据获取错误
///  - LoggingIn:    登录中
///  - UnLogged:     未登录
///  - UnSigned:     登录未报名
///  - UnSignedMath: 报名非数学
///  - MathSigned:   报名数学
enum MalaLearningReportStatus: String {
    case Error = "er"
    case LoggingIn = "li"
    case UnLogged = "ul"
    case UnSigned = "l"
    case UnSignedMath = "us"
    case MathSigned = "sm"
}
///  学习报告-能力结构
///
///  - abstract: 抽象概括能力
///  - reason:   推理论证能力
///  - appl:     实际应用能力
///  - spatial:  空间想象能力
///  - calc:     运算求解能力
///  - data:     数据分析能力
///  - unkown:   未知(内部处理异常使用)
enum MalaStudyReportAbility: String {
    case abstract = "abstract"
    case reason = "reason"
    case appl = "appl"
    case spatial = "spatial"
    case calc = "calc"
    case data = "data"
    case unkown = "unkown"
}
