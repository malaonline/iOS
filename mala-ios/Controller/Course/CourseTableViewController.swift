//
//  CourseTableViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/14.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let CourseTableViewSectionHeaderViewReuseId = "CourseTableViewSectionHeaderViewReuseId"
private let CourseTableViewCellReuseId = "CourseTableViewCellReuseId"

open class CourseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Property
    /// 上课时间表数据模型
    var model: [[[StudentCourseModel]]]? {
        didSet {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                ThemeHUD.hideActivityIndicator()
                if self?.model?.count == 0 {
                    self?.defaultView.isHidden = false
                    self?.goTopButton.isHidden = true
                }else {
                    self?.defaultView.isHidden = true
                    self?.goTopButton.isHidden = false
                    self?.tableView.reloadData()
                    self?.scrollToToday()
                }
            })
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
    
    
    // MARK: - Components
    /// "跳转最近的未上课程"按钮
    private lazy var goTopButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "goTop"), for: UIControlState())
        button.addTarget(self, action: #selector(CourseTableViewController.scrollToToday), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    /// 我的课表缺省面板
    private lazy var defaultView: UIView = {
        let view = MalaDefaultPanel()
        view.imageName = "course_noData"
        view.text = "暂时还没有课程哦"
        view.buttonTitle = "去报名"
        view.addTarget(self, action: #selector(CourseTableViewController.switchToFindTeacher))
        view.isHidden = true
        return view
    }()
    /// 我的课表未登录面板
    private lazy var unLoginDefaultView: UIView = {
        let view = MalaDefaultPanel()
        view.imageName = "course_noData"
        view.text = "您还没有登录"
        view.buttonTitle = "去登录"
        view.addTarget(self, action: #selector(CourseTableViewController.switchToLoginView))
        view.isHidden = true
        return view
    }()
    /// 保存按钮
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(
            title: "今天",
            titleColor: MalaColor_82B4D9_0,
            target: self,
            action: #selector(CourseTableViewController.scrollToToday)
        )
        saveButton.setTitleColor(MalaColor_E0E0E0_95, for: .disabled)
        return saveButton
    }()
    /// 导航栏TitleView
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "课表",
            fontSize: 16,
            textColor: MalaColor_000000_0
        )
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
        tableView.addSubview(defaultView)
        tableView.addSubview(unLoginDefaultView)
        
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
        defaultView.snp.makeConstraints { (maker) -> Void in
            maker.size.equalTo(tableView)
            maker.center.equalTo(tableView)
        }
        unLoginDefaultView.snp.makeConstraints { (maker) -> Void in
            maker.size.equalTo(tableView)
            maker.center.equalTo(tableView)
        }
        if let titleView = navigationItem.titleView {
            titleLabel.snp.makeConstraints { (maker) -> Void in
                maker.center.equalTo(titleView)
            }
        }
    }
    
    ///  获取学生可用时间表
    private func loadStudentCourseTable() {
        
        // 用户登录后请求数据，否则显示默认页面
        if !MalaUserDefaults.isLogined {
            
            unLoginDefaultView.isHidden = false
            
            // 若在注销后存在课程数据残留，清除数据并刷新日历
            if model != nil {
                model = nil
                tableView.reloadData()
            }
            return
        }else {
            unLoginDefaultView.isHidden = true
        }
        ThemeHUD.showActivityIndicator()
        
        // 发送网络请求
        getStudentCourseTable(failureHandler: { (reason, errorMessage) -> Void in
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseTableViewController - loadStudentCourseTable Error \(errorMessage)")
            }
            ThemeHUD.hideActivityIndicator()
        }, completion: { [weak self] (courseList) -> Void in
            // 解析学生上课时间表
            let result = parseStudentCourseTable(courseList)
            self?.recentlyCourseIndexPath = result.recently
            self?.model = result.model
        })
    }
    
    
    // MARK: - DataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return model?.count ?? 0
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?[section].count ?? 0
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCellReuseId, for: indexPath) as! CourseTableViewCell
        cell.model = model?[indexPath.section][indexPath.row]
        return cell
    }
    
    
    // MARK: - Delegate
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CourseTableViewSectionHeaderViewReuseId) as! CourseTableViewSectionHeader
        headerView.timeInterval = model?[section][0][0].end
        return headerView
    }
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 当最近一节课程划出屏幕时，显示“回到最近课程”按钮
        if indexPath == recentlyCourseIndexPath {
            goTopButton.isHidden = false
        }
    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((model?[indexPath.section][indexPath.row].count ?? 0) * 123)
    }
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - Event Response
    ///  滚动到近日首个未上课程
    @objc private func scrollToToday() {
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            self?.tableView.scrollToRow(at: self?.recentlyCourseIndexPath ?? IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
    }
    ///  跳转到挑选老师页面
    @objc private func switchToFindTeacher() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = MainViewController()
            appDelegate.switchTabBarControllerWithIndex(0)
        }
    }
    ///  跳转到登陆页面
    @objc private func switchToLoginView() {
        
        let loginView = LoginViewController()
        loginView.popAction = loadStudentCourseTable
        
        self.present(
            UINavigationController(rootViewController: loginView),
            animated: true,
            completion: { () -> Void in
                
        })
    }
}
