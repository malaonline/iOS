//
//  OrderFormInfoViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class OrderFormInfoViewController: BaseViewController, OrderFormOperatingViewDelegate {

    // MARK: - Property
    /// 订单id
    var id: Int = 0
    /// 订单详情模型
    var model: OrderForm? {
        didSet {
            /// 渲染订单UI样式
            tableView.model = model
            id = model?.id ?? 0
            
            /// 渲染底部视图UI
            confirmView.model = model
            confirmView.isForConfirm = isForConfirm
        }
    }
    /// 标识是否为确认订单状态
    var isForConfirm: Bool = false {
        didSet {
            /// 渲染底部视图UI
            confirmView.isForConfirm = isForConfirm
        }
    }
    /// 学校id（仅再次购买时存在）
    var school: SchoolModel?
    
    
    // MARK: - Compontents
    /// 订单详情页面
    private lazy var tableView: OrderFormTableView = {
        let tableView = OrderFormTableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    /// 底部操作视图
    private lazy var confirmView: OrderFormOperatingView = {
        let view = OrderFormOperatingView()
        return view
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUserInterface()
        if isForConfirm {
            loadOrderOverView()
        }else {
            loadOrderFormInfo()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isForConfirm {
            sendScreenTrack(SAOrderViewName)
        }else {
            sendScreenTrack(SAOrderInfoViewName)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        title = isForConfirm ? "确认订单" : "订单详情"
        
        // SubViews
        view.addSubview(confirmView)
        view.addSubview(tableView)
        
        confirmView.delegate = self
        
        // Autolayout
        confirmView.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(47)
        }
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(confirmView.snp.top)
        }
    }
    
    /// 获取订单详情信息
    private func loadOrderFormInfo() {
        
        ThemeHUD.showActivityIndicator()
        
        // 获取订单信息
        getOrderInfo(id, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("HandlePingppBehaviour - validateOrderStatus Error \(errorMessage)")
            }
        }, completion: { order -> Void in
            println("订单获取成功 \(order)")
            DispatchQueue.main.async {
                self.model = order
            }
        })
    }
    
    ///  作为订单预览展示时，加载伪数据
    private func loadOrderOverView() {
        //  课时
        guard MalaCurrentCourse.classPeriod != 0 else {
            ShowToast("课时信息有误")
            return
        }
        
        // 上课时间
        let timeslots = MalaCurrentCourse.selectedTime.map{$0.id}
        guard timeslots.count != 0 else {
            ShowToast("上课时间信息有误")
            return
        }
        
        // 课时
        let hours = MalaCurrentCourse.classPeriod
        
        ThemeHUD.showActivityIndicator()
        
        // 请求上课时间表
        getConcreteTimeslots(MalaOrderOverView.teacher, hours: hours, timeSlots: timeslots, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("OrderFormInfoViewController - loadOrderOverView Error \(errorMessage)")
            }
            
        }, completion: { (timeSlots) in
            ThemeHUD.hideActivityIndicator()
            
            guard let timesSchedule = timeSlots else {
                self.ShowToast("上课时间获取有误，请重试")
                return
            }
            
            MalaOrderOverView.timeSlots = timesSchedule
            MalaOrderOverView.hours = MalaCurrentCourse.classPeriod
            MalaOrderOverView.schoolName = (self.school != nil) ? self.school!.name : MalaCurrentSchool?.name
            MalaOrderOverView.schoolAddress = (self.school != nil) ? self.school!.address : MalaCurrentSchool?.address
            MalaOrderOverView.status = "c"
            
            DispatchQueue.main.async {
                self.model = MalaOrderOverView
            }
        })
    }
    
    ///  取消订单
    private func cancelOrder() {
        
        println("取消订单")
        ThemeHUD.showActivityIndicator()
        
        cancelOrderWithId(id, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("OrderFormInfoViewController - cancelOrder Error \(errorMessage)")
            }
        }, completion:{ (result) in
            ThemeHUD.hideActivityIndicator()
            
            DispatchQueue.main.async {
                self.ShowToast(result == true ? "订单取消成功" : "订单取消失败")
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    private func createOrder() {
        
        ThemeHUD.showActivityIndicator()
        
        ///  创建订单
        createOrderWithForm(MalaOrderObject.jsonDictionary(), failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("OrderFormInfoViewController - CreateOrder Error \(errorMessage)")
            }
            DispatchQueue.main.async {
                self.ShowToast(L10n.Toast.Error.notReachable)
            }
        }, completion: { [weak self] (order) -> Void in
            ThemeHUD.hideActivityIndicator()
            
            // 订单创建错误
            if let code = order.code {
                var message = ""
                if let errorCode = OrderErrorCode(rawValue: code) {
                    switch errorCode {
                    case .timeslotConflict:
                        message = L10n.Order.Error.timeslot
                    case .couponConflict:
                        message = L10n.Order.Error.coupon
                    case .liveClassFull:
                        message = L10n.Order.Error.full
                    case .alreadyJoin:
                        message = L10n.Order.Error.bought
                    }
                }else {
                    message = L10n.Toast.Error.notReachable
                }
                DispatchQueue.main.async{
                    self?.ShowToast(message)
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
    
    private func launchPaymentController() {
        
        // 跳转到支付页面
        let viewController = PaymentViewController()
        viewController.popAction = {
            MalaIsPaymentIn = false
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    // MARK: - Delegate
    ///  立即支付
    func orderFormPayment() {
        
        // 订单详情 － 支付
        if isForConfirm {
            createOrder()
            return
        }
        
        // 订单详情 － 支付
        if let order = self.model {
            ServiceResponseOrder = order
            launchPaymentController()
        }
    }
    
    ///  再次购买
    func orderFormBuyAgain() {
        
        // 跳转到课程购买页
        let viewController = CourseChoosingViewController()
        if let id = model?.teacher  {
            viewController.teacherModel?.subject = model?.subjectName
            viewController.teacherId = id
            viewController.school = SchoolModel(id: model?.school, name: model?.schoolName , address: model?.schoolAddress)
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }else {
            self.ShowToast("订单信息有误，请刷新后重试")
        }
    }
    
    ///  取消订单
    func orderFormCancel() {
        
        MalaAlert.confirmOrCancel(
            title: "取消订单",
            message: "确认取消订单吗？",
            confirmTitle: "取消订单",
            cancelTitle: "暂不取消",
            inViewController: self,
            withConfirmAction: { [weak self] () -> Void in
                self?.cancelOrder()
            }, cancelAction: { () -> Void in
        })
    }
    
    /// 申请退费
    func requestRefund() {
        
    }
}
