//
//  Mala+UIVIewController.swift
//  mala-ios
//
//  Created by 王新宇 on 3/28/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import Foundation
import Toast_Swift


extension UIViewController {
    
    public func showShareActionSheet(model: BaseObjectModel) {
        
        guard let model = model as? TeacherDetailModel else {
            println("Model is not match TeacherDetailModel.")
            return
        }
        
        // 创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: model.shareText,
                                          images : (model.avatar ?? UIImage(asset: .avatarPlaceholder)),
                                          url : model.shareURL as URL!,
                                          title : "我在麻辣老师发现一位好老师！",
                                          type : SSDKContentType.webPage)
        // 简洁样式菜单
        SSUIShareActionSheetStyle.setShareActionSheetStyle(.simple)
        // 分享菜单
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state, platformType, userData, contentEntity, error, end) in
            switch state {
            case .begin:
                println("开始")
            case .success:
                self.showToast("分享成功")
            case .fail:
                self.showToast("分享失败")
            case .cancel:
                println("分享已经取消")
            }
        }
    }
}

extension UIViewController {
    
    public func showToast(_ message: String) {
        currentView?.showToastAtBottom(message)
    }
    
    public func showActivity() {
        currentView?.makeToastActivity(.center)
    }
    
    public func hideActivity() {
        currentView?.hideToastActivity()
    }
    
    // MARK: - Convenience View
    private var currentView: UIView? {
        get {
            if let naviView = self.navigationController?.view {
                return naviView
            }else if let view = self.view {
                return view
            }else {
                return nil
            }
        }
    }
    
    // MARK: - Badge Point
    var showTabBadgePoint: Bool {
        get {
            return !tabBadgePointView.isHidden
        }
        set {
            DispatchQueue.main.async{ [weak self] () -> Void in
                guard let strongSelf = self else { return }
                if newValue && strongSelf.tabBadgePointView.superview == nil {
                    strongSelf.tabBadgePointView.center = strongSelf.tabBadgePointViewCenter
                    if let tbb = strongSelf.tabBarButton {
                        tbb.addSubview(strongSelf.tabBadgePointView)
                    }
                }
                strongSelf.tabBadgePointView.isHidden = newValue == false
            }
        }
    }
    
    var tabBadgePointView: UIView {
        get {
            var _tabBadgePointView = objc_getAssociatedObject(self, &AssociatedKeys.tabBadgePointViewAssociatedKey)
            if _tabBadgePointView == nil {
                _tabBadgePointView = defaultTabBadgePointView()
                objc_setAssociatedObject(self, &AssociatedKeys.tabBadgePointViewAssociatedKey, _tabBadgePointView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return _tabBadgePointView as! UIView
        }
        set {
            if newValue.superview != nil {
                newValue.removeFromSuperview()
            }
            newValue.isHidden = true
            objc_setAssociatedObject(self, &AssociatedKeys.tabBadgePointViewAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var tabBadgePointViewOffset: UIOffset {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociatedKeys.tabBadgePointViewOffsetAssociatedKey) {
                return (obj as AnyObject).uiOffsetValue
            }
            else {
                return UIOffset.zero
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tabBadgePointViewOffsetAssociatedKey, NSValue(uiOffset: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isEmbedInTabBarController: Bool {
        var _isEmbedInTabBarController = false
        if let tbc = self.tabBarController, let vcs = tbc.viewControllers {
            for i in 0 ..< vcs.count {
                let vc = vcs[i]
                if vc == self {
                    _isEmbedInTabBarController = true
                    tabIndex = i
                    break
                }
            }
        }
        return _isEmbedInTabBarController
    }
    
    var tabIndex: Int {
        get {
            if isEmbedInTabBarController == false {
                print("LxTabBadgePoint：This viewController not embed in tabBarController")
                return NSNotFound
            }
            let obj = objc_getAssociatedObject(self, &AssociatedKeys.tabIndexAssociatedKey)
            return (obj as! Int)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tabIndexAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var tabBarButton: UIView? {
        get {
            guard let tbc = tabBarController else { return nil }
            
            var tabBarButtonArray = [UIView]()
            for subView in tbc.tabBar.subviews {
                if let className = NSString(cString: object_getClassName(subView), encoding: String.Encoding.utf8.rawValue),
                    className.hasPrefix("UITabBarButton") {
                    tabBarButtonArray.append(subView)
                }
            }
            tabBarButtonArray.sort{ $0.frame.minX < $1.frame.minX }
            
            if tabIndex >= 0 && tabIndex < tabBarButtonArray.count {
                return tabBarButtonArray[tabIndex]
            }else {
                print("Extension: TabBadgePoint：Not found corresponding tabBarButton!")
                return nil
            }
        }
    }
    
    // MARK: BadgePoint Private Method
    private var tabBadgePointViewCenter: CGPoint {
        get {
            guard let tbb = tabBarButton else {
                return CGPoint(x: 36, y: 8.5)
            }
            
            var tabBadgePointViewCenter = CGPoint(x: tbb.bounds.midX + 14, y : 8.5)
            tabBadgePointViewCenter.x += tabBadgePointViewOffset.horizontal
            tabBadgePointViewCenter.y += tabBadgePointViewOffset.vertical
            return tabBadgePointViewCenter
        }
    }
    
    private func defaultTabBadgePointView() -> UIView {
        let defaultTabBadgePointViewRadius = 4.5
        let defaultTabBadgePointViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: defaultTabBadgePointViewRadius * 2, height: defaultTabBadgePointViewRadius * 2))
        let defaultTabBadgePointView = UIView(frame: defaultTabBadgePointViewFrame)
        defaultTabBadgePointView.backgroundColor = UIColor.red
        defaultTabBadgePointView.layer.cornerRadius = CGFloat(defaultTabBadgePointViewRadius)
        defaultTabBadgePointView.layer.masksToBounds = true
        defaultTabBadgePointView.isHidden = true
        return defaultTabBadgePointView
    }
    
    private struct AssociatedKeys {
        static var tabIndexAssociatedKey = "tabIndexAssociatedKey"
        static var tabBadgePointViewAssociatedKey = "tabBadgePointViewAssociatedKey"
        static var tabBadgePointViewOffsetAssociatedKey = "tabBadgePointViewOffsetAssociatedKey"
    }
}
