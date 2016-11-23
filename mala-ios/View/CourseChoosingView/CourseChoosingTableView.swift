//
//  CourseChoosingTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

let CourseChoosingCellReuseId = [
    0: "CourseChoosingGradeCellReuseId",            // 选择授课年级
    1: "CourseChoosingClassScheduleCellReuseId",    // 选择上课时间（课程表）
    2: "CourseChoosingClassPeriodCellReuseId",      // 选择课时
    3: "CourseChoosingTimeScheduleCellReuseId",     // 上课时间表
    4: "CourseChoosingOtherServiceCellReuseId"      // 其他服务
]

let CourseChoosingCellTitle = [
    1: "选择授课年级",
    2: "选择上课时间",
    3: "选择小时",
    4: "上课时间",
    5: "",
]


class CourseChoosingTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Property
    /// 教师详情模型
    var teacherModel: TeacherDetailModel? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    /// 上课时间Cell展开标识
    var isOpenTimeScheduleCell: Bool = true {
        didSet {
            if isOpenTimeScheduleCell != oldValue {
                DispatchQueue.main.async {
                    self.reloadSections(IndexSet(integer: 3), with: .fade)
                }
            }
        }
    }
    /// 课程表数据模型
    var classScheduleModel: [[ClassScheduleDayModel]] = [] {
        didSet {
            // 刷新 [选择上课地点][选择小时][上课时间] Cell
            DispatchQueue.main.async {
                self.reloadSections(IndexSet(integer: 1), with: .fade)
            }

        }
    }
    /// 上课时间表数据
    var timeScheduleResult: [[TimeInterval]] = [] {
        didSet {
            // 刷新 [上课时间] Cell
            DispatchQueue.main.async {
                self.reloadSections(IndexSet(integer: 3), with: .fade)
            }

        }
    }
    var selectedIndexPath: IndexPath?
    
    
    // MARK: - Constructed
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
         
        
        register(CourseChoosingGradeCell.self, forCellReuseIdentifier: CourseChoosingCellReuseId[0]!)
        register(CourseChoosingClassScheduleCell.self, forCellReuseIdentifier: CourseChoosingCellReuseId[1]!)
        register(CourseChoosingClassPeriodCell.self, forCellReuseIdentifier: CourseChoosingCellReuseId[2]!)
        register(CourseChoosingTimeScheduleCell.self, forCellReuseIdentifier: CourseChoosingCellReuseId[3]!)
        register(CourseChoosingOtherServiceCell.self, forCellReuseIdentifier: CourseChoosingCellReuseId[4]!)
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
        return CourseChoosingCellReuseId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: CourseChoosingCellReuseId[indexPath.section]!, for: indexPath)
        reuseCell.selectionStyle = .none
        (reuseCell as! MalaBaseCell).title = CourseChoosingCellTitle[indexPath.section+1]
        
        switch indexPath.section {
        case 0:
            let cell = reuseCell as! CourseChoosingGradeCell
            cell.prices = MalaCurrentCourse.grades ?? []
            return cell
            
        case 1:
            let cell = reuseCell as! CourseChoosingClassScheduleCell
            cell.classScheduleModel = self.classScheduleModel
            return cell
            
        case 2:
            let cell = reuseCell as! CourseChoosingClassPeriodCell
            // 更新已选择课时数
            cell.updateSetpValue()
            return cell
            
        case 3:
            let cell = reuseCell as! CourseChoosingTimeScheduleCell
            cell.isOpen = self.isOpenTimeScheduleCell
            cell.timeSchedules = self.timeScheduleResult
            return cell
            
        case 4:
            let cell = reuseCell as! CourseChoosingOtherServiceCell
            cell.price = MalaCurrentCourse.getOriginalPrice()
            return cell
            
        default:
            break
        }
        
        return reuseCell
    }
    
    
    deinit {
        println("choosing TableView deinit")
        ///  清空选课模型
        MalaCurrentCourse.reset()
    }
}
