//
//  LiveCourseViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let LiveCourseTableViewCellReusedId = "LiveCourseTableViewCellReusedId"
private let LiveCourseTableViewLoadmoreCellReusedId = "LiveCourseTableViewLoadmoreCellReusedId"

class LiveCourseViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case liveCourse
        case loadMore
    }
    
    // MARK: - Property
    var models: [LiveClassModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 当前显示页数
    var currentPageIndex = 1
    /// 数据总量
    var allCount = 0
    override var currentState: StatefulViewState {
        didSet {
            if currentState != oldValue {
                self.tableView.reloadEmptyDataSet()
            }
        }
    }

    
    // MARK: - Components
    /// 老师信息tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        return tableView
    }()
    private lazy var banner: BannerView = {
        let view = BannerView(frame: CGRect(x: 0, y: 0, width: MalaScreenWidth, height: MalaScreenWidth/3))
        return view
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        setupNotification()
        configration()
        
        // 开启下拉刷新
        tableView.startPullRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // stateful
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // 下拉刷新
        tableView.addPullRefresh{ [weak self] in
            self?.loadLiveClasses()
            self?.tableView.stopPullRefreshEver()
        }
        
        // SubViews
        view.addSubview(tableView)
        
        // AutoLayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.bottom.equalTo(view)
            maker.right.equalTo(view)
        }
    }
    
    private func configration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.tableHeaderView = banner
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 48 + 6, right: 0)
        tableView.register(LiveCourseTableViewCell.self, forCellReuseIdentifier: LiveCourseTableViewCellReusedId)
        tableView.register(ThemeReloadView.self, forCellReuseIdentifier: LiveCourseTableViewLoadmoreCellReusedId)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_LoadTeachers,
            object: nil,
            queue: nil) { [weak self] (notification) in
                self?.loadLiveClasses()
        }
    }
    
    ///  获取双师直播班级列表
    func loadLiveClasses(_ page: Int = 1, isLoadMore: Bool = false, finish: (()->())? = nil) {
        // 屏蔽[正在刷新]时的操作
        guard currentState != .loading else { return }
        if !isLoadMore { models = [] }
        currentState = .loading
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }

        MAProvider.getLiveClasses(page: currentPageIndex, failureHandler: { error in
            self.currentState = .error
            DispatchQueue.main.async {
                finish?()
            }
        }) { (classList, count) in
            
            guard !classList.isEmpty && count != 0 else {
                self.currentState = .empty
                return
            }
            
            /// 记录数据量
            self.allCount = count
            
            if isLoadMore {
                ///  加载更多
                for course in classList {
                    self.models.append(course)
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.models = classList
            }
            
            self.currentState = .content
            DispatchQueue.main.async {
                finish?()
            }
        }
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case Section.liveCourse.rawValue:
            break
            
        case Section.loadMore.rawValue:
            guard let cell = cell as? ThemeReloadView else { return }
            
            if !cell.activityIndicator.isAnimating {
                cell.activityIndicator.startAnimating()
            }
            
            self.loadLiveClasses(isLoadMore: true, finish: {
                cell.activityIndicator.stopAnimating()
            })
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let classId = (tableView.cellForRow(at: indexPath) as? LiveCourseTableViewCell)?.model?.id else { return }
        let viewController = LiveCourseDetailViewController()
        viewController.classId = classId
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case Section.liveCourse.rawValue:
            return models.count
            
        case Section.loadMore.rawValue:
            return allCount == models.count ? 0 : (models.isEmpty ? 0 : 1)
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case Section.liveCourse.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewCellReusedId, for: indexPath) as! LiveCourseTableViewCell
            if indexPath.row < models.count {
                cell.model = models[indexPath.row]
            }
            return cell
            
        case Section.loadMore.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewLoadmoreCellReusedId, for: indexPath) as! ThemeReloadView
            return cell
            
        default:
            return UITableViewCell()
        }
    }

    
    // MARK: - API
    /// Banner点击事件
    func bannerDidTap() {
        let webViewController = MalaSingleWebViewController()
        webViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webViewController, animated: true)
        webViewController.loadURL(url: MalaConfig.adURL())
    }
}

extension LiveCourseViewController {
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        
    }
}
