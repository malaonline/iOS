//
//  OrderFormViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/6.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import ESPullToRefresh

private let OrderFormViewCellReuseId = "OrderFormViewCellReuseId"

class OrderFormViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource {

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
        return tableView
    }()
    /// 导航栏返回按钮
    lazy var backBarButton: UIButton = {
        let backBarButton = UIButton(
            imageName: "leftArrow_white",
            highlightImageName: "leftArrow_white",
            target: self,
            action: #selector(FilterResultController.popSelf)
        )
        return backBarButton
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
        // 开启下拉刷新
        tableView.es_startPullToRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendScreenTrack(SAMyOrdersViewName)
    }
    
    
    // MARK: - Private Method
    private func configure() {
        title = L10n.myOrder
        view.addSubview(tableView)
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        // leftBarButtonItem
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -2
        let leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        navigationItem.leftBarButtonItems = [spacer, leftBarButtonItem]
        
        // 下拉刷新
        tableView.es_addPullToRefresh(animator: ThemeRefreshHeaderAnimator()) { [weak self] in
            self?.tableView.es_resetNoMoreData()
            self?.loadOrderForm(finish: {
                let isIgnore = (self?.models.count ?? 0 >= 0) && (self?.models.count ?? 0 <= 2)
                self?.tableView.es_stopPullToRefresh(ignoreDate: false, ignoreFooter: isIgnore)
            })
        }
        
        tableView.es_addInfiniteScrolling(animator: ThemeRefreshFooterAnimator()) { [weak self] in
            self?.loadOrderForm(isLoadMore: true, finish: {
                self?.tableView.es_stopLoadingMore()
            })
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
    @objc fileprivate func loadOrderForm(_ page: Int = 1, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        // 屏蔽[正在刷新]时的操作
        guard currentState != .loading else { return }
        currentState = .loading
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            models = []
            currentPageIndex = 1
        }
        
        ///  获取用户订单列表
        MAProvider.getOrderList(page: currentPageIndex, failureHandler: { error in
            defer { DispatchQueue.main.async { finish?() } }

            if let statusCode = error.response?.statusCode, statusCode == 404 {
                if isLoadMore {
                    self.currentPageIndex -= 1
                }
                self.tableView.es_noticeNoMoreData()
            }else {
                self.tableView.es_resetNoMoreData()
            }

            self.currentState = .error
        }) { (list, count) in
            defer { DispatchQueue.main.async { finish?() } }

            guard !list.isEmpty && count != 0 else {
                self.currentState = .empty
                return
            }
            
            ///  加载更多
            if isLoadMore {
                self.models += list
                if self.models.count == count {
                    self.tableView.es_noticeNoMoreData()
                }else {
                    self.tableView.es_resetNoMoreData()
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.models = list
            }
            
            self.allCount = count
            self.currentState = .content
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
                self?.showToast(L10n.orderInfoError)
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
                self?.showToast(L10n.orderInfoError)
            }
        }
    }
    
    private func cancelOrder(_ orderId: Int) {
        MAProvider.cancelOrder(id: orderId) { result in
            DispatchQueue.main.async {
                self.showToast(result == true ? L10n.orderCanceledSuccess : L10n.orderCanceledFailure)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = OrderFormInfoViewController()
        let model = models[indexPath.row]
        viewController.id = model.id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderFormViewCellReuseId, for: indexPath) as! OrderFormViewCell
        cell.selectionStyle = .none
        cell.model = models[indexPath.row]
        return cell
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushToPayment, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushTeacherDetailView, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_CancelOrderForm, object: nil)
    }
}


extension OrderFormViewController {
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadOrderForm()
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.loadOrderForm()
    }
}
