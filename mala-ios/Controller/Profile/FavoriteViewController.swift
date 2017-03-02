//
//  FavoriteViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/8/2.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let FavoriteViewCellReuseId = "FavoriteViewCellReuseId"
private let FavoriteViewLoadmoreCellReusedId = "FavoriteViewLoadmoreCellReusedId"

class FavoriteViewController: BaseTableViewController {

    private enum Section: Int {
        case teacher
        case loadMore
    }
    
    // MARK: - Property
    /// 收藏老师模型列表
    var models: [TeacherModel] = [] {
        didSet {
            handleModels(models, tableView: tableView)
        }
    }
    /// 是否正在拉取数据
    var isFetching: Bool = false
    /// 当前显示页数
    var currentPageIndex = 1
    /// 所有老师数据总量
    var allCount = 0
    
    
    // MARK: - Components
    /// 下拉刷新视图
    private lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(FavoriteViewController.loadFavoriteTeachers), for: .valueChanged)
        return refresher
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteTeachers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Private Method
    private func configure() {
        title = L10n.myCollect
        defaultView.imageName = "collect_noData"
        defaultView.text = L10n.noCollect
        defaultView.descText = L10n.takeSomeCollect
        
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        refreshControl = refresher
        
        tableView.register(TeacherTableViewCell.self, forCellReuseIdentifier: FavoriteViewCellReuseId)
        tableView.register(ThemeReloadView.self, forCellReuseIdentifier: FavoriteViewLoadmoreCellReusedId)
    }
    
    
    @objc private func loadFavoriteTeachers(_ page: Int = 1,  isLoadMore: Bool = false, finish: (()->())? = nil) {
        
        
        // 屏蔽[正在刷新]时的操作
        guard isFetching == false else { return }

        isFetching = true
        refreshControl?.beginRefreshing()
        
        if isLoadMore {
            currentPageIndex += 1
        }else {
            currentPageIndex = 1
        }
        
        getFavoriteTeachers(currentPageIndex, failureHandler: { (reason, errorMessage) in
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("FavoriteViewController - loadFavoriteTeachers Error \(errorMessage)")
            }
            // 显示缺省值
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.isFetching = false
            }
        }, completion: { (teachers, count) in
            /// 记录数据量
            self.allCount = max(count, self.allCount)

            ///  加载更多
            if isLoadMore {
                for teacher in teachers {
                    self.models.append(teacher)
                }
            }else {
                ///  如果不是加载更多，则刷新数据
                self.models = teachers
            }
            
            DispatchQueue.main.async {
                finish?()
                self.refreshControl?.endRefreshing()
                self.isFetching = false
            }
        })
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case Section.teacher.rawValue:
            break
            
        case Section.loadMore.rawValue:
            guard let cell = cell as? ThemeReloadView else { return }
                
            if !cell.activityIndicator.isAnimating {
                cell.activityIndicator.startAnimating()
            }
            
            loadFavoriteTeachers(isLoadMore: true, finish: {
                cell.activityIndicator.stopAnimating()
            })
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teacherId = (tableView.cellForRow(at: indexPath) as! TeacherTableViewCell).model!.id
        let viewController = TeacherDetailsController()
        viewController.teacherID = teacherId
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case Section.teacher.rawValue:
            return models.count
            
        case Section.loadMore.rawValue:
            return allCount == models.count ? 0 : (models.isEmpty ? 0 : 1)
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case Section.teacher.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewCellReuseId, for: indexPath) as! TeacherTableViewCell
            cell.model = models[indexPath.row]
            return cell
            
        case Section.loadMore.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewLoadmoreCellReusedId, for: indexPath) as! ThemeReloadView
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}
