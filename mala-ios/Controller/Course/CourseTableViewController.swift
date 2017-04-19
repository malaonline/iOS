//
//  CourseTableViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/14.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

private let CourseTableViewSectionHeaderViewReuseId = "CourseTableViewSectionHeaderViewReuseId"
private let CourseTableViewCellReuseId = "CourseTableViewCellReuseId"

public class CourseTableViewController: StatefulViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Property
    /// 上课时间表数据模型
    var model: [[[StudentCourseModel]]]? {
        didSet {
            DispatchQueue.main.async {
                if self.model?.count == 0 {
                    self.goTopButton.isHidden = true
                }else if self.model?.count != oldValue?.count {
                    self.goTopButton.isHidden = false
                    self.tableView.reloadData()
                    self.scrollToToday()
                }
            }
        }
    }
    /// 距当前时间最近的一节未上课程下标
    var recentlyCourseIndexPath: IndexPath?
    /// 当前显示年月（用于TitleView显示）
    var currentDate: TimeInterval? {
        didSet {
            if currentDate != oldValue {
                titleLabel.text = getDateTimeString(currentDate ?? 0, format: "yyyy年M月")
                titleLabel.sizeToFit()
            }
        }
    }
    override var currentState: StatefulViewState {
        didSet {
            if currentState != oldValue {
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    
    // MARK: - Components
    /// "跳转最近的未上课程"按钮
    private lazy var goTopButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .goTop), for: UIControlState())
        button.addTarget(self, action: #selector(CourseTableViewController.scrollToToday), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    /// 保存按钮
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(
            title: L10n.today,
            titleColor: UIColor(named: .ThemeBlue),
            target: self,
            action: #selector(CourseTableViewController.scrollToToday)
        )
        saveButton.setTitleColor(UIColor(named: .Disabled), for: .disabled)
        return saveButton
    }()
    /// 导航栏TitleView
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: L10n.schedule,
            textColor: UIColor.white
        )
        label.font = FontFamily.PingFangSC.Regular.font(16)
        return label
    }()
    
    
    // MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUserInterface()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentCourseTable()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendScreenTrack(SAMyCourseViewName)
    }
    
    // MARK: - Private Method
    private func configure() {
        // tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        
        // dataSet
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // register
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: CourseTableViewCellReuseId)
        tableView.register(CourseTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: CourseTableViewSectionHeaderViewReuseId)
    }
    
    private func setupUserInterface() {
        // Style
        navigationItem.titleView = UIView()
        navigationItem.titleView?.addSubview(titleLabel)
        
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
            maker.width.equalTo(58)
            maker.height.equalTo(58)
        }
        if let titleView = navigationItem.titleView {
            titleLabel.snp.makeConstraints { (maker) -> Void in
                maker.center.equalTo(titleView)
            }
        }
    }
    
    ///  获取学生可用时间表
    fileprivate func loadStudentCourseTable() {
        
        // 用户登录后请求数据，否则显示默认页面
        if !MalaUserDefaults.isLogined {
            
            currentState = .notLoggedIn
            
            // 若在注销后存在课程数据残留，清除数据并刷新日历
            if model != nil {
                model = nil
                tableView.reloadData()
            }
            return
        }
        
        guard currentState != .loading else { return }
        model = nil
        recentlyCourseIndexPath = nil
        currentState = .loading
        
        ///  获取学生课程信息
        MAProvider.getStudentSchedule(failureHandler: { error in
            println(error)
            self.currentState = .error
        }) { schedule in
            
            guard !schedule.isEmpty else {
                self.currentState = .empty
                return
            }
        
            // 解析学生上课时间表
            self.currentState = .content
            let result = parseStudentCourseTable(schedule)
            self.recentlyCourseIndexPath = result.recently
            self.model = result.model
        }
    }
    
    
    // MARK: - DataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return model?.count ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?[section].count ?? 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCellReuseId, for: indexPath) as! CourseTableViewCell
        cell.model = model?[indexPath.section][indexPath.row]
        return cell
    }
    
    
    // MARK: - Delegate
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CourseTableViewSectionHeaderViewReuseId) as! CourseTableViewSectionHeader
        headerView.timeInterval = model?[section][0][0].end
        return headerView
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 实时调整当前第一个显示的Cell日期为导航栏标题日期
        if let date = (tableView.visibleCells.first as? CourseTableViewCell)?.model?[0].end {
            currentDate = date
        }else {
            currentDate = Date().timeIntervalSince1970
        }
        // 当最近一节课程划出屏幕时，显示“回到最近课程”按钮
        if indexPath == recentlyCourseIndexPath {
            goTopButton.isHidden = true
        }
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 当最近一节课程划出屏幕时，显示“回到最近课程”按钮
        if indexPath == recentlyCourseIndexPath {
            goTopButton.isHidden = false
        }
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = Int(MalaConfig.singleCourseCellHeight()+1)
        return CGFloat((model?[indexPath.section][indexPath.row].count ?? 0) * height)
    }
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - Event Response
    ///  滚动到近日首个未上课程
    @objc private func scrollToToday() {
        
        guard let recent = self.recentlyCourseIndexPath else { return }
        
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: recent, at: .top, animated: true)
        }
    }
    ///  跳转到挑选老师页面
    @objc fileprivate func switchToFindTeacher() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = MainViewController()
            appDelegate.switchTabBarControllerWithIndex(0)
        }
    }
    ///  跳转到登陆页面
    @objc fileprivate func switchToLoginView() {
        
        let loginView = LoginViewController()
        loginView.popAction = loadStudentCourseTable
        
        self.present(
            UINavigationController(rootViewController: loginView),
            animated: true,
            completion: { () -> Void in
                
        })
    }
}

extension CourseTableViewController {
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        switch currentState {
        case .notLoggedIn:  switchToLoginView()
        case .empty:        switchToFindTeacher()
        case .error:        loadStudentCourseTable()
        default: break
        }
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        switch currentState {
        case .notLoggedIn:  switchToLoginView()
        case .empty:        switchToFindTeacher()
        case .error:        loadStudentCourseTable()
        default: break
        }
    }
}
