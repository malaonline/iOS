//
//  FavoriteViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/8/2.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let FavoriteViewCellReuseId = "FavoriteViewCellReuseId"

class FavoriteViewController: BaseTableViewController {
    
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
        
        tableView.register(TeacherTableViewCell.self, forCellReuseIdentifier: FavoriteViewCellReuseId)
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
        
        MAProvider.userCollection(page: currentPageIndex, failureHandler: { error in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.isFetching = false
            }
        }) { (teachers, count) in
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
        }
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teacherId = (tableView.cellForRow(at: indexPath) as! TeacherTableViewCell).model!.id
        let viewController = TeacherDetailsController()
        viewController.teacherID = teacherId
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewCellReuseId, for: indexPath) as! TeacherTableViewCell
        cell.model = models[indexPath.row]
        return cell
    }
    
}
