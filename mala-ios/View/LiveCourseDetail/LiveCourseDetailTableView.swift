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
        1: "LiveCourseDetailDescCellReuseId",           // 课程介绍
        2: "LiveCourseDetailLecturerCellReuseId",       // 直播名师
    ]
    
    let LiveCourseDetailCellTitle = [
        1: "班级名称",
        2: "课程介绍",
        3: "直播名师",
    ]
    
    // MARK: - Property
    /// 教师详情模型
    var model: LiveClassModel? {
        didSet {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.reloadData()
            })
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
        backgroundColor = MalaColor_EDEDED_0
        estimatedRowHeight = 400
        separatorStyle = .none
        bounces = false
        contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 4, right: 0)
        
        register(LiveCourseDetailClassCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[0]!)
        register(LiveCourseDetailDescCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[1]!)
        register(LiveCourseDetailLecturerCell.self, forCellReuseIdentifier: LiveCourseDetailCellReuseId[2]!)
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return LiveCourseDetailCellReuseId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: LiveCourseDetailCellReuseId[(indexPath as NSIndexPath).section]!, for: indexPath)
        (reuseCell as! MalaBaseLiveCourseCell).title = LiveCourseDetailCellTitle[(indexPath as NSIndexPath).section+1]
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = reuseCell as! LiveCourseDetailClassCell
            return cell
            
        case 1:
            let cell = reuseCell as! LiveCourseDetailDescCell
            return cell
            
        case 2:
            let cell = reuseCell as! LiveCourseDetailLecturerCell
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
