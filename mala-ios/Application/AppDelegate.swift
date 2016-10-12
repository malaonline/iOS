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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var deviceToken: Data?
    var notRegisteredPush = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        println("start")
        // Setup Window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let mainViewController = MainViewController()
        MalaMainViewController = mainViewController
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        println("end")
        // 全局的外观自定义
        customAppearance()
        registerThirdParty()
        
        // 配置JPush
        #if DevDebug
            JPUSHService.setup(withOption: launchOptions, appKey: Mala_JPush_AppKey, channel: "AppStore", apsForProduction: false)
        #else
            JPUSHService.setup(withOption: launchOptions, appKey: Mala_JPush_AppKey, channel: "AppStore", apsForProduction: true)
        #endif
        
        let kUserNotificationBSA: UIUserNotificationType = [.badge, .sound, .alert]
        JPUSHService.register(forRemoteNotificationTypes: kUserNotificationBSA.rawValue, categories: nil)
        
        if let options = launchOptions, MalaUserDefaults.isLogined {
            
            // 记录启动通知类型
            if let notification = options[UIApplicationLaunchOptionsKey.remoteNotification] as? UILocalNotification,
                let userInfo = notification.userInfo {
                _ = MalaRemoteNotificationHandler().handleRemoteNotification(userInfo)
            }
        }
        
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
    
    
    // MARK: - APNs
    func registerThirdPartyPushWithDeciveToken(_ deviceToken: Data, pusherID: String) {
        
        JPUSHService.registerDeviceToken(deviceToken as Data!)
        JPUSHService.setTags(Set(["iOS"]), alias: pusherID, callbackSelector:nil, object: nil)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        println("didRegisterForRemoteNotificationsWithDeviceToken - \(MalaUserDefaults.parentID.value)")
        
        if let parentID = MalaUserDefaults.parentID.value {
            if notRegisteredPush {
                notRegisteredPush = false
                registerThirdPartyPushWithDeciveToken((deviceToken as NSData) as Data, pusherID: String(parentID))
            }
        }
        
        // 纪录设备token，用于初次登录或注册有 pusherID 后，或“注销再登录”
        self.deviceToken = deviceToken
    }
    
    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        println("didReceiveRemoteNotification: - \(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo)
        
        if MalaUserDefaults.isLogined {
            if MalaRemoteNotificationHandler().handleRemoteNotification(userInfo as [NSObject : AnyObject]) {
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        println(String(format: "did Fail To Register For Remote Notifications With Error: %@", error as CVarArg))
    }
    
    
    // MARK: - openURL
    private func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        // 微信,支付宝 回调
        let canHandleURL = Pingpp.handleOpen(url) { (result, error) -> Void in
            // 处理Ping++回调
            let handler = HandlePingppBehaviour()
            handler.handleResult(result, error: error, currentViewController: MalaPaymentController)
        }
        return canHandleURL
    }
    
    private func application(_ app: UIApplication, openURL url: URL, options: [String : AnyObject]) -> Bool {
        
        // 微信,支付宝 回调
        let canHandleURL = Pingpp.handleOpen(url) { (result, error) -> Void in
            // 处理Ping++回调
            let handler = HandlePingppBehaviour()
            handler.handleResult(result, error: error, currentViewController: MalaPaymentController)
        }
        return canHandleURL
    }
    
    
    // MARK: - SDK Configuration
    func registerThirdParty() {

        #if USE_PRD_SERVER
            // Configure tracker from GoogleService-Info.plist.
            var configureError:NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
            
            // Optional: configure GAI options.
            // let gai = GAI.sharedInstance()
            // gai.trackUncaughtExceptions = true  // report uncaught exceptions
            // gai.logger.logLevel = GAILogLevel.Verbose
            
            // Ping++ - 开启DEBUG模式log
            Pingpp.setDebugMode(true)
        #endif
        
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
        
        // 开启键盘自动管理
        IQKeyboardManager.sharedManager().enable = true
    }
        
    
    // MARK: - UI
    /// 设置公共外观样式
    private func customAppearance() {
        
        // NavigationBar
        UINavigationBar.appearance().tintColor = MalaColor_6C6C6C_0
        UINavigationBar.appearance().setBackgroundImage(UIImage.withColor(UIColor.white), for: .default)
        
        // TabBar
        UITabBar.appearance().tintColor = MalaColor_82B4D9_0
    }
    
    
    // MARK: - Public Method
    
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
