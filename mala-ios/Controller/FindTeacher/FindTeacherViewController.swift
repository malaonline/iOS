//
//  FindTeacherViewController.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit
import ESPullToRefresh

private let TeacherTableViewCellReusedId = "TeacherTableViewCellReusedId"

class FindTeacherViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: - Property
    var models: [TeacherModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var filterResultDidShow: Bool = false
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
    /// 老师信息tableView
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
    private lazy var goTopButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .goTop_normal), for: .normal)
        button.setBackgroundImage(UIImage(asset: .goTop_press), for: .highlighted)
        button.addTarget(self, action: #selector(LiveCourseViewController.scrollToTop), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        setupNotification()
        
        // 开启下拉刷新
        tableView.es_startPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendScreenTrack(SAfindTeacherName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filterResultDidShow = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // stateful
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // gesture
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(LiveCourseViewController.didRecognize(gesture:)))
        swipeUpGesture.direction = .up
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(LiveCourseViewController.didRecognize(gesture:)))
        swipeDownGesture.direction = .down
        
        swipeUpGesture.delegate = self
        swipeDownGesture.delegate = self
        tableView.addGestureRecognizer(swipeUpGesture)
        tableView.addGestureRecognizer(swipeDownGesture)
        
        // 下拉刷新
        tableView.es_addPullToRefresh(animator: ThemeRefreshHeaderAnimator()) {
            self.tableView.es_resetNoMoreData()
            self.loadTeachers(finish: {
                let isIgnore = (self.models.count > 0) && (self.models.count <= 2)
                self.tableView.es_stopPullToRefresh(ignoreDate: false, ignoreFooter: isIgnore)
            })
        }
        
        tableView.es_addInfiniteScrolling(animator: ThemeRefreshFooterAnimator()) {
            self.loadTeachers(isLoadMore: true, finish: {
                self.tableView.es_stopLoadingMore()
            })
        }
        
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
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_CommitCondition,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                if !(self?.filterResultDidShow ?? false) {
                    self?.filterResultDidShow = true
                    self?.resolveFilterCondition()
                }
        }
        NotificationCenter.default.addObserver(
            forName: MalaNotification_LoadTeachers,
            object: nil,
            queue: nil) { [weak self] (notification) in
                self?.tableView.es_startPullToRefresh()
        }
    }
    
    func loadTeachers(_ filters: [String: AnyObject]? = nil, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
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
    
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let direction = (otherGestureRecognizer as? UISwipeGestureRecognizer)?.direction, (direction == .up || direction == .down) else {
            return false
        }
        return true
    }
    
    
    // MARK: - Private Method
    private func resolveFilterCondition() {
        let viewController = FilterResultController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func didRecognize(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            RootViewController.shared.navigationController?.setNavigationBarHidden(true, animated: true)
        }else if gesture.direction == .down {
            RootViewController.shared.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_CommitCondition, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_LoadTeachers, object: nil)
    }
}


extension FindTeacherViewController {
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadTeachers()
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.loadTeachers()
    }
}
