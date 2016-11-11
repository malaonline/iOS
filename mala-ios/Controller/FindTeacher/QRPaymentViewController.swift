//
//  QRPaymentViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/10.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import PagingMenuController

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    var backgroundColor: UIColor {
        return MalaColor_EDEDED_0
    }
    
     var lazyLoadingPage: LazyLoadingPage {
         return .one
     }
    
    fileprivate var componentType: ComponentType {
        return .menuView(menuOptions: MenuOptions())
    }

    fileprivate struct MenuOptions: MenuViewCustomizable {
        var backgroundColor: UIColor {
            return MalaColor_FDFDFD_0
        }
        var selectedBackgroundColor: UIColor {
            return MalaColor_FDFDFD_0
        }
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 2, color: MalaColor_8DBEDE_0, horizontalPadding: 30, verticalPadding: 0)
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "微信支付", color: MalaColor_7E7E7E_0, selectedColor: MalaColor_8DBEDE_0))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "支付宝支付", color: MalaColor_7E7E7E_0, selectedColor: MalaColor_8DBEDE_0))
        }
    }
}


class QRPaymentViewController: BaseViewController {

    // MARK: - Components
    /// 二维码信息
    private lazy var qrView: QRCodeView = {
        let view = QRCodeView()
        return view
    }()
    /// 完成提示文字
    private lazy var tipFinishString: UILabel = {
        let label = UILabel(
            font: UIFont(name: "PingFang-SC-Regular", size: 12),
            textColor: MalaColor_636363_0
        )
        
        let string = "家长完成支付后 点击支付完成按钮"
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(
            NSForegroundColorAttributeName,
            value: MalaColor_9BC3E1_0,
            range: NSMakeRange(10, 4)
        )
        attrString.addAttribute(
            NSFontAttributeName,
            value: UIFont(name: "PingFang-SC-Regular", size: 12)!,
            range: NSMakeRange(10, 4)
        )
        
        label.attributedText = attrString
        return label
    }()
    /// 支付按钮
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MalaColor_9BC3E1_0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("支付完成", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(QRPaymentViewController.confirmButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        setupPageController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        title = "扫码支付"
        view.backgroundColor = MalaColor_F2F2F2_0
        
        // SubViews
        view.addSubview(qrView)
        view.addSubview(tipFinishString)
        view.addSubview(confirmButton)
        
        // Autolayout
        qrView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.bottom.equalTo(view).multipliedBy(0.73)
            maker.width.equalTo(view).multipliedBy(0.85)
            maker.height.equalTo(view).multipliedBy(0.565)
        }
        tipFinishString.snp.makeConstraints { (maker) in
            maker.height.equalTo(16.5)
            maker.bottom.equalTo(view).multipliedBy(0.843)
            maker.centerX.equalTo(view)
        }
        confirmButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.height.equalTo(44)
            maker.width.equalTo(view).multipliedBy(0.85)
            maker.bottom.equalTo(view).multipliedBy(0.95)
        }
    }
    
    private func setupPageController() {
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.delegate = self
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    
    @objc private func confirmButtonDidTap() {
        
    }
}


// MARK: - PagingMenu Delegate
extension QRPaymentViewController: PagingMenuControllerDelegate {
    func willMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        println("willMove - \(menuItemView) - \(previousMenuItemView)")
    }
    
    func didMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        println("didMove - \(menuItemView) - \(previousMenuItemView)")
    }
}
