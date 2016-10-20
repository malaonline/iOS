//
//  LiveCourseViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseViewController: BaseViewController {
    
    // MARK: - Property
    var model: [LiveClassModel] = [] {
        didSet {
            tableView.model = model
        }
    }
    /// 当前显示页数
    var currentPageIndex = 1
    /// 数据总量
    var allCount = 0
    
    
    // MARK: - Components
    /// 老师信息tableView
    private lazy var tableView: LiveCourseTableView = {
        let tableView = LiveCourseTableView(frame: self.view.frame, style: .plain)
        tableView.controller = self        
        return tableView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        
        // 开启下拉刷新
        tableView.startPullRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        view.backgroundColor = MalaColor_EDEDED_0
        defaultView.imageName = "filter_no_result"
        defaultView.text = "当前城市没有老师！"
        
        // 下拉刷新
        tableView.addPullRefresh{ [weak self] in
            println("下拉刷新")
            self?.loadLiveClasses()
            self?.tableView.stopPullRefreshEver()
        }
        
        // SubViews
        view.addSubview(tableView)
        
        // AutoLayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view.snp.top)
            maker.left.equalTo(view.snp.left)
            maker.bottom.equalTo(view.snp.bottom)
            maker.right.equalTo(view.snp.right)
        }
    }
    
    ///  获取双师直播班级列表
    private func loadLiveClasses(_ page: Int = 1, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }
        
        ///  获取用户订单列表
        getLiveClasses(currentPageIndex, failureHandler: { (reason, errorMessage) in
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("LiveCourseViewController - loadLiveClasses Error \(errorMessage)")
            }
        }, completion: { [weak self] (classList, count) in
            
            println("获取双师直播 - \(classList) - \(count)")
            
            /// 记录数据量
            if count != 0 {
                self?.allCount = count
            }
            self?.model = classList
        })
    }
    
}
