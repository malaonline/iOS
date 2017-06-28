//
//  LiveCourseDetailTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseDetailTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let LiveCourseDetailCellReuseId = [
        0: "LiveCourseDetailClassCellReuseId",          // 班级名称
        1: "LiveCourseDetailServiceCellReuseId",        // 课程服务
        2: "LiveCourseDetailDescCellReuseId",           // 课程介绍
        3: "LiveCourseDetailLecturerCellReuseId",       // 直播名师
        4: "LiveCourseAssistantCellReuseId",            // 助教
    ]
    
    let LiveCourseDetailCellTitle = [
        1: "班级名称",
        2: "课程服务",
        3: "课程介绍",
        4: "直播名师",
        5: "联系助教",
    ]
    
    // MARK: - Property
    /// 教师详情模型
    var model: LiveClassModel? {
        didSet {
            self.reloadData()
        }
    }
    
    
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
        backgroundColor = UIColor(named: .themeLightBlue)
        estimatedRowHeight = 400
        separatorStyle = .none
        
        register(LiveCourseDetailClassCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[0]!)
        register(LiveCourseDetailServiceCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[1]!)
        register(LiveCourseDetailDescCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[2]!)
        register(LiveCourseDetailLecturerCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[3]!)
        register(LiveCourseDetailAssistantCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[4]!)
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 12 : 6
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return LiveCourseDetailCellReuseId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: LiveCourseDetailCellReuseId[indexPath.section]!, for: indexPath)
        (reuseCell as! MalaBaseLiveCourseCell).title = LiveCourseDetailCellTitle[indexPath.section+1]
        
        switch indexPath.section {
        case 0:
            let cell = reuseCell as! LiveCourseDetailClassCell
            cell.model = model
            return cell
            
        case 1:
            let cell = reuseCell as! LiveCourseDetailServiceCell
            return cell
            
        case 2:
            let cell = reuseCell as! LiveCourseDetailDescCell
            cell.model = model
            return cell
            
        case 3:
            let cell = reuseCell as! LiveCourseDetailLecturerCell
            cell.model = model
            return cell
            
        case 4:
            let cell = reuseCell as! LiveCourseDetailAssistantCell
            cell.model = model
            return cell
            
        default:
            break
        }
        
        return reuseCell
    }
    
    
    deinit {
        println("LiveCourseDetail TableView deinit")
    }
}
