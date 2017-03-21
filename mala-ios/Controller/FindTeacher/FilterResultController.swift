//
//  FilterResultController.swift
//  mala-ios
//
//  Created by 王新宇 on 1/20/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class FilterResultController: BaseViewController {

    // MARK: - Property
    /// 当前显示页数
    var currentPageIndex = 1
    /// 所有老师数据总量
    var allTeacherCount = 0
    
    
    // MARK: - Components
    /// 老师列表
    private lazy var tableView: TeacherTableView = {
        let tableView = TeacherTableView(frame: self.view.frame, style: .plain)
        tableView.controller = self
        return tableView
    }()
    /// 筛选条件面板
    private lazy var filterBar: FilterBar = {
        let filterBar = FilterBar(frame: CGRect.zero)
        filterBar.backgroundColor = UIColor(named: .RegularBackground)
        filterBar.controller = self
        return filterBar
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        loadTeachersWithCommonCondition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        defaultView.imageName = "filter_no_result"
        defaultView.text = L10n.resetCondition
        
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
    
    private func showDefatultViewWhenModelIsEmpty() {
        handleModels(tableView.teachers, tableView: tableView)
    }
    
    
    func loadTeachersWithCommonCondition() {
        loadTeachers(MalaCondition.getParam())
    }
    
    ///  根据筛选条件字典，请求老师列表
    ///
    ///  - parameter filters: 筛选条件字典
    func loadTeachers(_ filters: [String: Any]? = nil, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
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
                self.showDefatultViewWhenModelIsEmpty()
                finish?()
            }
        }
    }
    

    deinit {
        println("FilterResultController - Deinit")
        // 重置选择条件模型
        MalaFilterIndexObject.reset()
    }
}
