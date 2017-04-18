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
        return UIColor(named: .RegularBackground)
    }
    
    fileprivate var componentType: ComponentType {
        return .menuView(menuOptions: MenuOptions())
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var backgroundColor: UIColor {
            return UIColor(named: .OptionBackground)
        }
        var selectedBackgroundColor: UIColor {
            return UIColor(named: .OptionBackground)
        }
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        var focusMode: MenuFocusMode {
            return .underline(
                height: 2,
                color: UIColor(named: .OptionSelectColor),
                horizontalPadding: 30,
                verticalPadding: 0
            )
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(
                text: L10n.weChatPayment,
                color: UIColor(named: .OptionTitle),
                selectedColor: UIColor(named: .OptionSelectColor)
            ))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(
                text: L10n.alipayPayment,
                color: UIColor(named: .OptionTitle),
                selectedColor: UIColor(named: .OptionSelectColor)
            ))
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
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .ArticleText)
        )        
        let attrString = NSMutableAttributedString(string: L10n.pleaseCompleteThePaymentBeforeCheckIt)
        attrString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(named: .ThemeBlue),
            range: NSMakeRange(10, 4)
        )
        attrString.addAttribute(
            NSFontAttributeName,
            value: FontFamily.PingFangSC.Regular.font(12),
            range: NSMakeRange(10, 4)
        )
        
        label.attributedText = attrString
        return label
    }()
    /// 支付按钮
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeBlue)), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle(L10n.paymentCompleted, for: .normal)
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
        
        /// 获取支付信息
        getChargeToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        title = L10n.sweepPayment
        view.backgroundColor = UIColor(named: .CardBackground)
        
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
        pagingMenuController.view.frame.size = CGSize(width: MalaScreenWidth, height: 200)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    func getChargeToken(channel: MalaPaymentChannel = .WxQR) {
        
        MalaIsPaymentIn = true
        
        ///  获取支付信息
        MAProvider.getChargeToken(channel: channel, id: ServiceResponseOrder.id) { [weak self] charges in
            println("获取支付信息:\(charges as Optional)")
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                ThemeHUD.hideActivityIndicator()
                
                /// 验证返回值是否有效
                guard let charge = charges else {
                    self?.showToast(L10n.qrCodeGetError)
                    return
                }
                
                /// 验证返回结果是否存在result(存在则表示失败)
                if let _ = charge["result"] as? Bool {
                    /// 失败弹出提示
                    if let strongSelf = self {
                        let alert = JSSAlertView().show(strongSelf,
                                                        title: "部分课程时间已被占用，请重新选择上课时间",
                                                        buttonText: L10n.reChoosing,
                                                        iconImage: UIImage(asset: .alertPaymentFail)
                        )
                        alert.addAction(strongSelf.forcePop)
                    }
                }else {
                    /// 成功保存Charge对象
                    MalaPaymentCharge = charge
                    
                    /// 验证数据正确性
                    guard let credential = charge["credential"] as? JSON else {
                        self?.showToast(L10n.qrCodeCredentialGetError)
                        return
                    }
                    
                    /// 获取支付链接，生成二维码
                    switch channel {
                    case .WxQR:
                        guard let qrPaymentURL = credential["wx_pub_qr"] as? String else {
                            self?.showToast(L10n.weChatQRCodeInfoGetError)
                            return
                        }
                        self?.qrView.url = qrPaymentURL
                        self?.qrView.price = ServiceResponseOrder.amount == 0 ? MalaCurrentCourse.getAmount() ?? 0 : ServiceResponseOrder.amount
                        break
                        
                    case .AliQR:
                        guard let qrPaymentURL = credential["alipay_qr"] as? String else {
                            self?.showToast(L10n.alipayQRCodeInfoGetError)
                            return
                        }
                        self?.qrView.url = qrPaymentURL
                        self?.qrView.price = ServiceResponseOrder.amount == 0 ? MalaCurrentCourse.getAmount() ?? 0 : ServiceResponseOrder.amount
                        break
                        
                    default:
                        self?.showToast(L10n.qrCodeGetError)
                        break
                    }
                }
            })
        }
    }
    
    private func cancelOrder() {
        MAProvider.cancelOrder(id: ServiceResponseOrder.id) { result in
            DispatchQueue.main.async {
                self.showToast(result == true ? L10n.orderCanceledSuccess : L10n.orderCanceledFailure)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func validateOrderStatus() {
        
        // 获取订单信息
        MAProvider.getOrderInfo(id: ServiceResponseOrder.id) { [weak self] order in
            println("订单状态获取成功 \(order?.status as Optional)")
            
            guard let order = order else {
                self?.showToast(L10n.orderStatusError)
                return
            }
            
            // 根据[订单状态]和[课程是否被抢占标记]来判断支付结果
            DispatchQueue.main.async { () -> Void in
                
                let handler = HandlePingppBehaviour()
                handler.currentViewController = self
                
                // 判断订单状态
                // 尚未支付
                if order.status == MalaOrderStatus.penging.rawValue {
                    self?.showToast(L10n.pleaseCompleteThePayment)
                    return
                }
                // 订单已失效
                if order.status == MalaOrderStatus.canceled.rawValue {
                    self?.showToast(L10n.orderExpired)
                    _ = self?.navigationController?.popToViewController(LiveCourseViewController(), animated: true)
                    return
                }
                // 支付成功
                if order.status == MalaOrderStatus.paid.rawValue {
                    
                    if order.isTeacherPublished == false {
                        // 老师已下架
                        handler.showTeacherDisabledAlert()
                    }else if order.isTimeslotAllocated == false {
                        // 课程被抢买
                        handler.showHasBeenPreemptedAlert()
                    }else {
                        // 支付成功
                        handler.showSuccessAlert()
                    }
                }else {
                    self?.showToast(L10n.orderStatusError)
                    return
                }
            }
        }
    }
    
    
    // MARK: -  Events Response
    @objc private func forcePop() {
        cancelOrder()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonDidTap() {
        validateOrderStatus()
    }
}


// MARK: - PagingMenu Delegate
extension QRPaymentViewController: PagingMenuControllerDelegate {

    func didMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        
        guard let title = menuItemView.titleLabel.text else {
            println("didMove - MenuItemView no title")
            return
        }
        
        switch title {
        case L10n.weChatPayment:
            getChargeToken(channel: .WxQR)
            break
            
        case L10n.alipayPayment:
            getChargeToken(channel: .AliQR)
            break
            
        default:
            break
        }
        
    }
}
