//
//  FilterResultController.swift
//  mala-ios
//
//  Created by 王新宇 on 1/20/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import ESPullToRefresh

private let TeacherTableViewCellReusedId = "TeacherTableViewCellReusedId"

class FilterResultController: StatefulViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Property
    var models: [TeacherModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 当前显示页数
    var currentPageIndex = 1
    /// 所有老师数据总量
    var allTeacherCount = 0
    override var currentState: StatefulViewState {
        didSet {
            if currentState != oldValue {
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    
    // MARK: - Components
    /// 老师列表
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: .themeLightBlue)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        tableView.register(TeacherTableViewCell.self, forCellReuseIdentifier: TeacherTableViewCellReusedId)
        return tableView
    }()
    /// 筛选条件面板
    private lazy var filterBar: FilterBar = {
        let filterBar = FilterBar(frame: CGRect.zero)
        filterBar.backgroundColor = UIColor(named: .themeLightBlue)
        filterBar.controller = self
        return filterBar
    }()
    // MARK: - Components
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
        
        setupUserInterface()
        configure()
        loadTeachersWithCommonCondition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeStatusBarBlack()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // style
        title = L10n.filterResult
        view.backgroundColor = UIColor(named: .RegularBackground)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        
        // stateful
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // 加载更多
        tableView.es_addPullToRefresh(animator: ThemeRefreshHeaderAnimator()) {
            self.tableView.es_resetNoMoreData()
            self.loadTeachers(MalaCondition.getParam(), finish: {
                let isIgnore = (self.models.count > 0) && (self.models.count <= 2)
                self.tableView.es_stopPullToRefresh(ignoreDate: false, ignoreFooter: isIgnore)
            })
        }
        
        tableView.es_addInfiniteScrolling(animator: ThemeRefreshFooterAnimator()) {
            self.loadTeachers(MalaCondition.getParam(), isLoadMore: true, finish: {
                self.tableView.es_stopLoadingMore()
            })
        }
        
        // SubViews
        view.addSubview(filterBar)
        view.addSubview(tableView)
        
        // AutoLayout
        filterBar.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(MalaLayout_FilterBarHeight)
        }
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(filterBar.snp.bottom)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(view)
        }
    }
    
    private func configure() {
        
        // 设置BarButtomItem间隔
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -2
        
        // leftBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        navigationItem.leftBarButtonItems = [spacer, leftBarButtonItem]
    }
    
    func loadTeachersWithCommonCondition() {
        self.tableView.es_startPullToRefresh()
    }
    
    ///  根据筛选条件字典，请求老师列表
    ///
    ///  - parameter filters: 筛选条件字典
    func loadTeachers(_ filters: [String: Any]? = nil, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        guard currentState != .loading else { return }
        currentState = .loading
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            models = []
            currentPageIndex = 1
        }

        MAProvider.loadTeachers(condition: filters, page: currentPageIndex, failureHandler: { error in
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
        }) { (teachers, count) in
            
            defer { DispatchQueue.main.async { finish?() } }
            
            guard count != 0 && !teachers.isEmpty else {
                self.currentState = .empty
                return
            }
            
            ///  加载更多
            if isLoadMore {
                self.models += teachers
                if self.models.count == count {
                    self.tableView.es_noticeNoMoreData()
                }else {
                    self.tableView.es_resetNoMoreData()
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.models = teachers
            }
            
            self.allTeacherCount = count
            self.currentState = .content
        }
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let teacherId = (tableView.cellForRow(at: indexPath) as? TeacherTableViewCell)?.model?.id else { return }
        let viewController = TeacherDetailsController()
        viewController.teacherID = teacherId
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCellReusedId, for: indexPath) as! TeacherTableViewCell
        cell.model = models[indexPath.row]
        return cell
    }


    deinit {
        println("FilterResultController - Deinit")
        // 重置选择条件模型
        MalaFilterIndexObject.reset()
    }
}


extension FilterResultController {
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadTeachersWithCommonCondition()
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.loadTeachersWithCommonCondition()
    }
}
