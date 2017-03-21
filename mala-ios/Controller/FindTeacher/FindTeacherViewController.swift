//
//  FindTeacherViewController.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

private let TeacherTableViewCellReusedId = "TeacherTableViewCellReusedId"

class FindTeacherViewController: BaseViewController {
    
    // MARK: - Property
    private var filterResultDidShow: Bool = false
    /// 当前显示页数
    var currentPageIndex = 1
    /// 所有老师数据总量
    var allTeacherCount = 0
    
    
    // MARK: - Components
    /// 老师信息tableView
    private lazy var tableView: TeacherTableView = {
        let tableView = TeacherTableView(frame: self.view.frame, style: .plain)
        tableView.controller = self
        return tableView
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
        // Style
        defaultView.imageName = "filter_no_result"
        defaultView.text = L10n.noTeacher
        
        // 下拉刷新
        tableView.addPullRefresh{ [weak self] in
            self?.loadTeachers()
        }
        
        // SubViews
        view.addSubview(tableView)
        
        // Autolayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.bottom.equalTo(view)
            maker.right.equalTo(view)
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
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }
        
        MAProvider.loadTeachers(condition: filters, page: currentPageIndex, failureHandler: { error in
            DispatchQueue.main.async {
                finish?()
            }
        }) { (teachers, count) in
            /// 记录数据量
            self.allTeacherCount = max(count, self.allTeacherCount)
            
            if isLoadMore {
                ///  加载更多
                for teacher in teachers {
                    self.tableView.teachers.append(teacher)
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.tableView.teachers = teachers
            }
            
            self.tableView.reloadData()
            DispatchQueue.main.async { () -> Void in
                finish?()
            }
        }
    }
    
    private func resolveFilterCondition() {
        let viewController = FilterResultController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_CommitCondition, object: nil)
        NotificationCenter.default.removeObserver(self, name: MalaNotification_LoadTeachers, object: nil)
    }
}
