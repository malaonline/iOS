//
//  Common.swift
//  mala-ios
//
//  Created by Elors on 15/12/17.
//  Copyright © 2015年 Mala Online. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Identifier
#if USE_PRD_SERVER
    let Mala_JPush_AppKey: String = "f22a395a332b87ef57a04b82"
#else
    let Mala_JPush_AppKey: String = "9cf14ffd31f5bbb703c203df"
#endif
let MalaShareSDKAppId = "16bea88583370"
let MalaWeChatAppId = "wxa990fb9607155c1e"


// MARK: - Variables
/// 课时选择步增数
var MalaClassPeriod_StepValue: Double = 2
var MalaIsPaymentIn: Bool = false
var MalaIsForeground: Bool = true
/// 用户未支付订单数
var MalaUnpaidOrderCount: Int = 0
/// 用户待评价课程数
var MalaToCommentCount: Int = 0
/// 登陆后获取用户所在地理位置信息
var MalaLoginLocation: CLLocation? = nil
/// 当前加载闭包（用于请求失败或403时重试）
var MalaCurrentInitAction: (()->())?
/// 取消加载闭包（用于请求失败或403时返回）
var MalaCurrentCancelAction: (()->())?


// MARK: - NotificationName
let MalaNotification_PushPhotoBrowser = NSNotification.Name(rawValue: "com.malalaoshi.app.PushPhotoBrowser")
let MalaNotification_PopFilterView = NSNotification.Name(rawValue: "com.malalaoshi.app.PopFilterView")
let MalaNotification_ConfirmFilterView = NSNotification.Name(rawValue: "com.malalaoshi.app.ConfirmFilterView")
let MalaNotification_CommitCondition = NSNotification.Name(rawValue: "com.malalaoshi.app.CommitCondition")
let MalaNotification_ChoosingGrade = NSNotification.Name(rawValue: "com.malalaoshi.app.ChoosingGrade")
let MalaNotification_ChoosingSchool = NSNotification.Name(rawValue: "com.malalaoshi.app.ChoosingSchool")
let MalaNotification_ClassScheduleDidTap = NSNotification.Name(rawValue: "com.malalaoshi.app.ClassScheduleDidTap")
let MalaNotification_ClassPeriodDidChange = NSNotification.Name(rawValue: "com.malalaoshi.app.ClassPeriodDidChange")
let MalaNotification_OpenTimeScheduleCell = NSNotification.Name(rawValue: "com.malalaoshi.app.OpenTimeScheduleCell")
let MalaNotification_PushTeacherDetailView = NSNotification.Name(rawValue: "com.malalaoshi.app.PushTeacherDetailView")
let MalaNotification_CancelOrderForm = NSNotification.Name(rawValue: "com.malalaoshi.app.CancelOrderForm")
let MalaNotification_PushToPayment = NSNotification.Name(rawValue: "com.malalaoshi.app.PushToPayment")
let MalaNotification_PushIntroduction = NSNotification.Name(rawValue: "com.malalaoshi.app.PushIntroduction")
let MalaNotification_RefreshStudentName = NSNotification.Name(rawValue: "com.malalaoshi.app.RefreshStudentName")
let MalaNotification_PushProfileItemController = NSNotification.Name(rawValue: "com.malalaoshi.app.PushProfileItemController")
let MalaNotification_ReloadLearningReport = NSNotification.Name(rawValue: "com.malalaoshi.app.ReloadLearningReport")
let MalaNotification_LoadTeachers = NSNotification.Name(rawValue: "com.malalaoshi.app.LoadTeachers")
let MalaNotification_MakePhoneCall = NSNotification.Name(rawValue: "com.malalaoshi.app.MakePhoneCall")


// MARK: - Screen Name For Analytics
let SAfindTeacherName = "找老师(iOS)"
let SATeacherDetailName = "老师详情(iOS)"
let SACourseChoosingViewName = "课程购买(iOS)"
let SAOrderViewName = "订单预览(iOS)"
let SAOrderInfoViewName = "订单详情(iOS)"
let SAPaymentViewName = "支付页面(iOS)"
let SAMyCourseViewName = "我的课表(iOS)"
let SAStudyReportViewName = "学习报告(iOS)"
let SAProfileViewName = "个人页(iOS)"
let SAMyOrdersViewName = "我的订单(iOS)"
let SAMyCommentsViewName = "我的评价(iOS)"


// MARK: - Error Detail
let MalaErrorDetail_InvalidPage = "Invalid page"


// MARK: - Common layout
let MalaLayout_CardCellWidth: CGFloat = MalaScreenWidth - (12*2)
let MalaLayout_GradeSelectionWidth: CGFloat = (MalaLayout_CardCellWidth - 12)/2
let MalaLayout_AvatarSize: CGFloat = 75.0
let MalaLayout_VipIconSize: CGFloat = 15.0
let MalaLayout_DetailHeaderContentHeight: CGFloat = 150.0
let MalaLayout_DeatilHighScoreTableViewCellHeight: CGFloat = 33.0
let MalaLayout_DetailPhotoWidth: CGFloat = 85
let MalaLayout_DetailPriceTableViewCellHeight: CGFloat = 71.0
let MalaLayout_DetailSchoolsTableViewCellHeight: CGFloat = 107.0
let MalaLayout_DetailBottomViewHeight: CGFloat = 49.0
let MalaLayout_FilterWindowWidth: CGFloat = MalaScreenWidth*0.85
let MalaLayout_FilterWindowHeight: CGFloat = MalaLayout_FilterWindowWidth
let MalaLayout_FilterContentWidth: CGFloat = MalaLayout_FilterWindowWidth - 26*2
let MalaLayout_FilterItemWidth: CGFloat = MalaLayout_FilterContentWidth/2
let MalaLayout_FilterBarHeight: CGFloat = 40
let MalaLayout_OtherServiceCellHeight: CGFloat = 46
let MalaLayout_ProfileHeaderViewHeight: CGFloat = 190
let MalaLayout_ProfileModifyViewHeight: CGFloat = 48
let MalaLayout_CoursePopupWindowWidth: CGFloat = 272
let MalaLayout_CoursePopupWindowHeight: CGFloat = 300
let MalaLayout_CoursePopupWindowTitleViewHeight: CGFloat = 69
let MalaLayout_CourseContentWidth: CGFloat = MalaLayout_CoursePopupWindowWidth - 26*2
let MalaLayout_CommentPopupWindowHeight: CGFloat = 420
let MalaLayout_CommentPopupWindowWidth: CGFloat = 300
let MalaLayout_CouponRulesPopupWindowHeight: CGFloat = 500
let MalaLayout_FeatureViewWidth: CGFloat = 320
let MalaLayout_FeatureViewHeight: CGFloat = 415
let MalaLayout_LiveCourseCardWidth: CGFloat = MalaScreenWidth - 48 // (12+12)*2


// MARK: - Device
let MalaScreenNaviHeight: CGFloat = 64.0
let MalaScreenWidth = UIScreen.main.bounds.size.width
let MalaScreenHeight = UIScreen.main.bounds.size.height
let MalaScreenOnePixel = 1/UIScreen.main.scale
let MalaScreenScale = UIScreen.main.scale


// MARK: - Array
var MalaOtherService = [
    OtherServiceModel(title: L10n.coupon, type: .coupon, price: 0, priceHandleType: .none, viewController: CouponViewController.self),
    OtherServiceModel(title: L10n.evaluation, type: .evaluationFiling, price: 500, priceHandleType: .reduce, viewController: EvaluationFilingServiceController.self)
]
