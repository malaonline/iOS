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
        case liveCourse
        case loadMore
    }
    
    // MARK: - Property
    /// 数据模型数组
    var models: [LiveClassModel] = [] {
        didSet {
            controller?.handleModels(models, tableView: self)
        }
    }
    weak var controller: LiveCourseViewController?
    
    
    // MARK: - Components
    private lazy var banner: BannerView = {
        let view = BannerView(frame: CGRect(x: 0, y: 0, width: MalaScreenWidth, height: MalaScreenWidth/3))
        return view
    }()
    
    
    // MARK: - Instance Method
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
        tableHeaderView = banner
        contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 48 + 6, right: 0)
        register(LiveCourseTableViewCell.self, forCellReuseIdentifier: LiveCourseTableViewCellReusedId)
        register(ThemeReloadView.self, forCellReuseIdentifier: LiveCourseTableViewLoadmoreCellReusedId)
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case Section.liveCourse.rawValue:
            break
            
        case Section.loadMore.rawValue:
            guard let cell = cell as? ThemeReloadView else { return }
            
            if !cell.activityIndicator.isAnimating {
                cell.activityIndicator.startAnimating()
            }
            
            controller?.loadLiveClasses(isLoadMore: true, finish: { 
                cell.activityIndicator.stopAnimating()
            })
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let classModel = (tableView.cellForRow(at: indexPath) as? LiveCourseTableViewCell)?.model else { return }
        let viewController = LiveCourseDetailViewController()
        viewController.model = classModel
        viewController.hidesBottomBarWhenPushed = true
        controller?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case Section.liveCourse.rawValue:
            return models.count
            
        case Section.loadMore.rawValue:
            return controller?.allCount == models.count ? 0 : (models.isEmpty ? 0 : 1)
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case Section.liveCourse.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewCellReusedId, for: indexPath) as! LiveCourseTableViewCell
            if indexPath.row < models.count {
                cell.model = models[indexPath.row]
            }
            return cell
            
        case Section.loadMore.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewLoadmoreCellReusedId, for: indexPath) as! ThemeReloadView
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    // MARK: - override
    override func reloadData() {
        DispatchQueue.main.async(execute: { () -> Void in
            super.reloadData()
        })
    }
}
