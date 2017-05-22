//
//  CommentViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/7.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import ESPullToRefresh

private let CommentViewCellReuseId = "CommentViewCellReuseId"

class CommentViewController: BaseTableViewController {

    // MARK: - Property
    /// 优惠券模型数组
    var models: [StudentCourseModel] = [] {
        didSet {
            handleModels(models, tableView: tableView)
        }
    }
    /// 是否正在拉取数据
    var isFetching: Bool = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        configure()
        loadCourse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendScreenTrack(SAMyCommentsViewName)
        // 开启下拉刷新
        tableView.es_startPullToRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func configure() {
        tableView.es_addPullToRefresh(animator: ThemeRefreshHeaderAnimator(), handler: { 
            self.loadCourse(finish: { 
                self.tableView.es_stopPullToRefresh()
            })
        })
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 208
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        tableView.register(CommentViewCell.self, forCellReuseIdentifier: CommentViewCellReuseId)
    }
    
    private func setupUserInterface() {
        // Style
        defaultView.imageName = "comment_noData"
        defaultView.text = L10n.noComment
        defaultView.descText = L10n.commentLater
    }
    
    ///  获取学生课程信息
    @objc private func loadCourse(finish: (()->())? = nil) {

        ///  获取学生课程信息
        MAProvider.getStudentSchedule(onlyPassed: true, failureHandler: { error in
            defer { DispatchQueue.main.async { finish?() } }
            self.models = []
            self.isFetching = false
        }) { schedule in
            defer { DispatchQueue.main.async { finish?() } }
            self.isFetching = false
            self.models = schedule
        }
    }

    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewCellReuseId, for: indexPath) as! CommentViewCell
        cell.selectionStyle = .none
        cell.model = self.models[indexPath.row]
        return cell
    }
}
