//
//  ExerciseMistakeViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/5/23.
//  Copyright © 2017年 Mala Online. All rights reserved.
//

import UIKit

private let ExerciseMistakeCellReuseId = "ExerciseMistakeCellReuseId"

class ExerciseMistakeViewController: StatefulViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Models
    var models: [ExerciseMistakeRecord] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var currentPage = 1
    var allCount = 0
    override var currentState: StatefulViewState {
        didSet {
            if currentState != oldValue {
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    // MARK: - Components
    lazy var backBarButton: UIButton = {
        let backBarButton = UIButton(
            imageName: "leftArrow_white",
            highlightImageName: "leftArrow_white",
            target: self,
            action: #selector(ExerciseMistakeViewController.popSelf)
        )
        return backBarButton
    }()
    private lazy var subjectBar: SubjectSelectionBar = {
        let bar = SubjectSelectionBar(UIColor.white)
        return bar
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.backgroundColor = UIColor(named: .themeLightBlue)
        tableView.register(ExerciseMistakeCell.self, forCellReuseIdentifier: ExerciseMistakeCellReuseId)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        tableView.es_startPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func setup() {
        
        title = "我的错题"
        
        // 设置BarButtomItem间隔
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -2
        
        // leftBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        navigationItem.leftBarButtonItems = [spacer, leftBarButtonItem]
        
        // stateful
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // 下拉刷新
        tableView.es_addPullToRefresh(animator: ThemeRefreshHeaderAnimator()) {
            self.tableView.es_resetNoMoreData()
            self.loadExerciseMistakes(finish: { 
                self.tableView.es_stopPullToRefresh()
            })
        }
        tableView.es_addInfiniteScrolling(animator: ThemeRefreshFooterAnimator()) {
            self.loadExerciseMistakes(isLoadMore: true, finish: {
                self.tableView.es_stopLoadingMore()
            })
        }
        
        // Style
        view.backgroundColor = UIColor.white
        
        // SubViews
        view.addSubview(subjectBar)
        view.addSubview(tableView)
        
        // AutoLayout
        subjectBar.snp.makeConstraints { (maker) in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(44)
        }
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(subjectBar.snp.bottom)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(view)
        }
    }
    
    private func loadExerciseMistakes(_ subject: Int? = 2, page: Int = 1, isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        guard currentState != .loading else { return }
        currentState = .loading
        
        if isLoadMore {
            currentPage += 1
        }else {
            models = []
            currentPage = 1
        }
        
        MAProvider.loadExerciseMistakes(subject: subject, page: currentPage, failureHandler: { (error) in
            defer { DispatchQueue.main.async { finish?() } }
            
            if let statusCode = error.response?.statusCode, statusCode == 404 {
                if isLoadMore {
                    self.currentPage -= 1
                }
                self.tableView.es_noticeNoMoreData()
            }else {
                self.tableView.es_resetNoMoreData()
            }
            
            self.currentState = .error
        }) { (mistakes, count) in
            defer { DispatchQueue.main.async { finish?() } }
            
            guard !mistakes.isEmpty && count != 0 else {
                self.currentState = .empty
                return
            }
            
            ///  加载更多
            if isLoadMore {
                self.models += mistakes
                if self.models.count == count {
                    self.tableView.es_noticeNoMoreData()
                }else {
                    self.tableView.es_resetNoMoreData()
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.models = mistakes
            }
            
            self.allCount = count
            self.currentState = .content
        }
    }
    

    // MARK: - DataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseMistakeCellReuseId, for: indexPath) as! ExerciseMistakeCell
        cell.index = indexPath.row
        cell.model = models[indexPath.row]
        return cell
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
