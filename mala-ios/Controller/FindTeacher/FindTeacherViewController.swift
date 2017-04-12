//
//  FindTeacherViewController.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

private let TeacherTableViewCellReusedId = "TeacherTableViewCellReusedId"
private let TeacherTableViewLoadmoreCellReusedId = "TeacherTableViewLoadmoreCellReusedId"

class FindTeacherViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 48 + 6, right: 0)
        tableView.register(TeacherTableViewCell.self, forCellReuseIdentifier: TeacherTableViewCellReusedId)
        tableView.register(ThemeReloadView.self, forCellReuseIdentifier: TeacherTableViewLoadmoreCellReusedId)
        return tableView
    }()
    /// 上拉刷新视图
    private lazy var reloadView: ThemeReloadView = {
        let reloadView = ThemeReloadView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        return reloadView
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
        tableView.startPullRefresh() //loadTeachers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendScreenTrack(SAfindTeacherName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeStatusBarBlack()
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
        
        // 下拉刷新
        tableView.addPullRefresh{ [weak self] in
            self?.loadTeachers()
            self?.tableView.stopPullRefreshEver()
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
                self?.loadTeachers()
        }
    }
    
    func loadTeachers(_ filters: [String: AnyObject]? = nil, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        guard currentState != .loading else { return }
        if !isLoadMore { models = [] }
        currentState = .loading
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }
        
        print(filters ?? [], currentPageIndex)
        
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
            print(allTeacherCount, models.count)
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
        
        if indexPath.section == 0 && indexPath.row <= 5 {
            goTopButton.isHidden = true
        }
        
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row >= 5 {
            goTopButton.isHidden = false
        }
    }
    
    
    // MARK: - Private Method
    private func resolveFilterCondition() {
        let viewController = FilterResultController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
