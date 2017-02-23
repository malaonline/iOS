//
//  AppDelegate.swift
//  mala-ios
//
//  Created by Liang Sun on 11/6/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Google
import UserNotifications
import KSCrash


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    @nonobjc var window: BaseWindow?
    var deviceToken: Data?
    var notRegisteredPush = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Setup Window
        window = BaseWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let mainViewController = MainViewController()
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()

        customAppearance()
        registerThirdParty()
        return true
    }

    
    // MARK: - Life Cycle
    func applicationWillResignActive(_ application: UIApplication) {
        
        println("Will Resign Active")
        
        // 发生支付行为跳回时，取消遮罩
        ThemeHUD.hideActivityIndicator()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        println("Did Enter Background")
        
        MalaIsForeground = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        println("Will Enter Foreground")
        
        MalaIsForeground = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        println("Did Become Active")
        
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
    // MARK: - openURL
    private func application(_ app: UIApplication, openURL url: URL, options: [String : AnyObject]) -> Bool {
        
        // 微信,支付宝 回调
        let canHandleURL = Pingpp.handleOpen(url) { (result, error) -> Void in
            // 处理Ping++回调
            let handler = HandlePingppBehaviour()
            handler.handleResult(result, error: error, currentViewController: MalaPaymentController)
        }
        return canHandleURL
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // 微信,支付宝 回调
        let canHandleURL = Pingpp.handleOpen(url) { (result, error) -> Void in
            // 处理Ping++回调
            let handler = HandlePingppBehaviour()
            handler.handleResult(result, error: error, currentViewController: MalaPaymentController)
        }
        return canHandleURL
    }
    
    
    // MARK: - ThirdParty Configuration
    func registerThirdParty(launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) {

        #if USE_PRD_SERVER
            // Configure tracker from GoogleService-Info.plist.
            var configureError:NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
        #endif
        
        #if USE_DEV_SERVER
            Pingpp.setDebugMode(true)
        #endif
        
        IQKeyboardManager.sharedManager().enable = true
        ToastManager.shared.duration = 1.0
        
        // 社会化组件
        ShareSDK.registerApp(MalaShareSDKAppId,
            activePlatforms: [
                SSDKPlatformType.subTypeWechatSession.rawValue,
                SSDKPlatformType.subTypeWechatTimeline.rawValue
            ],
            onImport: { (platformType) in
                switch platformType{
                case .typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
            }, onConfiguration: { (platformType, appInfo) in
                switch platformType {
                case .typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: MalaWeChatAppId, appSecret: "")
                    break
                default:
                    break
                }
        })
        
        // 注册并请求推送权限
        if #available(iOS 10.0, *) {
            let entity = JPUSHRegisterEntity()
            let types: UNAuthorizationOptions = [.alert, .badge, .sound]
            entity.types = Int(types.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        }else {
            let kUserNotificationBSA: UIUserNotificationType = [.alert, .badge, .sound]
            JPUSHService.register(forRemoteNotificationTypes: kUserNotificationBSA.rawValue, categories: nil)
        }
        
        // 配置JPush
        JPUSHService.setup(withOption: launchOptions, appKey: Mala_JPush_AppKey, channel: "AppStore", apsForProduction: true)

        if let options = launchOptions, MalaUserDefaults.isLogined {
            // 记录启动通知类型
            if let notification = options[UIApplicationLaunchOptionsKey.remoteNotification] as? UILocalNotification,
                let userInfo = notification.userInfo {
                _ = MalaRemoteNotificationHandler().handleRemoteNotification(userInfo)
            }
        }
        
        // Crash Report
        let installation = KSCrashInstallationStandard.sharedInstance()
        installation?.url = NSURL(string: "https://collector.bughd.com/kscrash?key=58aca1df617af73f8cdf7c54a1f54560") as? URL
        installation?.install()
        installation?.sendAllReports(completion: nil)
    }

    
    // MARK: - Appearance
    /// 设置公共外观样式
    private func customAppearance() {
        
        // NavigationBar
        UINavigationBar.appearance().tintColor = UIColor(named: .ArticleSubTitle)
        UINavigationBar.appearance().setBackgroundImage(UIImage.withColor(UIColor.white), for: .default)
        
        // TabBar
        UITabBar.appearance().tintColor = UIColor(named: .ThemeBlue)
    }  
}


// MARK: - Public Method
extension AppDelegate {
    /// 显示登陆页面
    func showLoginView() {
        
        let loginViewController = LoginViewController()
        loginViewController.closeAction = MalaCurrentCancelAction
        
        window?.rootViewController?.present(
            UINavigationController(rootViewController: loginViewController),
            animated: true,
            completion: { () -> Void in
                
        })
    }
    
    ///  切换到首页
    func switchToStart() {
        window?.rootViewController = MainViewController()
    }
    
    ///  切换到TabBarController指定控制器
    ///
    ///  - parameter index: 指定控制器下标
    func switchTabBarControllerWithIndex(_ index: Int) {
        guard let tabbarController = window?.rootViewController as? MainViewController
            , index <= ((tabbarController.viewControllers?.count ?? 0)-1) && index >= 0 else {
                return
        }
        tabbarController.selectedIndex = index
    }
}


// MARK: - JPUSHRegisterDelegate
extension AppDelegate: JPUSHRegisterDelegate {
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        println("JPush willPresent - \(userInfo)")
        guard notification.request.trigger is UNPushNotificationTrigger else { return }
        JPUSHService.handleRemoteNotification(userInfo)
        _ = MalaRemoteNotificationHandler().handleRemoteNotification(userInfo)
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        println("JPush didReceive - \(userInfo)")
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
            _ = MalaRemoteNotificationHandler().handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
}


// MARK: - APNs
extension AppDelegate {
    
    func registerJPush(withDeciveToken deviceToken: Data, id: String) {
        JPUSHService.registerDeviceToken(deviceToken)
        JPUSHService.setTags(Set(["iOS"]), alias: id, fetchCompletionHandle: { (resCode, tags, alias) -> Void in
            println("JPUSH setTags CallBack: \nrescode: \(resCode), \ntags: \(tags), \nalias: \(alias)\n")
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let id = MalaUserDefaults.userID.value, notRegisteredPush {
            notRegisteredPush = false
            registerJPush(withDeciveToken: deviceToken, id: String(id))
        }
        // 记录设备token，用于初次登录或注册有 userID 后，或“注销再登录”
        self.deviceToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        println("Did Receive Remote Notification - \(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo)
        
        guard MalaUserDefaults.isLogined else { return }
        guard MalaRemoteNotificationHandler().handleRemoteNotification(userInfo as [NSObject : AnyObject]) else { return }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        println(String(format: "Fail To Register For Remote Notifications With Error: %@", error as CVarArg))
    }
}
