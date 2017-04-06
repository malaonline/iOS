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

class OrderFormViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case teacher
        case loadMore
    }
    
    // MARK: - Property
    /// 优惠券模型数组
    var models: [OrderForm] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    /// 当前选择项IndexPath标记
    /// 缺省值为不存在的indexPath，有效的初始值将会在CellForRow方法中设置
    private var currentSelectedIndexPath: IndexPath = IndexPath(item: 0, section: 1)
    /// 是否仅用于展示（例如[个人中心]）
    var justShow: Bool = true
    /// 当前显示页数
    var currentPageIndex = 1
    /// 数据总量
    var allCount = 0
    /// 当前选择订单的上课地点信息
    var school: SchoolModel?
    override var currentState: StatefulViewState {
        didSet {
            if currentState != oldValue {
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    
    // MARK: - Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.register(OrderFormViewCell.self, forCellReuseIdentifier: OrderFormViewCellReuseId)
        tableView.register(ThemeReloadView.self, forCellReuseIdentifier: OrderFormViewLoadmoreCellReusedId)
        return tableView
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
        title = L10n.myOrder
        view.addSubview(tableView)
        
        // 开启下拉刷新
        tableView.startPullRefresh()
        
        // 下拉刷新
        tableView.addPullRefresh{ [weak self] in
            self?.loadOrderForm()
            self?.tableView.stopPullRefreshEver()
        }
        
        // autoLayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.bottom.equalTo(view)
            maker.right.equalTo(view)
        }
    }
    
    ///  获取用户订单列表
    @objc private func loadOrderForm(_ page: Int = 1, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        // 屏蔽[正在刷新]时的操作
        guard currentState != .loading else { return }
        if !isLoadMore { models = [] }
        currentState = .loading
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }
        
        ///  获取用户订单列表
        MAProvider.getOrderList(page: currentPageIndex, failureHandler: { error in
            self.currentState = .error
        }) { (list, count) in
            
            guard !list.isEmpty && count != 0 else {
                self.currentState = .empty
                return
            }
            
            /// 记录数据量
            self.allCount = max(self.allCount, count)
            
            ///  加载更多
            if isLoadMore {
                for order in list {
                    self.models.append(order)
                }
                ///  如果不是加载更多，则刷新数据
            }else {
                self.models = list
            }
            
            self.currentState = .content
            DispatchQueue.main.async {
                finish?()
            }
        }
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
                self?.ShowToast(L10n.orderInfoError)
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
                    title: L10n.cancelOrder,
                    message: L10n.doYouWantToCancelThisOrder,
                    confirmTitle: L10n.cancelOrder,
                    cancelTitle: L10n.notNow,
                    inViewController: self,
                    withConfirmAction: { [weak self] () -> Void in
                        self?.cancelOrder(id)
                    }, cancelAction: { () -> Void in
                })
                
            }else {
                self?.ShowToast(L10n.orderInfoError)
            }
        }
    }
    
    private func cancelOrder(_ orderId: Int) {
        MAProvider.cancelOrder(id: orderId) { result in
            DispatchQueue.main.async {
                self.ShowToast(result == true ? L10n.orderCanceledSuccess : L10n.orderCanceledFailure)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MalaLayout_CardCellWidth*0.6
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = OrderFormInfoViewController()
        let model = models[indexPath.row]
        viewController.id = model.id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case Section.teacher.rawValue:
            return models.count 
            
        case Section.loadMore.rawValue:
            return allCount == models.count ? 0 : (models.isEmpty ? 0 : 1)
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
