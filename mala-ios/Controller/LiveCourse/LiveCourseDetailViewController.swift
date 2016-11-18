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
    /// 教师id
    var classId: Int? {
        didSet {
            
        }
    }
    /// 教师详情数据模型
    var model: LiveClassModel = TestFactory.testLiveClass() {
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
        
        setupUserInterface()
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
    
    private func setupNotification() {
        
    }
    
    ///  创建订单
    private func createOrder() {
        println("创建订单")
        ThemeHUD.showActivityIndicator()
        
        let order = OrderForm(classId: model.id)
        
        createOrderWithForm(order.jsonForLiveCourse(), failureHandler: { [weak self] (reason, errorMessage) -> Void in
            
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("PaymentViewController - CreateOrder Error \(errorMessage)")
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self?.ShowToast("创建订单失败, 请重试！")
            })
            
            }, completion: { [weak self] (order) -> Void in
                
                ThemeHUD.hideActivityIndicator()
                
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
                    ThemeHUD.hideActivityIndicator()
                    println("创建订单成功:\(order)")
                    ServiceResponseOrder = order
                    DispatchQueue.main.async(execute: { () -> Void in
                        self?.launchPaymentController()
                    })
                }
        })
    }
    
    private func launchPaymentController() {
        
        // 跳转到支付页面
        let viewController = PaymentViewController()
        viewController.popAction = {
            MalaIsPaymentIn = false
        }
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
