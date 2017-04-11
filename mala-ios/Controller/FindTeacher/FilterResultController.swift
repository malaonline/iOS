//
//  FilterResultController.swift
//  mala-ios
//
//  Created by 王新宇 on 1/20/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

private let TeacherTableViewCellReusedId = "TeacherTableViewCellReusedId"
private let TeacherTableViewLoadmoreCellReusedId = "TeacherTableViewLoadmoreCellReusedId"

class FilterResultController: StatefulViewController, UITableViewDataSource, UITableViewDelegate {

    private enum Section: Int {
        case teacher
        case loadMore
    }
    
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
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 48 + 6, right: 0)
        tableView.register(TeacherTableViewCell.self, forCellReuseIdentifier: TeacherTableViewCellReusedId)
        tableView.register(ThemeReloadView.self, forCellReuseIdentifier: TeacherTableViewLoadmoreCellReusedId)
        return tableView
    }()
    /// 筛选条件面板
    private lazy var filterBar: FilterBar = {
        let filterBar = FilterBar(frame: CGRect.zero)
        filterBar.backgroundColor = UIColor(named: .RegularBackground)
        filterBar.controller = self
        return filterBar
    }()
    /// 上拉刷新视图
    private lazy var reloadView: ThemeReloadView = {
        let reloadView = ThemeReloadView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        return reloadView
    }()
    // MARK: - Components
    /// 导航栏返回按钮
    lazy var backBarButton: UIButton = {
        let backBarButton = UIButton(
            imageName: "leftArrow_black",
            highlightImageName: "leftArrow_black",
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
        tableView.addPushRefresh { [weak self] in
            self?.loadTeachers(isLoadMore: true)
            self?.tableView.stopPushRefreshEver()
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
        loadTeachers(MalaCondition.getParam())
    }
    
    ///  根据筛选条件字典，请求老师列表
    ///
    ///  - parameter filters: 筛选条件字典
    func loadTeachers(_ filters: [String: Any]? = nil, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        guard currentState != .loading else { return }
        models = []
        currentState = .loading
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }

        MAProvider.loadTeachers(condition: filters, page: currentPageIndex, failureHandler: { error in
            self.currentState = .error
            DispatchQueue.main.async {
                finish?()
            }
        }) { (teachers, count) in
            
            guard count != 0 && !teachers.isEmpty else {
                self.currentState = .empty
                return
            }
            
            /// 记录数据量
            self.allTeacherCount = count
            
            if isLoadMore {
                ///  加载更多
                for teacher in teachers {
                    self.models.append(teacher)
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.models = teachers
            }
            
            self.currentState = .content
            DispatchQueue.main.async { () -> Void in
                finish?()
            }
        }
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case Section.teacher.rawValue:
            return true
        case Section.loadMore.rawValue:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let teacherId = (tableView.cellForRow(at: indexPath) as? TeacherTableViewCell)?.model?.id else { return }
        let viewController = TeacherDetailsController()
        viewController.teacherID = teacherId
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
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
            return allTeacherCount == models.count ? 0 : (models.isEmpty ? 0 : 1)

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case Section.teacher.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCellReusedId, for: indexPath) as! TeacherTableViewCell
            cell.model = models[indexPath.row]
            return cell
            
        case Section.loadMore.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewLoadmoreCellReusedId, for: indexPath) as! ThemeReloadView
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case Section.teacher.rawValue:
            break
            
        case Section.loadMore.rawValue:
            if let cell = cell as? ThemeReloadView {
                println("load more Teacher info")
                
                if !cell.activityIndicator.isAnimating {
                    cell.activityIndicator.startAnimating()
                }
                
                self.loadTeachers(isLoadMore: true, finish: { [weak cell] in
                    cell?.activityIndicator.stopAnimating()
                })
            }
            
        default:
            break
        }
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
