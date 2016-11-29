//
//  OrderFormViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/6.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let OrderFormViewCellReuseId = "OrderFormViewCellReuseId"
private let OrderFormViewLoadmoreCellReusedId = "OrderFormViewLoadmoreCellReusedId"

class OrderFormViewController: BaseTableViewController {
    
    private enum Section: Int {
        case teacher
        case loadMore
    }
    
    // MARK: - Property
    /// 优惠券模型数组
    var models: [OrderForm] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.models.count == 0 {
                    self.showDefaultView()
                }else {
                    self.hideDefaultView()
                    self.tableView.reloadData()
                }
            }
        }
    }
    /// 当前选择项IndexPath标记
    /// 缺省值为不存在的indexPath，有效的初始值将会在CellForRow方法中设置
    private var currentSelectedIndexPath: IndexPath = IndexPath(item: 0, section: 1)
    /// 是否仅用于展示（例如[个人中心]）
    var justShow: Bool = true
    /// 是否正在拉取数据
    var isFetching: Bool = false
    /// 当前显示页数
    var currentPageIndex = 1
    /// 所有老师数据总量
    var allOrderFormCount = 0
    /// 当前选择订单的上课地点信息
    var school: SchoolModel?
    
    
    // MARK: - Components
    /// 下拉刷新视图
    private lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(OrderFormViewController.loadOrderForm), for: .valueChanged)
        return refresher
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrderForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendScreenTrack(SAMyOrdersViewName)
    }
    
    
    // MARK: - Private Method
    private func configure() {
        title = "我的订单"
        defaultView.imageName = "no_order"
        defaultView.text = "没有订单"
        
        tableView.backgroundColor = MalaColor_EDEDED_0
        tableView.separatorStyle = .none
        refreshControl = refresher
        
        tableView.register(OrderFormViewCell.self, forCellReuseIdentifier: OrderFormViewCellReuseId)
        tableView.register(ThemeReloadView.self, forCellReuseIdentifier: OrderFormViewLoadmoreCellReusedId)
    }
    
    ///  获取用户订单列表
    @objc private func loadOrderForm(_ page: Int = 1, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        // 屏蔽[正在刷新]时的操作
        guard isFetching == false else { return }
        isFetching = true
        refreshControl?.beginRefreshing()
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }
        
        ///  获取用户订单列表
        getOrderList(currentPageIndex, failureHandler: { (reason, errorMessage) in
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("OrderFormViewController - loadOrderForm Error \(errorMessage)")
            }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.isFetching = false
            }
        }, completion: { (orderList, count) in
            
            /// 记录数据量
            if count != 0 {
                self.allOrderFormCount = count
            }
            
            ///  加载更多
            if isLoadMore {
                for order in orderList {
                    self.models.append(order)
                }
            ///  如果不是加载更多，则刷新数据
            }else {
                self.models = orderList
            }
            
            DispatchQueue.main.async {
                finish?()
                self.refreshControl?.endRefreshing()
                self.isFetching = false
            }
        })
    }
    
    private func setupNotification() {
        
        NotificationCenter.default.addObserver(
            forName: MalaNotification_PushToPayment,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            // 支付页面
            if let order = notification.object as? OrderForm {
                ServiceResponseOrder = order
                self?.launchPaymentController()
            }
            
        }
        
        NotificationCenter.default.addObserver(
            forName: MalaNotification_PushTeacherDetailView,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            // 跳转到课程购买页
            let viewController = CourseChoosingViewController()
            if let model = notification.object as? OrderForm {
                viewController.teacherId = model.teacher
                viewController.school = SchoolModel(id: model.school, name: model.schoolName , address: model.schoolAddress)
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            }else {
                self?.ShowToast("订单信息有误，请刷新后重试")
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: MalaNotification_CancelOrderForm,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            // 取消订单
            if let id = notification.object as? Int {
                
                MalaAlert.confirmOrCancel(
                    title: "取消订单",
                    message: "确认取消订单吗？",
                    confirmTitle: "取消订单",
                    cancelTitle: "暂不取消",
                    inViewController: self,
                    withConfirmAction: { [weak self] () -> Void in
                        self?.cancelOrder(id)
                    }, cancelAction: { () -> Void in
                })
                
            }else {
                self?.ShowToast("订单信息有误，请刷新后重试")
            }
        }
    }
    
    private func cancelOrder(_ orderId: Int) {
        
        println("取消订单")
        ThemeHUD.showActivityIndicator()
        
        cancelOrderWithId(orderId, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("OrderFormViewController - cancelOrder Error \(errorMessage)")
            }
        }, completion: { (result) in
            ThemeHUD.hideActivityIndicator()
            
            DispatchQueue.main.async {
                self.ShowToast(result == true ? "订单取消成功" : "订单取消失败")
                _ = self.navigationController?.popViewController(animated: true)
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MalaLayout_CardCellWidth*0.6
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case Section.teacher.rawValue:
            break
            
        case Section.loadMore.rawValue:
            if let cell = cell as? ThemeReloadView {
                println("load more orderForm")
                
                if !cell.activityIndicator.isAnimating {
                    cell.activityIndicator.startAnimating()
                }
                
                loadOrderForm(isLoadMore: true, finish: { 
                    cell.activityIndicator.stopAnimating()
                })
            }
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = OrderFormInfoViewController()
        let model = models[indexPath.row]
        viewController.id = model.id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case Section.teacher.rawValue:
            return models.count 
            
        case Section.loadMore.rawValue:
            if allOrderFormCount == models.count {
                return 0
            }else {
                return models.isEmpty ? 0 : 1
            }
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case Section.teacher.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderFormViewCellReuseId, for: indexPath) as! OrderFormViewCell
            cell.selectionStyle = .none
            cell.model = models[indexPath.row]
            return cell
            
        case Section.loadMore.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderFormViewLoadmoreCellReusedId, for: indexPath) as! ThemeReloadView
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushToPayment, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushTeacherDetailView, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_CancelOrderForm, object: nil)
    }
}
