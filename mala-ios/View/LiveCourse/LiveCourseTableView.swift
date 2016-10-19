//
//  LiveCourseTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let LiveCourseTableViewCellReusedId = "LiveCourseTableViewCellReusedId"
private let LiveCourseTableViewLoadmoreCellReusedId = "LiveCourseTableViewLoadmoreCellReusedId"

class LiveCourseTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case teacher
        case loadMore
    }
    
    // MARK: - Property
    /// 老师数据模型数组
    var model: [LiveClassModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    weak var controller: UIViewController?
    /// 上拉刷新视图
    private lazy var reloadView: ThemeReloadView = {
        let reloadView = ThemeReloadView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        return reloadView
    }()
    
    
    // MARK: - Contructed
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        configration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configration() {
        delegate = self
        dataSource = self
        backgroundColor = MalaColor_EDEDED_0
        estimatedRowHeight = 200
        separatorStyle = .none
        contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        register(LiveCourseTableViewCell.self, forCellReuseIdentifier: LiveCourseTableViewCellReusedId)
        register(ThemeReloadView.self, forCellReuseIdentifier: LiveCourseTableViewLoadmoreCellReusedId)
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case Section.teacher.rawValue:
            return true
        case Section.loadMore.rawValue:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let teacherId = (tableView.cellForRow(at: indexPath) as? LiveCourseTableViewCell)?.model?.id else {
            return
        }
        
        let viewController = TeacherDetailsController()
        viewController.teacherID = teacherId
        viewController.hidesBottomBarWhenPushed = true
        controller?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case Section.teacher.rawValue:
            return model.count
            
        case Section.loadMore.rawValue:
            if (controller as? FindTeacherViewController)?.allTeacherCount == model.count {
                return 0
            }else if (controller as? FilterResultController)?.allTeacherCount == model.count {
                return 0
            }else {
                return model.isEmpty ? 0 : 1
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).section {
            
        case Section.teacher.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewCellReusedId, for: indexPath) as! LiveCourseTableViewCell
             cell.model = model[(indexPath as NSIndexPath).row]
            return cell
            
        case Section.loadMore.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewLoadmoreCellReusedId, for: indexPath) as! ThemeReloadView
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        switch (indexPath as NSIndexPath).section {
//            
//        case Section.teacher.rawValue:
//            break
//            
//        case Section.loadMore.rawValue:
//            if let cell = cell as? ThemeReloadView {
//                println("load more Teacher info")
//                
//                if !cell.activityIndicator.isAnimating {
//                    cell.activityIndicator.startAnimating()
//                }
//                
//                if let viewController = (controller as? FindTeacherViewController) {
//                    viewController.loadTeachers(isLoadMore: true, finish: { [weak cell] in
//                        cell?.activityIndicator.stopAnimating()
//                        })
//                    
//                }else if let viewController = (controller as? FilterResultController) {
//                    viewController.loadTeachers(isLoadMore: true, finish: { [weak cell] in
//                        cell?.activityIndicator.stopAnimating()
//                        })
//                }
//            }
//            
//        default:
//            break
//        }
    }
    
    
    // MARK: - override
    override func reloadData() {
        DispatchQueue.main.async(execute: { () -> Void in
            super.reloadData()
        })
        self.stopPullRefreshEver()
    }
}
