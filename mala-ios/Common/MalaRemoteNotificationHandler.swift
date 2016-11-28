//
//  MalaRemoteNotificationHandler.swift
//  mala-ios
//
//  Created by 王新宇 on 3/24/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit


open class MalaRemoteNotificationHandler: NSObject {

    /// 通知类型键
    open let kNotificationType = "type"
    /// 附带参数键（暂时仅当type为2时，附带code为订单号）
    open let kNotificationCode = "code"
    
    
    // MARK: - Property
    /// 远程推送通知处理对象
    private var remoteNotificationTypeHandler: RemoteNotificationType? {
        willSet {
            processNotification(withType: newValue)
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
        guard let type = Int(userInfo[kNotificationType] as? String ?? "0") else { return false }
        guard let remoteNotificationType = RemoteNotificationType(rawValue: type) else { return false }
        
        if let code = Int(userInfo[kNotificationCode] as? String ?? "0") {
            self.code = code
        }
        
        notificationInfo = userInfo
        remoteNotificationTypeHandler = remoteNotificationType
        return true
    }
    
    
    /// 处理通知信息
    open func processNotification(withType type: RemoteNotificationType?) {
        
        guard let type = type else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let apsInfo = notificationInfo["aps"] as? [AnyHashable: Any] else { return }
        
        // 提示确认闭包
        var action: ()->() = {
            appDelegate.switchTabBarControllerWithIndex(1)
        }
        
        // 消息内容
        var title: String? = "通知消息"
        var subTitle: String? = ""
        var body: String? = "你有一条新消息"
        
        // 获取通知消息 [标题]、[副标题]、[消息内容]
        if let alert = apsInfo["alert"] as? String {
            body = alert
        }else if let alert = apsInfo["alert"] as? [AnyHashable: Any] {
            title = alert["title"] as? String
            subTitle = alert["subtitle"] as? String
            body = alert["body"] as? String
        }
        
        //  匹配消息类型
        switch type {
            
        case .changed:
            setIfNeed(&title, bak: "课程变动")
            
        case .refunds:
            setIfNeed(&title, bak: "退费成功")
            action = {
                // 订单详情页
                guard let viewController = getActivityViewController() else { return }
                let orderFormViewController = OrderFormInfoViewController()
                orderFormViewController.id = self.code
                orderFormViewController.hidesBottomBarWhenPushed = true
                viewController.navigationController?.pushViewController(orderFormViewController, animated: true)
            }
            
        case .finished:
            setIfNeed(&title, bak: "完课评价")
            action = {
                // 我的评价
                guard let viewController = getActivityViewController() else { return }
                let commentViewController = CommentViewController()
                commentViewController.hidesBottomBarWhenPushed = true
                viewController.navigationController?.pushViewController(commentViewController, animated: true)
            }
            
        case .starting:
            setIfNeed(&title, bak: "课前通知")
            
        case .maturity:
            setIfNeed(&title, bak: "奖学金即将到期")
            action = {
                // 我的奖学金
                guard let viewController = getActivityViewController() else { return }
                let couponViewController = CouponViewController()
                couponViewController.hidesBottomBarWhenPushed = true
                viewController.navigationController?.pushViewController(couponViewController, animated: true)
            }
            
        case .livecourse:
            setIfNeed(&title, bak: "双师课程活动")
            action = {
                // 课表页
                appDelegate.switchTabBarControllerWithIndex(0)
                guard let viewController = getActivityViewController() else { return }
            }
        }
        
        // 若当前在前台，弹出提示
        if MalaIsForeground {
            
            // 获取当前控制器
            if let viewController = getActivityViewController() {
                
                MalaAlert.confirmOrCancel(
                    title: title!,
                    message: body!,
                    confirmTitle: "去查看",
                    cancelTitle: "知道了",
                    inViewController: viewController,
                    withConfirmAction: action, cancelAction: {})
            }
        }
    }
    
}
