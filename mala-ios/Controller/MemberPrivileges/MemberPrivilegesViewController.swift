//
//  MemberPrivilegesViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/16.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let MemberPrivilegesMemberLoginCellReuseID = "MemberPrivilegesMemberLoginCellReuseID"
private let MemberPrivilegesMemberNoteCellReuseID = "MemberPrivilegesMemberNoteCellReuseID"
private let MemberPrivilegesMemberReportCellReuseID = "MemberPrivilegesMemberReportCellReuseID"
private let MemberPrivilegesMemberSerivceCellReuseID = "MemberPrivilegesMemberSerivceCellReuseID"


class MemberPrivilegesViewController: UITableViewController {

    static let shared = MemberPrivilegesViewController()
    
    // MARK: - Property
    /// 学科学习报告模型
    var report: SubjectReport = SubjectReport() {
        didSet {
            MalaSubjectReport = report
        }
    }
    /// 总练习数
    var totalNum: CGFloat = 0 {
        didSet {
            MalaReportTotalNum = totalNum
        }
    }
    /// 练习正确数
    var rightNum: CGFloat = 0 {
        didSet {
            MalaReportRightNum = rightNum
        }
    }
    /// 学习报告状态
    var reportStatus: MalaLearningReportStatus = .LoggingIn {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var exerciseRecord: UserExerciseRecord? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    /// 是否已Push新控制器标示（屏蔽pop到本页面时的数据刷新动作）
    var isPushed: Bool = false

    
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
        if !isPushed {
            loadUserExerciseRecord()
            loadStudyReportOverview()
        }
        isPushed = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isPushed {
            sendScreenTrack(SAStudyReportViewName)
        }
    }

    
    // MARK: - Private Method
    private func configure() {
        tableView.es_addPullToRefresh(animator: ThemeRefreshHeaderAnimator()) {
            self.loadUserExerciseRecord()
        }
        
        tableView.backgroundColor = UIColor(named: .themeLightBlue)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 270
        tableView.register(MemberLoginCell.self, forCellReuseIdentifier: MemberPrivilegesMemberLoginCellReuseID)
        tableView.register(MemberNoteCell.self, forCellReuseIdentifier: MemberPrivilegesMemberNoteCellReuseID)
        tableView.register(MemberReportCell.self, forCellReuseIdentifier: MemberPrivilegesMemberReportCellReuseID)
        tableView.register(MemberSerivceCell.self, forCellReuseIdentifier: MemberPrivilegesMemberSerivceCellReuseID)
    }

    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_PushIntroduction,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            
            if let index = notification.object as? Int {
                // 跳转到简介页面
                let viewController = ThemeIntroductionView()
                viewController.hidesBottomBarWhenPushed = true
                viewController.index = index
                viewController.title = L10n.member
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: MalaNotification_ReloadLearningReport,
            object: nil,
            queue: nil) { [weak self] (notification) in
                self?.loadStudyReportOverview()
        }
    }
    
    private func loadUserExerciseRecord() {
        
        if !MalaUserDefaults.isLogined {
            self.tableView.es_stopPullToRefresh()
            return
        }
        
        MAProvider.userNewMessageCount(failureHandler: { (error) in
            defer { self.tableView.es_stopPullToRefresh() }
            DispatchQueue.main.async {
                self.showToast("网络不给力，可尝试下拉刷新")
            }
            self.exerciseRecord = MalaUserDefaults.exerciseRecord.value
        }) { (messages) in
            defer { self.tableView.es_stopPullToRefresh() }
            
            guard let messages = messages else { return }
            print("Exercise Record", messages.description)
            
            if let newTotal = messages.exerciseRecord?.mistakes?.total,
               let oldTotal = self.exerciseRecord?.mistakes?.total,
                newTotal > oldTotal {
                DispatchQueue.main.async {
                    self.showToast(String(format: "新增%d题", (newTotal-oldTotal)))
                }
            }
            
            self.exerciseRecord = messages.exerciseRecord
            MalaUserDefaults.exerciseRecord.value = messages.exerciseRecord
        }
    }
    
    // 获取学生学习报告总结
    private func loadStudyReportOverview() {
        
        reportStatus = .LoggingIn
        
        // 未登录状态
        if !MalaUserDefaults.isLogined {
            self.reportStatus = .UnLogged
            return
        }
        
        MAProvider.userStudyReport(failureHandler: { error in
            /* DispatchQueue.main.async {
                self.reportStatus = .Error
                self.showToast(L10n.memberServerError)
            } */
        }) { [weak self] results in
            println("学习报告：\(results)")
            
            // 默认登录未报名状态
            var status: MalaLearningReportStatus = .UnSigned
            
            // 遍历学科报名情况
            for singleReport in results {
                
                // 已报名支持学习报告的科目
                if singleReport.subject_id == 1 && singleReport.supported && singleReport.purchased {
                    self?.totalNum = CGFloat(singleReport.total_nums)
                    self?.rightNum = CGFloat(singleReport.right_nums)
                    status = .MathSigned
                    break
                }
                
                // 报名非数学状态
                if singleReport.supported == true && singleReport.purchased == false {
                    status = .UnSignedMath
                }
            }
            
            // 若当前学习报告状态正确，获取学科学习报告数据
            if status == .MathSigned {
                self?.loadSubjectReport()
            }else {
                self?.reportStatus = status
            }
        }
    }
    
    // 获取学科学习报告
    private func loadSubjectReport() {
        MAProvider.userSubjectReport(id: 1, failureHandler: { error in
            DispatchQueue.main.async {
                self.reportStatus = .Error
                self.showToast(L10n.memberServerError)
            }
        }) { report in
            println("学科学习报告：\(report)")
            self.report = report
            self.reportStatus = .MathSigned
        }
    }
    
    
    // MARK: - Event Response
    /// 登录
    @objc func login(completion: (()->Void)? = nil) {
        
        let loginViewController = LoginViewController()
        loginViewController.popAction = { [weak self] in
            self?.loadStudyReportOverview()
        }

        self.present(
            UINavigationController(rootViewController: loginViewController),
            animated: true,
            completion: completion
        )
        isPushed = true
    }
    /// 错题本样本
    @objc func showMistakeDemo(completion: (()->Void)? = nil) {
        let viewController = ExerciseMistakeController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        isPushed = true
    }
    
    
    /// 显示学习报告样本
    @objc func showReportDemo() {
        let viewController = LearningReportViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        isPushed = true
    }
    /// 显示我的学习报告
    @objc func showMyReport() {
        let viewController = LearningReportViewController()
        viewController.sample = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        isPushed = true
    }
    
    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MalaUserDefaults.isLogined ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if MalaUserDefaults.isLogined {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: MemberPrivilegesMemberNoteCellReuseID, for: indexPath) as! MemberNoteCell
                cell.model = self.exerciseRecord
                return cell
            case 1: return tableView.dequeueReusableCell(withIdentifier: MemberPrivilegesMemberReportCellReuseID, for: indexPath) as! MemberReportCell
            case 2: return tableView.dequeueReusableCell(withIdentifier: MemberPrivilegesMemberSerivceCellReuseID, for: indexPath) as! MemberSerivceCell
            default: return UITableViewCell()
            }
        }else {
            switch indexPath.row {
            case 0: return tableView.dequeueReusableCell(withIdentifier: MemberPrivilegesMemberLoginCellReuseID, for: indexPath) as! MemberLoginCell
            case 1: return tableView.dequeueReusableCell(withIdentifier: MemberPrivilegesMemberSerivceCellReuseID, for: indexPath) as! MemberSerivceCell
            default: return UITableViewCell()
            }
        }
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushIntroduction, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_ReloadLearningReport, object: nil)
    }
}
