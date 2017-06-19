//
//  LiveCourseViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import ESPullToRefresh

private let LiveCourseTableViewCellReusedId = "LiveCourseTableViewCellReusedId"

class LiveCourseViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: - Property
    var models: [LiveClassModel] = [] {
        didSet {
            
            if models.count == 0 && self.tableView.es_footer != nil {
                self.tableView.es_removeRefreshFooter()
            }else {
                self.addLoadMoreAction()
            }
            
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: .themeLightBlue)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.banner
        tableView.register(LiveCourseTableViewCell.self, forCellReuseIdentifier: LiveCourseTableViewCellReusedId)
        return tableView
    }()
    private lazy var banner: BannerView = {
        let view = BannerView(frame: CGRect(x: 0, y: 0, width: MalaScreenWidth, height: MalaScreenWidth/3))
        return view
    }()
    private lazy var goTopButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .gotopNormal), for: .normal)
        button.setBackgroundImage(UIImage(asset: .gotopPress), for: .highlighted)
        button.addTarget(self, action: #selector(LiveCourseViewController.scrollToTop), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        setupNotification()
        configration()
        
        tableView.es_startPullToRefresh()
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
        tableView.es_addPullToRefresh(animator: ThemeRefreshHeaderAnimator()) { [weak self] in
            self?.tableView.es_resetNoMoreData()
            self?.loadLiveClasses(finish: {
                let isIgnore = (self?.models.count ?? 0 >= 0) && (self?.models.count ?? 0 <= 2)
                self?.tableView.es_stopPullToRefresh(ignoreDate: false, ignoreFooter: isIgnore)
            })
        }
        self.addLoadMoreAction()
        
        
        // SubViews
        view.addSubview(tableView)
        view.addSubview(goTopButton)
        
        // AutoLayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(view)
            maker.size.equalTo(view)
        }
        goTopButton.snp.makeConstraints { (maker) -> Void in
            maker.right.equalTo(view).offset(-20)
            maker.bottom.equalTo(view).offset(-64)
            maker.width.equalTo(56)
            maker.height.equalTo(56)
        }
    }
    
    private func configration() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(LiveCourseViewController.didRecognize(gesture:)))
        swipeUpGesture.direction = .up
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(LiveCourseViewController.didRecognize(gesture:)))
        swipeDownGesture.direction = .down
        swipeUpGesture.delegate = self
        swipeDownGesture.delegate = self
        tableView.addGestureRecognizer(swipeUpGesture)
        tableView.addGestureRecognizer(swipeDownGesture)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_LoadTeachers,
            object: nil,
            queue: nil) { [weak self] (notification) in
                self?.tableView.es_startPullToRefresh()
        }
    }
    
    ///  获取双师直播班级列表
    func loadLiveClasses(_ page: Int = 1, isLoadMore: Bool = false, finish: (()->())? = nil) {
        // 屏蔽[正在刷新]时的操作
        guard currentState != .loading else { return }
        
        currentState = .loading
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            models = []
            currentPageIndex = 1
        }

        MAProvider.getLiveClasses(page: currentPageIndex, failureHandler: { error in
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
        }) { (classList, count) in
            
            defer { DispatchQueue.main.async { finish?() } }
            
            guard !classList.isEmpty && count != 0 else {
                self.currentState = .empty
                return
            }
    
            ///  加载更多
            if isLoadMore {
                self.models += classList
                if self.models.count == count {
                    self.tableView.es_noticeNoMoreData()
                }else {
                    self.tableView.es_resetNoMoreData()
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.models = classList
            }
            
            self.allCount = count
            self.currentState = .content
        }
    }
    
    private func addLoadMoreAction() {
        tableView.es_addInfiniteScrolling(animator: ThemeRefreshFooterAnimator()) { [weak self] in
            self?.loadLiveClasses(isLoadMore: true, finish: {
                self?.tableView.es_stopLoadingMore()
            })
        }
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row <= 5 {
            goTopButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row >= 5 {
            goTopButton.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let classId = (tableView.cellForRow(at: indexPath) as? LiveCourseTableViewCell)?.model?.id else { return }
        let viewController = LiveCourseDetailViewController()
        viewController.classId = classId
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 222
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewCellReusedId, for: indexPath) as! LiveCourseTableViewCell
        if indexPath.row < models.count {
            cell.model = models[indexPath.row]
        }
        return cell
    }

    
    // MARK: - API
    /// Banner点击事件
    func bannerDidTap() {
        let webViewController = MalaSingleWebViewController()
        webViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webViewController, animated: true)
        webViewController.loadURL(url: MalaConfig.adURL())
    }
    
    func scrollToTop() {
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    func didRecognize(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            RootViewController.shared.navigationController?.setNavigationBarHidden(true, animated: true)
        }else if gesture.direction == .down {
            RootViewController.shared.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let direction = (otherGestureRecognizer as? UISwipeGestureRecognizer)?.direction, (direction == .up || direction == .down) else {
            return false
        }
        return true
    }
}

extension LiveCourseViewController {
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadLiveClasses()
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.loadLiveClasses()
    }
}
