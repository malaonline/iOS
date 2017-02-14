//
//  LiveCourseDetailViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseDetailViewController: BaseViewController, LiveCourseConfirmViewDelegate {
    
    // MARK: - Property
    /// 课程id
    var classId = 0
    /// 教师详情数据模型
    var model: LiveClassModel = LiveClassModel() {
        didSet {
            tableView.model = model
            confirmView.model = model
        }
    }
    
    
    // MARK: - Compontents
    private lazy var tableView: LiveCourseDetailTableView = {
        let tableView = LiveCourseDetailTableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    private lazy var confirmView: LiveCourseConfirmView = {
        let confirmView = LiveCourseConfirmView()
        return confirmView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeHUD.showActivityIndicator()
        
        setupUserInterface()
        loadClassDetail()
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendScreenTrack(SACourseChoosingViewName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        title = "课程页"
        
        // SubViews
        view.addSubview(tableView)
        view.addSubview(confirmView)
        
        confirmView.delegate = self
        
        // Autolayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(confirmView.snp.top)
        }
        confirmView.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(44)
        }
    }
    
    private func loadClassDetail() {
        getLiveClassDetail(classId, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("LiveCourseDetailViewController - loadClassDetail Error \(errorMessage)")
            }
        }, completion: { [weak self] (model) in
            ThemeHUD.hideActivityIndicator()
            self?.model = model
        })
    }
    
    private func setupNotification() {
        
        // 拨打助教电话
        NotificationCenter.default.addObserver(
            forName: MalaNotification_MakePhoneCall,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            
            guard
                let phone = notification.object as? String,
                let url = URL(string: String(format: "tel:%@", phone)) else { return }
            
            // ActionSheet
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let phoneCallAction: UIAlertAction = UIAlertAction(title: phone, style: .default) { (action) -> Void in
                UIApplication.shared.openURL(url)
            }
            alertController.addAction(phoneCallAction)
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                self?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    ///  创建订单
    private func createOrder() {
        
        ThemeHUD.showActivityIndicator()
        let order = OrderForm(classId: model.id)
        
        createOrderWithForm(order.jsonForLiveCourse(), failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("LiveCourseDetailViewController - CreateOrder Error \(errorMessage)")
            }
            DispatchQueue.main.async {
                self.ShowToast("网络不稳定, 请重试")
            }
        }, completion: { [weak self] (order) -> Void in
            ThemeHUD.hideActivityIndicator()
            
            // 订单创建错误
            if let errorCode = order.code {
                if errorCode == -1 {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self?.ShowToast("该老师部分时段已被占用，请重新选择上课时间")
                    })
                }else if errorCode == -2 {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self?.ShowToast("奖学金使用信息有误，请重新选择")
                        _ = self?.navigationController?.popViewController(animated: true)
                    })
                }
            }else {
                println("创建订单成功:\(order)")
                ServiceResponseOrder = order
                DispatchQueue.main.async(execute: { () -> Void in
                    self?.launchPaymentController()
                })
            }
        })
    }
    
    // 跳转到支付页面
    private func launchPaymentController() {
        let viewController = PaymentViewController()
        viewController.popAction = {  MalaIsPaymentIn = false }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    @objc internal func OrderDidConfirm() {
        // 验证是否已登陆
        if !MalaUserDefaults.isLogined {
            let loginController = LoginViewController()
            self.present(
                UINavigationController(rootViewController: loginController),
                animated: true,
                completion: nil)
        }else {
            createOrder()
        }
    }
    
    deinit {
        println("choosing Controller deinit")
    }
}
