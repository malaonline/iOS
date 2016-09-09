//
//  CourseChoosingViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class CourseChoosingViewController: BaseViewController, CourseChoosingConfirmViewDelegate {

    // MARK: - Property
    /// 教师id
    var teacherId: Int? {
        didSet {
            guard let _ = teacherId else {
                return
            }
            
            let operationTeacher = NSBlockOperation(block: loadTeacherDetail)
            let operationSchool = NSBlockOperation(block: loadSchoolsData)
            let operationTimeSlots = NSBlockOperation(block: loadClassSchedule)
            let operationEvaluatedStatus = NSBlockOperation(block: loadUserEvaluatedStatus)
            
            operationTimeSlots.addDependency(operationTeacher)
            operationTimeSlots.addDependency(operationSchool)
            
            operationQueue.addOperation(operationTeacher)
            operationQueue.addOperation(operationSchool)
            operationQueue.addOperation(operationTimeSlots)
            operationQueue.addOperation(operationEvaluatedStatus)
        }
    }
    /// 教师详情数据模型
    var teacherModel: TeacherDetailModel? {
        didSet {
            
            if teacherModel?.id != self.teacherId {
                self.teacherId = teacherModel?.id
            }
            
            /// 再次购买时，设置订单数据模型
            if let model = teacherModel {
                MalaOrderOverView.avatarURL = model.avatar
                MalaOrderOverView.teacherName = model.name
                MalaOrderOverView.subjectName = model.subject
                MalaOrderOverView.teacher = model.id
            }
            
            self.tableView.teacherModel = teacherModel
        }
    }
    /// 上课地点数据模型
    var schoolArray: [SchoolModel] = [] {
        didSet {
            MalaCourseChoosingObject.school = schoolArray[0]
            self.tableView.schoolModel = schoolArray
        }
    }
    /// 课程表数据模型
    var classScheduleModel: [[ClassScheduleDayModel]] = [] {
        didSet {
            self.tableView.classScheduleModel = classScheduleModel
        }
    }
    /// 上课地点Cell打开标识
    var isOpenSchoolsCell: Bool = false
    /// 是否需要重新获取上课时间表标识
    var isNeedReloadTimeSchedule: Bool = false
    /// 当前上课地点记录下标
    var selectedSchoolIndexPath: NSIndexPath  = NSIndexPath(forRow: 0, inSection: 0)
    /// 观察者对象数组
    var observers: [AnyObject] = []
    /// 必要数据加载完成计数
    private var requiredCount: Int = 0 {
        didSet {
            // [老师模型][上课地点][老师可用时间表][奖学金][是否首次购买]5个必要数据加载完成才激活界面
            if requiredCount == 5 {
                ThemeHUD.hideActivityIndicator()
            }
        }
    }
    /// 队列
    private var operationQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        return queue
    }()
    
    // MARK: - Compontents
    private lazy var tableView: CourseChoosingTableView = {
        let tableView = CourseChoosingTableView(frame: CGRectZero, style: .Grouped)
        return tableView
    }()
    private lazy var confirmView: CourseChoosingConfirmView = {
        let confirmView = CourseChoosingConfirmView()
        return confirmView
    }()
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeHUD.showActivityIndicator()
        
        MalaCurrentInitAction = { [weak self] in
            self?.loadClassSchedule()
            self?.loadCoupons()
            self?.loadUserEvaluatedStatus()
        }
        
        MalaCurrentCancelAction = { [weak self] in
            self?.popSelf()
        } 
        
        setupUserInterface()
        setupNotification()
        
        operationQueue.addOperationWithBlock(loadCoupons)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        makeStatusBarBlack()
        sendScreenTrack(SACourseChoosingViewName)
        navigationController?.navigationBar.shadowImage = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        makeStatusBarBlack()
        self.title = MalaCommonString_CourseChoosing
        
        // SubViews
        view.addSubview(confirmView)
        view.addSubview(tableView)
        
        confirmView.delegate = self
        
        // Autolayout
        confirmView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(47)
        }
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.bottom.equalTo(confirmView.snp_top)
        }
    }
    
    private func loadTeacherDetail() {
        
        guard let id = self.teacherId else {
            return
        }
        
        loadTeacherDetailData(id, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseChoosingViewController - loadTeacherDetail Error \(errorMessage)")
            }
        }, completion: { [weak self] (model) in
            ThemeHUD.hideActivityIndicator()
            self?.teacherModel = model
            self?.requiredCount += 1
        })
    }
    
    private func loadSchoolsData() {
        
        getSchools(teacherId, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseChoosingViewController - loadSchoolsData Error \(errorMessage)")
            }
        }, completion: { [weak self] (schools) in
            if schools.count > 0 {
                MalaCourseChoosingObject.school = schools[0]
                self?.schoolArray = schools
                self?.loadClassSchedule()
                self?.requiredCount += 1
            }
        })
    }
    
    private func loadClassSchedule() {
        
        let teacherID = teacherModel?.id ?? teacherId ?? 0
        let schoolID = MalaCourseChoosingObject.school?.id ?? 1
        
        getTeacherAvailableTimeInSchool(teacherID, schoolID: schoolID, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseChoosingViewController - getTeacherAvailableTimeInSchool Error \(errorMessage)")
            }
        },completion: { [weak self] (timeSchedule) -> Void in
            self?.classScheduleModel = timeSchedule
            self?.requiredCount += 1
        })
    }
    
    private func loadCoupons() {
        ///  获取优惠券信息
        getCouponList(true, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseChoosingViewController - loadCoupons Error \(errorMessage)")
            }
        }, completion: { [weak self] (coupons) -> Void in
            MalaUserCoupons = coupons
            self?.requiredCount += 1
        })
    }
    
    private func loadUserEvaluatedStatus() {
        /// 若测评建档结果存在，则不发送请求
        if let _ = MalaIsHasBeenEvaluatedThisSubject {
            return
        }
        
        println("*** \(teacherModel?.subject)")
        
        ///  判断用户是否首次购买此学科课程
        isHasBeenEvaluatedWithSubject(MalaConfig.malaSubjectName()[(teacherModel?.subject) ?? ""] ?? 0, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseChoosingViewController - loadUserEvaluatedStatus Error \(errorMessage)")
            }
        }, completion: { [weak self] (bool) -> Void in
            println("用户是否首次购买此学科课程？ \(bool)")
            MalaIsHasBeenEvaluatedThisSubject = bool
            self?.requiredCount += 1
        })
    }
    
    private func setupNotification() {
        // 授课年级选择
        let observerChoosingGrade = NSNotificationCenter.defaultCenter().addObserverForName(
            MalaNotification_ChoosingGrade,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                let price = notification.object as! GradePriceModel
                self?.calculateCoupon()
                // 保存用户所选课程
                if price != MalaCourseChoosingObject.gradePrice {
                    MalaCourseChoosingObject.gradePrice = price
                    
                }
        }
        self.observers.append(observerChoosingGrade)
        
        // 选择上课地点
        let observerChoosingSchool = NSNotificationCenter.defaultCenter().addObserverForName(
            MalaNotification_ChoosingSchool,
            object: nil,
            queue: nil
            ) { [weak self] (notification) -> Void in
                let school = notification.object as! schoolChoosingObject

                self?.tableView.isOpenSchoolsCell = school.isOpenCell
                
                if school.isOpenCell {
                    // 设置所有上课地点数据，设置选中样式
                    self?.tableView.selectedIndexPath = self?.selectedSchoolIndexPath
                    self?.tableView.schoolModel = self?.schoolArray ?? []
                }else if school.schoolModel != nil {
                    
                    // 当户用选择不同的上课地点时，更新课程表视图,清空所有选课条件
                    if school.schoolModel?.id != MalaCourseChoosingObject.school?.id {
                        
                        // 保存用户所选上课地点
                        MalaCourseChoosingObject.school = school.schoolModel
                        
                        self?.loadClassSchedule()
                        MalaCourseChoosingObject.refresh()
                        (self?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3)) as? CourseChoosingClassPeriodCell)?.updateSetpValue()
                    }
                    
                    // 设置tableView 的数据源和选中项
                    self?.tableView.schoolModel = [school.schoolModel!]
                    self?.selectedSchoolIndexPath = school.selectedIndexPath!
                }
        }
        self.observers.append(observerChoosingSchool)
        
        // 选择上课时间
        let observerClassScheduleDidTap = NSNotificationCenter.defaultCenter().addObserverForName(
            MalaNotification_ClassScheduleDidTap,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                let model = notification.object as! ClassScheduleDayModel
               
                // 判断上课时间是否已经选择
                if let index = MalaCourseChoosingObject.selectedTime.indexOf(model) {
                    // 如果上课时间已经选择，从课程购买模型中移除
                    MalaCourseChoosingObject.selectedTime.removeAtIndex(index)
                }else {
                    // 如果上课时间尚未选择，加入课程购买模型
                    MalaCourseChoosingObject.selectedTime.append(model)
                }
                
                // 若当前没有选中上课时间，清空上课时间表并收起，课时数重置为2
                if MalaCourseChoosingObject.selectedTime.count == 0 {
                    self?.tableView.timeScheduleResult = []
                    self?.tableView.isOpenTimeScheduleCell = false
                    MalaCourseChoosingObject.classPeriod = 2
                }
                
                // 若[所选上课时间]多于当前课时，则改变课时，并刷新课时选择Cell
                let selectedTimePeriod = MalaCourseChoosingObject.selectedTime.count*2
                if selectedTimePeriod > MalaCourseChoosingObject.classPeriod {
                    MalaCourseChoosingObject.classPeriod = selectedTimePeriod
                }
                
                // 课时选择
                (self?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3)) as? CourseChoosingClassPeriodCell)?.updateSetpValue()
                self?.calculateCoupon()
                
                // 上课时间
                if MalaCourseChoosingObject.selectedTime.count != 0 {
                     let array = ThemeDate.dateArray((MalaCourseChoosingObject.selectedTime), period: Int(MalaCourseChoosingObject.classPeriod))
                     self?.tableView.timeScheduleResult = array
                }else {
                    self?.tableView.timeScheduleResult = []
                }
        }
        self.observers.append(observerClassScheduleDidTap)
        
        // 选择课时
        let observerClassPeriodDidChange = NSNotificationCenter.defaultCenter().addObserverForName(
            MalaNotification_ClassPeriodDidChange,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                let period = (notification.object as? Double) ?? 2
                // 保存选择课时数
                MalaCourseChoosingObject.classPeriod = Int(period == 0 ? 2 : period)
                self?.calculateCoupon()
                
                // 上课时间
                if MalaCourseChoosingObject.selectedTime.count != 0 {
                     let array = ThemeDate.dateArray(MalaCourseChoosingObject.selectedTime, period: Int(MalaCourseChoosingObject.classPeriod))
                     self?.tableView.timeScheduleResult = array
                }
        }
        self.observers.append(observerClassPeriodDidChange)
        
        // 展开/收起 上课时间表
        let observerOpenTimeScheduleCell = NSNotificationCenter.defaultCenter().addObserverForName(
            MalaNotification_OpenTimeScheduleCell,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                
                guard let _ = self?.teacherModel?.id where MalaCourseChoosingObject.classPeriod != 0 else {
                    return
                }
                
                guard let bool = notification.object as? Bool else {
                    return
                }
                
                // 若选课或课时已改变则请求上课时间表，并展开cell
                if let isOpen = self?.tableView.isOpenTimeScheduleCell where isOpen != bool && bool {
                    // 请求上课时间表，并展开cell
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if bool && self?.isNeedReloadTimeSchedule == true {
                            let array = ThemeDate.dateArray(MalaCourseChoosingObject.selectedTime, period: Int(MalaCourseChoosingObject.classPeriod))
                            self?.tableView.timeScheduleResult = array
                            self?.isNeedReloadTimeSchedule = false
                        }
                        self?.tableView.isOpenTimeScheduleCell = true
                    })
                }else {
                    self?.tableView.isOpenTimeScheduleCell = false
                }
        }
        self.observers.append(observerOpenTimeScheduleCell)
    }
    
    
    ///  计算最优奖学金使用方案
    private func calculateCoupon() {
        println("计算最优奖学金使用方案")
        
        var currentCoupon = CouponModel()
        var currentDis    = 0
        let currentPrice  = MalaCourseChoosingObject.getPrice()
        
        ///  遍历用户当前奖学金
        for coupon in MalaUserCoupons {            
            let couponDis = currentPrice - coupon.minPrice
            if currentPrice >= coupon.minPrice && (currentDis > couponDis || currentDis == 0) {
                currentDis = couponDis
                currentCoupon = coupon
            }
        }
        println("Price - \(currentPrice) - \(MalaUserCoupons.count)")
        println("最优奖学金 - \(currentCoupon)")
        MalaCourseChoosingObject.coupon = currentCoupon
    }
    
    ///  加载订单预览页面
    private func launchOrderOverViewController() {
        let viewController = OrderFormInfoViewController()
        viewController.isForConfirm = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - Delegate
    func OrderDidconfirm() {
        
        // 条件校验, 设置订单模型
        // 选择授课年级
        guard let gradeCourseID = MalaCourseChoosingObject.gradePrice?.grade?.id else {
            ShowTost("请选择授课年级！")
            return
        }
        // 选择上课地点
        guard let schoolID = MalaCourseChoosingObject.school?.id else {
            ShowTost("请选择上课地点！")
            return
        }
        // 选择上课时间
        guard MalaCourseChoosingObject.selectedTime.count != 0 else {
            ShowTost("请选择上课时间！")
            return
        }
        // 课时数应不小于已选上课时间（此情况文案暂时自定，通常情况此Toast不会触发）
        guard MalaCourseChoosingObject.classPeriod >= MalaCourseChoosingObject.selectedTime.count*2 else {
            ShowTost("课时数不得少于已选上课时间！")
            return
        }
        
        
        MalaOrderObject.teacher = (teacherModel?.id) ?? 0
        MalaOrderObject.grade = gradeCourseID
        MalaOrderObject.school  = schoolID
        MalaOrderObject.subject = MalaConfig.malaSubjectName()[(teacherModel?.subject) ?? ""] ?? 0
        MalaOrderObject.coupon = MalaCourseChoosingObject.coupon?.id ?? 0
        MalaOrderObject.hours = MalaCourseChoosingObject.classPeriod
        MalaOrderObject.weekly_time_slots = MalaCourseChoosingObject.selectedTime.map{ (model) -> Int in
            return model.id
        }
        
        // 确认订单
        launchOrderOverViewController()
    }
    
    
    deinit {
        println("choosing Controller deinit")
        
        // 还原选课模型
        MalaIsHasBeenEvaluatedThisSubject = nil
        
        // 移除观察者
        for observer in observers {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
            self.observers.removeAtIndex(0)
        }
    }
}