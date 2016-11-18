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
            
            let operationTeacher = BlockOperation(block: loadTeacherDetail)
            let operationTimeSlots = BlockOperation(block: loadClassSchedule)
            let operationEvaluatedStatus = BlockOperation(block: loadUserEvaluatedStatus)
            let operationLoadGradePrices = BlockOperation(block: loadGradePrices)
            
            operationTimeSlots.addDependency(operationTeacher)
            operationEvaluatedStatus.addDependency(operationTeacher)
            
            operationQueue.addOperation(operationTeacher)
            operationQueue.addOperation(operationTimeSlots)
            operationQueue.addOperation(operationEvaluatedStatus)
            operationQueue.addOperation(operationLoadGradePrices)
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
    /// 学校（仅再次购买时存在）
    var school: SchoolModel? {
        didSet {
            // 再次购买时设置已进行测评建档
            MalaIsHasBeenEvaluatedThisSubject = false
            requiredCount += 1
        }
    }
    /// 课程表数据模型
    var classScheduleModel: [[ClassScheduleDayModel]] = [] {
        didSet {
            self.tableView.classScheduleModel = classScheduleModel
        }
    }
    /// 是否需要重新获取上课时间表标识
    var isNeedReloadTimeSchedule: Bool = false
    /// 当前上课地点记录下标
    var selectedSchoolIndexPath: IndexPath  = IndexPath(row: 0, section: 0)
    /// 观察者对象数组
    var observers: [AnyObject] = []
    /// 必要数据加载完成计数
    private var requiredCount: Int = 0 {
        didSet {
            // [老师模型][价格阶梯表][老师可用时间表][奖学金][是否首次购买]5个必要数据加载完成才激活界面
            if requiredCount == 5 {
                ThemeHUD.hideActivityIndicator()
            }
        }
    }
    /// 队列
    private var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()
    
    
    // MARK: - Compontents
    private lazy var tableView: CourseChoosingTableView = {
        let tableView = CourseChoosingTableView(frame: CGRect.zero, style: .grouped)
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
        
        operationQueue.addOperation(loadCoupons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        title = MalaCommonString_CourseChoosing
        
        // SubViews
        view.addSubview(confirmView)
        view.addSubview(tableView)
        
        confirmView.delegate = self
        
        // Autolayout
        confirmView.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(47)
        }
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(confirmView.snp.top)
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
            self?.teacherModel = model
            self?.requiredCount += 1
        })
    }
    
    private func loadGradePrices() {
        guard let teacherID = self.teacherId else {
            println("Prices teacher id null")
            return
        }
        
        guard let schoolId = self.school != nil ? self.school?.id : MalaCurrentSchool?.id else {
            println("Prices school id null")
            return
        }
        
        getTeacherGradePrice(teacherID, schoolId: schoolId, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseChoosingViewController - getTeacherGradePrice Error \(errorMessage)")
            }
        },completion: { [weak self] (grades) -> Void in
            MalaCurrentCourse.grades = grades
            // 获取到价格阶梯数据后，自动切换到指定年级
            MalaCurrentCourse.switchGradePrices()
            self?.refreshTableView()
            self?.requiredCount += 1
        })
    }
    
    private func loadClassSchedule() {
        
        guard let teacherID = self.teacherId else {
            println("TimeSlots teacher id null")
            return
        }
        
        guard let schoolId = self.school != nil ? self.school?.id : MalaCurrentSchool?.id else {
            println("TimeSlots school id null")
            return
        }
        
        getTeacherAvailableTimeInSchool(teacherID, schoolId: schoolId, failureHandler: { (reason, errorMessage) -> Void in
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
        guard MalaIsHasBeenEvaluatedThisSubject == nil else {
            return
        }
        guard let subjectId = MalaConfig.malaSubjectName()[(teacherModel?.subject) ?? ""] else {
            return
        }
        
        ///  判断用户是否首次购买此学科课程
        isHasBeenEvaluatedWithSubject(subjectId, failureHandler: { (reason, errorMessage) -> Void in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CourseChoosingViewController - loadUserEvaluatedStatus Error \(errorMessage)")
            }
        }, completion: { [weak self] (bool) -> Void in
            MalaIsHasBeenEvaluatedThisSubject = bool
            self?.requiredCount += 1
        })
    }
    
    private func setupNotification() {
        // 授课年级选择
        let observerChoosingGrade = NotificationCenter.default.addObserver(
            forName: MalaNotification_ChoosingGrade,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                guard let grade = notification.object as? GradeModel else {
                    return
                }

                // 保存用户所选课程
                if grade != MalaCurrentCourse.grade {
                    MalaCurrentCourse.grade = grade
                    self?.calculateCoupon()
                }
        }
        self.observers.append(observerChoosingGrade)
        
        // 选择上课时间
        let observerClassScheduleDidTap = NotificationCenter.default.addObserver(
            forName: MalaNotification_ClassScheduleDidTap,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                let model = notification.object as! ClassScheduleDayModel
               
                // 判断上课时间是否已经选择
                if let index = MalaCurrentCourse.selectedTime.index(of: model) {
                    // 如果上课时间已经选择，从课程购买模型中移除
                    MalaCurrentCourse.selectedTime.remove(at: index)
                }else {
                    // 如果上课时间尚未选择，加入课程购买模型
                    MalaCurrentCourse.selectedTime.append(model)
                }
                
                // 若当前没有选中上课时间，清空上课时间表并收起，课时数重置为2
                if MalaCurrentCourse.selectedTime.count == 0 {
                    self?.tableView.timeScheduleResult = []
                    self?.tableView.isOpenTimeScheduleCell = false
                    MalaCurrentCourse.classPeriod = 2
                }
                
                // 若[所选上课时间]多于当前课时，则改变课时，并刷新课时选择Cell
                let selectedTimePeriod = MalaCurrentCourse.selectedTime.count*2
                if selectedTimePeriod > MalaCurrentCourse.classPeriod {
                    MalaCurrentCourse.classPeriod = selectedTimePeriod
                }
                
                // 课时选择
                (self?.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? CourseChoosingClassPeriodCell)?.updateSetpValue()
                self?.calculateCoupon()
                
                // 上课时间
                if MalaCurrentCourse.selectedTime.count != 0 {
                     let array = ThemeDate.dateArray((MalaCurrentCourse.selectedTime), period: Int(MalaCurrentCourse.classPeriod))
                     self?.tableView.timeScheduleResult = array
                }else {
                    self?.tableView.timeScheduleResult = []
                }
        }
        self.observers.append(observerClassScheduleDidTap)
        
        // 选择课时
        let observerClassPeriodDidChange = NotificationCenter.default.addObserver(
            forName: MalaNotification_ClassPeriodDidChange,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                let period = (notification.object as? Double) ?? 2
                // 保存选择课时数
                MalaCurrentCourse.classPeriod = Int(period == 0 ? 2 : period)
                self?.calculateCoupon()
                
                // 上课时间
                if MalaCurrentCourse.selectedTime.count != 0 {
                     let array = ThemeDate.dateArray(MalaCurrentCourse.selectedTime, period: Int(MalaCurrentCourse.classPeriod))
                     self?.tableView.timeScheduleResult = array
                }
        }
        self.observers.append(observerClassPeriodDidChange)
        
        // 展开/收起 上课时间表
        let observerOpenTimeScheduleCell = NotificationCenter.default.addObserver(
            forName: MalaNotification_OpenTimeScheduleCell,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                
                guard let _ = self?.teacherModel?.id, MalaCurrentCourse.classPeriod != 0 else {
                    return
                }
                
                guard let bool = notification.object as? Bool else {
                    return
                }
                
                // 若选课或课时已改变则请求上课时间表，并展开cell
                if let isOpen = self?.tableView.isOpenTimeScheduleCell, isOpen != bool && bool {
                    // 请求上课时间表，并展开cell
                    DispatchQueue.main.async(execute: { () -> Void in
                        if bool && self?.isNeedReloadTimeSchedule == true {
                            let array = ThemeDate.dateArray(MalaCurrentCourse.selectedTime, period: Int(MalaCurrentCourse.classPeriod))
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
        var currentCoupon = CouponModel()
        var currentDis    = 0
        let currentPrice  = MalaCurrentCourse.getOriginalPrice()
        
        ///  遍历用户当前奖学金
        for coupon in MalaUserCoupons {            
            let couponDis = currentPrice - coupon.minPrice
            if currentPrice >= coupon.minPrice && (currentDis > couponDis || currentDis == 0) {
                currentDis = couponDis
                currentCoupon = coupon
            }
        }
        MalaCurrentCourse.coupon = currentCoupon
    }
    
    ///  加载订单预览页面
    private func launchOrderOverViewController() {
        let viewController = OrderFormInfoViewController()
        viewController.isForConfirm = true
        viewController.school = self.school
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func refreshTableView() {
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            self?.tableView.reloadData()
        })
    }
    
    // MARK: - Delegate
    func OrderDidconfirm() {
        
        // 条件校验, 设置订单模型
        // 选择授课年级
        guard let gradeCourseID = MalaCurrentCourse.grade?.id else {
            ShowTost("请选择授课年级！")
            return
        }
        // 选择上课地点
        if let schoolID = self.school?.id {
            MalaOrderObject.school  = schoolID
        }else if let schoolID = MalaCurrentSchool?.id {
            MalaOrderObject.school  = schoolID
        }else {
            ShowTost("请选择上课地点！")
            return
        }
        // 选择上课时间
        guard MalaCurrentCourse.selectedTime.count != 0 else {
            ShowTost("请选择上课时间！")
            return
        }
        // 课时数应不小于已选上课时间（此情况文案暂时自定，通常情况此Toast不会触发）
        guard MalaCurrentCourse.classPeriod >= MalaCurrentCourse.selectedTime.count*2 else {
            ShowTost("课时数不得少于已选上课时间！")
            return
        }
        
        
        MalaOrderObject.teacher = (teacherModel?.id) ?? 0
        MalaOrderObject.grade = gradeCourseID
        MalaOrderObject.subject = MalaConfig.malaSubjectName()[(teacherModel?.subject) ?? ""] ?? 0
        MalaOrderObject.coupon = MalaCurrentCourse.coupon?.id ?? 0
        MalaOrderObject.hours = MalaCurrentCourse.classPeriod
        MalaOrderObject.weeklyTimeSlots = MalaCurrentCourse.selectedTime.map{ (model) -> Int in
            return model.id
        }
        
        // 确认订单
        launchOrderOverViewController()
    }
    
    
    deinit {
        println("choosing Controller deinit")
        ThemeHUD.hideActivityIndicator()
        
        // 还原选课模型
        MalaIsHasBeenEvaluatedThisSubject = nil
        
        // 移除观察者
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
            self.observers.remove(at: 0)
        }
    }
}
