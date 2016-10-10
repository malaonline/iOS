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
        // 底部Tabbar留白
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 48 + 6, right: 0)
        return tableView
    }()
    /// 上课地点选择按钮
    private lazy var regionPickButton: RegionPicker = {
        let picker = RegionPicker()
        picker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FindTeacherViewController.regionsPickButtonDidTap)))
        return picker
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionsPickButtonDidTap(true)
        
        setupNotification()
        setupUserInterface()
        getCurrentLocation()
        
        // 开启下拉刷新
        self.tableView.startPullToRefresh() //loadTeachers()
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
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: MalaNotification_CommitCondition),
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                if !(self?.filterResultDidShow ?? false) {
                    self?.filterResultDidShow = true
                    self?.resolveFilterCondition()
                }
        }
    }
    
    private func setupUserInterface() {
        // Style
        defaultView.imageName = "filter_no_result"
        defaultView.text = "当前城市没有老师！"
        
        // titleView
        navigationItem.titleView = regionPickButton
        
        // 下拉刷新组件
        self.tableView.addPullToRefresh({ [weak self] in
            self?.loadTeachers()
            })
        
        // SubViews
        self.view.addSubview(tableView)
        
        // Autolayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view.snp.top)
            maker.left.equalTo(view.snp.left)
            maker.bottom.equalTo(view.snp.bottom)
            maker.right.equalTo(view.snp.right)
        }
        
        // 设置BarButtomItem间隔
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -12
        
        // leftBarButtonItem
        navigationItem.leftBarButtonItems = []
        
        // rightBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(customView:
            UIButton(
                imageName: "filter_normal",
                highlightImageName: "filter_press",
                target: self,
                action: #selector(FindTeacherViewController.filterButtonDidTap)
            )
        )
        navigationItem.rightBarButtonItems = [spacer, rightBarButtonItem]
    }
    
    ///  获取当前地理位置信息
    private func getCurrentLocation() {
        proposeToAccess(.location(.whenInUse), agreed: {
            
            MalaLocationService.turnOn()
            }, rejected: {
                self.alertCanNotAccessLocation()
        })
    }
    
    func loadTeachers(_ filters: [String: AnyObject]? = nil, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }
        MalaNetworking.sharedTools.loadTeachers(filters, page: currentPageIndex) { [weak self] result, error in
            if error != nil {
                println("FindTeacherViewController - loadTeachers Request Error")
                return
            }
            guard let dict = result as? [String: AnyObject] else {
                println("FindTeacherViewController - loadTeachers Format Error")
                return
            }
            
            let resultModel = ResultModel(dict: dict)
            
            /// 记录数据量
            if let count = resultModel.count, count != 0 {
                self?.allTeacherCount = count.integerValue
            }
            
            /// 若请求数达到最大, 执行return
            if let detail = resultModel.detail, (detail as NSString).containsString(MalaErrorDetail_InvalidPage) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    finish?()
                })
                return
            }
            
            if isLoadMore {
                
                ///  加载更多
                if resultModel.results != nil {
                    for object in ResultModel(dict: dict).results! {
                        if let dict = object as? [String: AnyObject] {
                            self?.tableView.teachers.append(TeacherModel(dict: dict))
                        }
                    }
                }
            }else {
                
                ///  如果不是加载更多，则刷新数据
                self?.tableView.teachers = []
                /// 解析数据
                if resultModel.results != nil {
                    for object in ResultModel(dict: dict).results! {
                        if let dict = object as? [String: AnyObject] {
                            self?.tableView.teachers.append(TeacherModel(dict: dict))
                        }
                    }
                }
                self?.tableView.reloadData()
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                finish?()
            })
        }
    }
    
    private func resolveFilterCondition() {
        let viewController = FilterResultController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - Event Response
    @objc private func regionsPickButtonDidTap(_ isStartup: Bool) {
        
        if let _ = MalaUserDefaults.currentSchool.value {
            
            // 启动时如果已选择过地点，则不显示地点选择面板
            if isStartup {
                return
            }
            
            // 地点选择器
            let viewController = RegionViewController()
            viewController.didSelectAction = { [weak self] in
                self?.loadTeachers()
                self?.regionPickButton.schoolName = MalaCurrentSchool?.name
            }
            
            navigationController?.present(
                UINavigationController(rootViewController: viewController),
                animated: true,
                completion: nil
            )
        }else {
            // 初次启动时
            let viewController = CityTableViewController()
            viewController.didSelectAction = { [weak self] in
                self?.loadTeachers()
                self?.regionPickButton.schoolName = MalaCurrentSchool?.name
            }
            
            navigationController?.present(
                UINavigationController(rootViewController: viewController),
                animated: true,
                completion: nil
            )
        }
    }

    @objc private func filterButtonDidTap() {
        TeacherFilterPopupWindow(contentView: FilterView(frame: CGRect.zero)).show()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: MalaNotification_CommitCondition), object: nil)
    }
}
