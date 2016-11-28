//
//  MalaRemoteNotificationHandler.swift
//  mala-ios
//
//  Created by 王新宇 on 3/24/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit


open class MalaRemoteNotificationHandler: NSObject {

    // MARK: - Property
    /// 通知类型键
    open let kNotificationType = "type"
    /// 附带参数键（暂时仅当type为2时，附带code为订单号）
    open let kNotificationCode = "code"
    
    /// 远程推送通知处理对象
    private var remoteNotificationTypeHandler: RemoteNotificationType? {
        willSet {
            println("远程推送通知处理对象 - \(newValue)")
            if let type = newValue,
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let apsInfo = notificationInfo["aps"] as? [AnyHashable: Any],
                let message = apsInfo["alert"] as? String {
                
                // 提示信息
                var title: String = ""
                // 提示确认闭包
                var action: ()->() = {
                    /// 课表页
                    appDelegate.switchTabBarControllerWithIndex(1)
                }
                
                ///  匹配信息类型
                switch type {
                    
                case .changed:
                    title = "课程变动"
                    
                case .refunds:
                    title = "退费成功"
                    action = {
                        /// 订单详情页
                        if let viewController = getActivityViewController() {
                            let orderFormViewController = OrderFormInfoViewController()
                            orderFormViewController.id = self.code
                            orderFormViewController.hidesBottomBarWhenPushed = true
                            viewController.navigationController?.pushViewController(orderFormViewController, animated: true)
                        }
                    }
            
                case .finished:
                    title = "完课评价"
                    action = {
                        /// 我的评价
                        if let viewController = getActivityViewController() {
                            let commentViewController = CommentViewController()
                            commentViewController.hidesBottomBarWhenPushed = true
                            viewController.navigationController?.pushViewController(commentViewController, animated: true)
                        }
                    }
                
                case .starting:
                    title = "课前通知"
                    
                case .maturity:
                    title = "奖学金即将到期"
                    action = {
                        /// 我的奖学金
                        if let viewController = getActivityViewController() {
                            let couponViewController = CouponViewController()
                            couponViewController.hidesBottomBarWhenPushed = true
                            viewController.navigationController?.pushViewController(couponViewController, animated: true)
                        }
                    }
                    
                case .livecourse:
                    title = "双师课程活动"
                }
                
                // 若当前在前台，弹出提示
                if MalaIsForeground {
                    
                    // 获取当前控制器
                    if let viewController = getActivityViewController() {
                        
                        MalaAlert.confirmOrCancel(
                            title: title,
                            message: message,
                            confirmTitle: "去查看",
                            cancelTitle: "知道了",
                            inViewController: viewController,
                            withConfirmAction: action, cancelAction: {})
                    }
                }
                
            }
        }
    }
    
    /// 通知信息字典
    private var notificationInfo: [AnyHashable: Any] = [AnyHashable: Any]()
    /// 附带参数（订单号）
    private var code: Int = 0 {
        didSet {
            println("code - \(code)")
        }
    }
    
    
    // MARK: - Method
    ///  处理APNs
    ///
    ///  - parameter userInfo: 通知信息字典
    open func handleRemoteNotification(_ userInfo: [AnyHashable: Any]) -> Bool {
        if let type = Int(userInfo[kNotificationType] as? String ?? "0"),
            let remoteNotificationType = RemoteNotificationType(rawValue: type) {
            
            if let code = Int(userInfo[kNotificationCode] as? String ?? "0") {
                self.code = code
            }
            
            notificationInfo = userInfo
            remoteNotificationTypeHandler = remoteNotificationType
            
            return true
        }else {
            return false
        }
    }
}
