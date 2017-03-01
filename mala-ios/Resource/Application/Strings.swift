//
//  String.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/2/28.
//  Copyright © 2017年 Mala Online. All rights reserved.
//
// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
    /// 取消
    static let cancel = L10n.tr("cancel")
    /// 麻辣老师
    static let mala = L10n.tr("mala")
    /// 会员专享
    static let member = L10n.tr("member")
    /// 我的
    static let profile = L10n.tr("profile")
    /// 课表
    static let schedule = L10n.tr("schedule")
    /// 找老师
    static let teacher = L10n.tr("teacher")
    /// 标题
    static let title = L10n.tr("title")
    /// 其他
    static let other = L10n.tr("other")
    
    enum Chart {
        /// 圆
        static let circle = L10n.tr("chart.circle")
        /// 全等
        static let congruent = L10n.tr("chart.congruent")
        /// 函数初步
        static let function = L10n.tr("chart.func")
        /// 多边形
        static let polygon = L10n.tr("chart.polygon")
        /// 实数
        static let realNumber = L10n.tr("chart.realNumber")
        /// 相似
        static let similar = L10n.tr("chart.similar")
        
        enum Geo {
            /// 几何操作
            static let operation = L10n.tr("chart.geo.operation")
            /// 几何变换
            static let transfor = L10n.tr("chart.geo.transfor")
        }
    }
    
    enum Comment {
        /// 请写下对老师的感受吧，对他人的帮助很大哦~最多可输入200字
        static let placeholder = L10n.tr("comment.placeholder")
    }
    
    enum Login {
        /// 验证码
        static let code = L10n.tr("login.code")
        /// 手机号
        static let phone = L10n.tr("login.phone")
    }
    
    enum Order {
        
        enum Error {
            /// 您已报名参加该课程，请勿重复购买
            static let bought = L10n.tr("order.error.bought")
            /// 奖学金使用信息有误，请重新选择
            static let coupon = L10n.tr("order.error.coupon")
            /// 所选课程名额已满，请选择其他课程
            static let full = L10n.tr("order.error.full")
            /// 该老师部分时段已被占用，请重新选择上课时间
            static let timeslot = L10n.tr("order.error.timeslot")
        }
    }
    
    enum Pay {
        
        enum Channel {
            /// 支付宝支付
            static let alipay = L10n.tr("pay.channel.alipay")
            /// 微信支付
            static let wechat = L10n.tr("pay.channel.wechat")
        }
        
        enum Normal {
            
            enum Error {
                /// 订单已失效，请重新下单
                static let expire = L10n.tr("pay.Normal.error.expire")
                /// 订单状态错误，请重试
                static let unknown = L10n.tr("pay.Normal.error.unknown")
            }
        }
        
        enum Qrcode {
            /// 家长完成支付后 点击支付完成按钮
            static let info = L10n.tr("pay.QRCode.info")
            
            enum Error {
                /// 支付宝二维码获取错误
                static let alipay = L10n.tr("pay.QRCode.error.alipay")
                /// 支付凭证获取错误
                static let credential = L10n.tr("pay.QRCode.error.credential")
                /// 二维码获取错误
                static let `get` = L10n.tr("pay.QRCode.error.get")
                /// 支付信息获取错误
                static let info = L10n.tr("pay.QRCode.error.info")
                /// 微信支付二维码获取错误
                static let wechat = L10n.tr("pay.QRCode.error.wechat")
            }
            
            enum Alert {
                /// 请完成付款后，点击支付完成
                static let unpaid = L10n.tr("pay.QRCode.alert.unpaid")
            }
        }
        
        enum Result {
            /// 支付完成
            static let success = L10n.tr("pay.result.success")
        }
    }
    
    enum Teacher {
        /// 课程购买
        static let choosing = L10n.tr("teacher.choosing")
        /// 测评建档服务
        static let evaluation = L10n.tr("teacher.evaluation")
        /// 筛选结果
        static let filterResult = L10n.tr("teacher.filterResult")
    }
    
    enum Toast {
        
        enum Error {
            /// 网络环境较差，请稍后重试
            static let notReachable = L10n.tr("toast.error.notReachable")
        }
    }
}

extension L10n {
    fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}
