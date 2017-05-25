//
//  MalaSupport.swift
//  mala-ios
//
//  Created by 王新宇 on 2/25/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import Foundation
import DateToolsSwift
import Kingfisher
import Google

// MARK: - Task
typealias CancelableTask = (_ cancel: Bool) -> Void

///  延迟执行任务
///
///  - parameter time: 延迟秒数(s)
///  - parameter work: 任务闭包
///
///  - returns: 任务对象闭包
@discardableResult
func delay(_ time: TimeInterval, work: @escaping ()->()) -> CancelableTask? {
    
    var finalTask: CancelableTask?
    
    let cancelableTask: CancelableTask = { cancel in
        if cancel {
            finalTask = nil // key
            
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
    
    finalTask = cancelableTask
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        if let task = finalTask {
            task(false)
        }
    }
    
    return finalTask
}

func cancel(_ cancelableTask: CancelableTask?) {
    cancelableTask?(true)
}


// MARK: - unregister

///  注销推送消息
func unregisterThirdPartyPush() {
    (DispatchQueue.main).async {
        JPUSHService.setAlias(nil, callbackSelector: nil, object: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

///  清空缓存
func cleanCaches() {
    KingfisherManager.shared.cache.clearDiskCache()
    KingfisherManager.shared.cache.clearMemoryCache()
    KingfisherManager.shared.cache.cleanExpiredDiskCache()
}


// MARK: - Common TextAttribute
public func commonTextStyle() -> [String: AnyObject]? {
    let AttributeDictionary = NSMutableDictionary()
    AttributeDictionary[NSForegroundColorAttributeName] = UIColor(named: .ArticleSubTitle)
    return AttributeDictionary.copy() as? [String : AnyObject]
}


// MARK: - Method
public func makeStatusBarBlack() {
    UIApplication.shared.statusBarStyle = .lightContent // .default
}

public func makeStatusBarWhite() {
    UIApplication.shared.statusBarStyle = .lightContent
}

public func MalaRandomColor() -> UIColor {
    return MalaConfig.malaTagColors()[randomInRange(Range(uncheckedBounds: (lower: 0, upper: MalaConfig.malaTagColors().count-1)))]
}

///  根据Date获取星期数
///
///  - parameter date: Date对象
///
///  - returns: 星期数（0~6, 对应星期日~星期六）
public func weekdayInt(_ date: Date) -> Int {
    let calendar = Calendar.current
    let components: DateComponents = calendar.dateComponents([.weekday], from: date)
    return components.weekday!-1
}

///  解析学生上课时间表
///
///  - returns: [我的课表]页面课表数据
func parseStudentCourseTable(_ courseTable: [StudentCourseModel]) -> (model: [[[StudentCourseModel]]], recently: IndexPath) {
    
    let courseList = [StudentCourseModel](courseTable.reversed())
    var datas = [[[StudentCourseModel]]]()
    var currentMonthsIndex: Int = 0
    var currentDaysIndex: Int = 0
    
    /// 距今天最近的上课时间位于[课表数据]的下标
    var indexPath: (section: Int, row: Int) = (0, 0)
    var recentCourse: StudentCourseModel?
    var nowTime: Int = 0
    let nowTimeInterval = Date().timeIntervalSince1970
    
    ///  若该课程为最近课程，则将当前下标添加到indexPath中
    ///
    ///  - parameter course: 课程模型
    func validate(course: StudentCourseModel) {
        if course === recentCourse {
            indexPath = (currentMonthsIndex, currentDaysIndex)
        }
    }
    
    for (index, course) in courseList.enumerated() {
        
        /// 该课程与当前时间的秒数差值
        let time = Int(course.end - nowTimeInterval)
        /// 时间差存在且，当前时间差为零 或 当前时间差小于时间差
        if time > 0 && (nowTime == 0 || time < nowTime) {
            nowTime = time
            recentCourse = course
        }
        
        let courseYearAndMonth = String(course.date.year)+String(course.date.month)
        let courseDay = course.date.day
        
        if index > 0 {
            
            let previousCourse = courseList[index-1]
            
            if courseYearAndMonth == String(previousCourse.date.year)+String(previousCourse.date.month) {
                
                if courseDay == previousCourse.date.day {
                    // 同年同月同日
                    datas[currentMonthsIndex][currentDaysIndex].append(course)
                    validate(course: course)
                }else {
                    // 同年同月
                    datas[currentMonthsIndex].append([course])
                    currentDaysIndex += 1
                    validate(course: course)
                }
            }else {
                // 非同年同月
                datas.append([[course]])
                currentMonthsIndex += 1
                currentDaysIndex = 0
                validate(course: course)
            }
        }else {
            // 均不同
            datas.append([[course]])
            currentMonthsIndex = 0
            currentDaysIndex = 0
            validate(course: course)
        }
    }
    
    ///  若所有课程中无最近未上课程，则选定最后一节课程
    if nowTime == 0 && datas.count > 0 && datas[0].count > 0 {
        let section = datas.count-1
        let row = datas[section].count-1
        indexPath = (section, row)
    }
    return (datas, IndexPath(row: indexPath.row, section: indexPath.section))
}

///  根据时间戳获取时间字符串（例如12:00）
///
///  - parameter timeStamp: 时间戳
///
///  - returns: 时间字符串
func getTimeString(_ timeStamp: TimeInterval, format: String = "HH:mm") -> String {
    return Date(timeIntervalSince1970: timeStamp).format(with: format)!
}

///  根据时间戳获取时间字符串（例如2000/10/10）
///
///  - parameter timeStamp: 时间戳
///
///  - returns: 时间字符串
func getDateString(_ timeStamp: TimeInterval? = nil, date: Date? = nil, format: String = "yyyy/MM/dd") -> String {
    if timeStamp != nil {
        return Date(timeIntervalSince1970: timeStamp!).format(with: format)!
    }else if date != nil {
        return date!.format(with: format)!
    }else {
        return Date().format(with: format)!
    }
}

///  根据时间戳获取时间字符串（例如2000/10/10 12:01:01）
///
///  - parameter timeStamp: 时间戳
///
///  - returns: 时间字符串
func getDateTimeString(_ timeStamp: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
    return Date(timeIntervalSince1970: timeStamp).format(with: format)!
}


///  获取行距为8的文本
///
///  - parameter string: 文字
///
///  - returns: 文本样式
func getLineSpacingAttrString(_ string: String, lineSpace: CGFloat) -> NSAttributedString {
    let attrString = NSMutableAttributedString(string: string)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpace
    attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: string.characters.count))
    return attrString
}

///  获取当前ViewController
///
///  - returns: UIViewController
func getActivityViewController() -> UIViewController? {
    
    var activityViewController: UIViewController? = nil
    var keyWindow = UIApplication.shared.keyWindow
    
    if keyWindow?.windowLevel != UIWindowLevelNormal {
        let windows = UIApplication.shared.windows
        for window in windows {
            if window.windowLevel == UIWindowLevelNormal {
                keyWindow = window
                break
            }
        }
    }
    
    let viewsArray = keyWindow?.subviews
    
    if (viewsArray?.count)! > 0 {
        
        let frontView = viewsArray![0]
        let nextResponder = frontView.next
        
        if nextResponder is UIViewController {
            activityViewController = nextResponder as? UIViewController
        }else {
            activityViewController = keyWindow!.rootViewController
        }
    }
    
    // 过滤TabbarController情况
    if let mainViewController = activityViewController as? MainViewController,
        let naviVC = mainViewController.viewControllers?[mainViewController.selectedIndex] as? UINavigationController {
        activityViewController = naviVC.viewControllers[0]
    }
    
    return activityViewController
}

///  根据一组成对的时间戳生成上课时间表
///
///  - parameter timeIntervals: 一组成对的时间戳（分别代表上课和结束的时间）
///
///  - returns: 文本样式
func getTimeSchedule(_ timeStamps: [[TimeInterval]]) -> [String] {
    
    var timeSchedule: [String] = []
    
    for timeStamp in timeStamps {
        
        let startDate = timeStamp[0]
        let endDate = timeStamp[1]
        
        let string = String(format: "%@ (%@-%@)", getDateString(startDate), getTimeString(startDate), getTimeString(endDate))
        timeSchedule.append(string)
    }
    
    return timeSchedule
}

///  获取日期对应星期字符串
///
///  - parameter timeStamp: 时间戳
///  - parameter date:      日期对象
///
///  - returns: 星期字符串
func getWeekString(_ timeStamp: TimeInterval? = nil, date: Date? = nil) -> String {
    
    var weekInt = 0
    
    if let timeStamp = timeStamp {
        weekInt = Date(timeIntervalSince1970: timeStamp).weekday
    }else if let date = date {
        weekInt = date.weekday
    }
    weekInt -= 1
    return MalaConfig.malaWeekdays()[weekInt]
}

///  解析学生上课时间表
///
///  - parameter timeSchedule: 上课时间表数据
///
///  - returns:
///  dates:     日期字符串
///  times:     上课时间字符串
///  height:    所需高度
func parseTimeSlots(_ timeSchedule: [[TimeInterval]]) -> (dates: [String], times: [String], height: CGFloat) {
    
    var dateStrings = [String]()
    var timeStrings = [String]()
    var height: CGFloat = 0
    var list: [TimeScheduleModel] = []
    let sortTimeSlots = timeSchedule.sorted { (timeIntervals1, timeIntervals2) -> Bool in
        return (timeIntervals1.first ?? 0) < (timeIntervals2.first ?? 0)
    }
    
    for singleTime in sortTimeSlots {
        
        let currentStartDate = Date(timeIntervalSince1970: singleTime[0])
        let currentEndDate = Date(timeIntervalSince1970: singleTime[1])
        
        var appendedDate: TimeScheduleModel?
        
        // 判断此日期是否已存在于数组中
        for dateResult in list {
            if currentStartDate.isSameDay(date: dateResult.date as Date!) {
                appendedDate = dateResult
                break
            }
        }
        
        if appendedDate != nil {
            // 若当前日期已存在于数组，添加上课时间数据到对应日期中
            appendedDate!.times.append([currentStartDate, currentEndDate])
        }else {
            // 若日期不存在于数组，添加日期和上课时间数据
            let result = TimeScheduleModel()
            result.date = currentStartDate
            result.times.append([currentStartDate, currentEndDate])
            list.append(result)
        }
        
    }
    
    // 解析日期数据为字符串
    for slotDate in list {
        
        // 日期字符串
        dateStrings.append(getDateString(date: slotDate.date, format: "M月d日") + "\n" + MalaConfig.malaWeekdays()[weekdayInt(slotDate.date)])

        // 上课时间字符串
        var timeString = ""
        for (index, slot) in slotDate.times.enumerated() {
            timeString += index%2 == 1 ? "    " : "\n"
            timeString = index == 0 ? "" : timeString
            timeString += getDateString(date: slot[0], format: "HH:mm") + "-" + getDateString(date: slot[1], format: "HH:mm")
        }
        timeStrings.append(timeString)
        
        // 垂直高度
        let count = slotDate.times.count
        
        switch count {
        case 1...2: height += (17+20+12)
        case 3...4: height += (33.5+20)
        case 5:     height += (50.5+20)
        default:    height += 0
        }
    }
    height -= 20
    return (dateStrings, timeStrings, height)
}

///  解析奖学金列表数据
///  将当前不符合使用条件的奖学金设置冻结属性，同时进行排序 (排序条件为: [可用情况][减免金额][过期时间])
///
///  - parameter coupons: 奖学金列表数据
///
///  - returns: 奖学金列表数据
func parseCouponlist(_ coupons: [CouponModel]) -> [CouponModel] {
    
    var result = coupons
    // 当前用户选课价格
    let currentPrice = MalaCurrentCourse.getOriginalPrice()
    
    for coupon in result {
        
        // 冻结尚未满足要求的奖学金
        if coupon.minPrice > currentPrice {
            coupon.status = .disabled
        }
  
    }
    
    result.sort { (coupon1, coupon2) -> Bool in
        if coupon2.status == .disabled {
            return true
        }else {
            return false
        }
    }
    
    return result
}

///  根据距离进行学校排序
///
///  - parameter schools: 学校模型列表
///
///  - returns: 学校模型列表
func sortSchoolsByDistance(_ schools: [SchoolModel]) -> [SchoolModel] {
    return schools.sorted { (school1, school2) -> Bool in
        return school1.distance < school2.distance
    }
}


// MARK: - Study Report Support
func adjustHomeworkData(_ data: [SingleHomeworkData]) -> [SingleHomeworkData] {
    
    /// 排序
    var sortData = data.sorted { (data1, data2) -> Bool in
        return data1.rate.doubleValue > data2.rate.doubleValue
    }
    var allRate: Double = 0
    
    /// 将多于8项的数据合并为第九项“其它”
    while sortData.count > 8 {
        if let lastReport = sortData.last {
            allRate += lastReport.rate.doubleValue
            sortData.removeLast()
        }
    }

    sortData.append(SingleHomeworkData(id: 999, name: L10n.other, rate: NSNumber(value: allRate)))
    return sortData
}

func adjustTopicData(_ data: [SingleTopicData]) -> [SingleTopicData] {
    /// 排序
    var sortData = data.sorted { (data1, data2) -> Bool in
        return data1.rightRate > data2.rightRate
    }
    var totalItem: Int = 0
    var rightItem: Int = 0
    
    /// 将多于8项的数据合并为第九项“其它”
    while sortData.count > 8 {
        if let lastReport = sortData.last {
            totalItem += lastReport.total_item
            rightItem += lastReport.right_item
            sortData.removeLast()
        }
    }
    sortData.append(SingleTopicData(id: "9999", name: L10n.other, totalItem: totalItem, rightItem: rightItem))
    return sortData
}
func adjustTopicScoreData(_ data: [SingleTopicScoreData]) -> [SingleTopicScoreData] {
    /// 排序
    var sortData = data.sorted { (data1, data2) -> Bool in
        return data1.my_score.doubleValue > data2.my_score.doubleValue
    }
    var myScore: Double = 0
    var aveScore: Double = 0
    
    /// 将多于8项的数据合并为第九项“其它”
    while sortData.count > 8 {
        if let lastReport = sortData.last {
            myScore += lastReport.my_score.doubleValue
            aveScore += lastReport.ave_score.doubleValue
            sortData.removeLast()
        }
    }
    
    sortData.append(SingleTopicScoreData(id: "9999", name: L10n.other, score: NSNumber(value: myScore), aveScore: NSNumber(value: aveScore)))
    return sortData
}

///  发送屏幕浏览信息（用于GoogleAnalytics屏幕浏览量数据分析）
///
///  - parameter value: 屏幕名称
func sendScreenTrack(_ value: String? = "其它页面") {
     #if USE_PRD_SERVER
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: value)
        if let dict = (GAIDictionaryBuilder.createScreenView().build() as NSDictionary!) as? [AnyHashable : Any]? {
            tracker?.send(dict)
        }
     #endif
}


func makeAddressAttrString(_ schoolName: String?, _ schoolAddress: String?) -> NSMutableAttributedString {
    
    let string = (schoolName ?? "") + "\n" + (schoolAddress ?? "")
    let attrString: NSMutableAttributedString = NSMutableAttributedString(string: string)
    let location = (string as NSString).range(of: "\n").location
    let length = string.characters.count
    let leftLength = length - location
    
    attrString.addAttribute(
        NSForegroundColorAttributeName,
        value: UIColor(named: .ArticleText),
        range: NSMakeRange(0, location)
    )
    attrString.addAttribute(
        NSFontAttributeName,
        value: UIFont.systemFont(ofSize: 14),
        range: NSMakeRange(0, location)
    )
    attrString.addAttribute(
        NSForegroundColorAttributeName,
        value: UIColor(named: .HeaderTitle),
        range: NSMakeRange(location, leftLength)
    )
    attrString.addAttribute(
        NSFontAttributeName,
        value: UIFont.systemFont(ofSize: 12),
        range: NSMakeRange(location, leftLength)
    )
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6
    attrString.addAttribute(
        NSParagraphStyleAttributeName,
        value: paragraphStyle,
        range: NSMakeRange(0, length)
    )
    return attrString
}

func makeTeacherAttrString(_ LecturerName: String?, _ assistantName: String?) -> NSMutableAttributedString {
    
    let string = String(format: "%@ (助教%@)", (LecturerName ?? ""), (assistantName ?? ""))
    let attrString: NSMutableAttributedString = NSMutableAttributedString(string: string)
    let location = (string as NSString).range(of: "(").location
    let length = string.characters.count
    let leftLength = length - location
    
    attrString.addAttribute(
        NSForegroundColorAttributeName,
        value: UIColor(named: .ArticleText),
        range: NSMakeRange(0, location)
    )
    attrString.addAttribute(
        NSFontAttributeName,
        value: UIFont.systemFont(ofSize: 13),
        range: NSMakeRange(0, location)
    )
    attrString.addAttribute(
        NSForegroundColorAttributeName,
        value: UIColor(named: .HeaderTitle),
        range: NSMakeRange(location, leftLength)
    )
    attrString.addAttribute(
        NSFontAttributeName,
        value: UIFont.systemFont(ofSize: 13),
        range: NSMakeRange(location, leftLength)
    )
    return attrString
}

func setIfNeed(_ str: inout String?, bak: String) {
    str = (str == nil ? bak : str)
}

func getSubjectRecord(subject: MASubjectId) -> Int? {
    if subject == .math {
        return MalaExerciseRecordMath
    }else if subject == .english {
        return MalaExerciseRecordEnglish
    }else {
        return nil
    }
}
