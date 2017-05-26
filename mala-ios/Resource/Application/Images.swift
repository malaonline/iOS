//
//  Images.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/2/10.
//  Copyright © 2017年 Mala Online. All rights reserved.
//
// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    typealias Image = UIImage
#elseif os(OSX)
    import AppKit.NSImage
    typealias Image = NSImage
#endif

enum ImageAsset: String {
    case sppsTest = "SPPSTest"
    case sppsTestDetail = "SPPSTest_detail"
    case stayTuned = "StayTuned"
    case stayTunedDetail = "StayTuned_detail"
    case aboutTextBackground = "aboutText_Background"
    case alertCourseBeenSeized = "alert_CourseBeenSeized"
    case alertPaymentDuplicated = "alert_Payment Duplicated"
    case alertPaymentFail = "alert_PaymentFail"
    case alertPaymentSuccess = "alert_PaymentSuccess"
    case alertPaymentSuccessFirstTime = "alert_PaymentSuccess_firstTime"
    case alertPosition = "alert_Position"
    case alipayIcon = "alipay_icon"
    case answerNumber = "answerNumber"
    case avatarLayer = "avatarLayer"
    case avatarPlaceholder = "avatar_placeholder"
    case blackArrow = "black_arrow"
    case buttonBlueNormal = "button_blue_normal"
    case buttonBluePress = "button_blue_press"
    case buttonLoading = "button_loading"
    case buttonRedNormal = "button_red_normal"
    case buttonRedPress = "button_red_press"
    case callBg = "call_bg"
    case clearNormal = "clear_normal"
    case clearPress = "clear_press"
    case close = "close"
    case closeNormal = "close_normal"
    case closePress = "close_press"
    case closeWhite = "close_white"
    case collectNoData = "collect_noData"
    case commentExpired = "comment_expired"
    case commentLocation = "comment_location"
    case commentNoData = "comment_noData"
    case commentSubject = "comment_subject"
    case commentTeacherDisable = "comment_teacher_disable"
    case commentTeacherNormal = "comment_teacher_normal"
    case commentTime = "comment_time"
    case commented = "commented"
    case confirmNormal = "confirm_normal"
    case confirmPress = "confirm_press"
    case correctRate = "correctRate"
    case correctedNotebook = "correctedNotebook"
    case correctedNotebookDetail = "correctedNotebook_detail"
    case counseling = "counseling"
    case counselingDetail = "counseling_detail"
    case couponExpired = "coupon_expired"
    case couponSelected = "coupon_selected"
    case couponUnvalid = "coupon_unvalid"
    case couponUsed = "coupon_used"
    case couponValid = "coupon_valid"
    case courseIndicatorsNormal = "course indicators_normal"
    case courseIndicatorsSelected = "course indicators_selected"
    case courseHeader = "course_header"
    case descIcon = "desc_icon"
    case detailPicturePlaceholder = "detailPicture_placeholder"
    case detailClass1 = "detail_class1"
    case detailClass2 = "detail_class2"
    case detailClass3 = "detail_class3"
    case dotLegend = "dot_legend"
    case dropArrow = "dropArrow"
    case editIcon = "edit_icon"
    case editIconPress = "edit_icon_press"
    case error = "error"
    case examOutlineLecture = "examOutlineLecture"
    case examOutlineLectureDetail = "examOutlineLecture_detail"
    case featureComment = "feature_comment"
    case featureInfo = "feature_info"
    case featureNotify = "feature_notify"
    case featuredLectures = "featuredLectures"
    case featuredLecturesDetail = "featuredLectures_detail"
    case filterNoResult = "filter_no_result"
    case filterNormal = "filter_normal"
    case filterPress = "filter_press"
    case folderIcon = "folder_icon"
    case genderFemale = "gender_female"
    case genderMale = "gender_male"
    case goTop = "goTop"
    case gotopNormal = "gotop_normal"
    case gotopPress = "gotop_press"
    case grade = "grade"
    case grayBackground = "grayBackground"
    case heart = "heart"
    case helpBell = "help_bell"
    case helpLive = "help_live"
    case helpNote = "help_note"
    case histogramLegend = "histogram_legend"
    case hot = "hot"
    case imageIcon = "image_icon"
    case juniorHigh = "juniorHigh"
    case labelLeftSeparator = "label_leftSeparator"
    case labelRightSeparator = "label_rightSeparator"
    case learningReport = "learningReport"
    case learningReportDetail = "learningReport_detail"
    case leftArrow = "leftArrow"
    case leftArrowBlack = "leftArrow_black"
    case leftArrowNormal = "leftArrow_normal"
    case leftArrowPress = "leftArrow_press"
    case leftArrowWhite = "leftArrow_white"
    case legendActive = "legend_active"
    case legendBought = "legend_bought"
    case legendDisabled = "legend_disabled"
    case legendSelected = "legend_selected"
    case levelIcon = "level_icon"
    case likeIcon = "like_icon"
    case liveAvatarBackground = "live_avatarBackground"
    case liveBanner = "live_banner"
    case liveCheckin = "live_checkin"
    case liveClass = "live_class"
    case liveCourseIcon = "live_courseIcon"
    case liveIcon = "live_icon"
    case liveLecturer = "live_lecturer"
    case liveLocation = "live_location"
    case livePhone = "live_phone"
    case liveSchedule = "live_schedule"
    case liveStudents = "live_students"
    case liveTeacher = "live_teacher"
    case liveTime = "live_time"
    case liveTimes = "live_times"
    case loadingImgBlue78x78 = "loading_imgBlue_78x78"
    case locationNormal = "location_normal"
    case locationPress = "location_press"
    case loginFill = "login_fill"
    case loginLogo = "login_logo"
    case loginNormal = "login_normal"
    case loginPress = "login_press"
    case minus = "minus"
    case networkError = "network_error"
    case noCoupons = "no_coupons"
    case noExercise = "no_exercise"
    case noOrder = "no_order"
    case noteButtonNormal = "noteButton_normal"
    case noteButtonPress = "noteButton_press"
    case nomoreContent = "nomoreContent"
    case noteDisable = "note_disable"
    case noteNormal = "note_normal"
    case orderFormBackground = "orderForm_background"
    case orderSchool = "order_school"
    case orderSubject = "order_subject"
    case orderTeacher = "order_teacher"
    case phone = "phone"
    case pictureLoadFail = "picture_load_fail"
    case pinIcon = "pin_icon"
    case plus = "plus"
    case primarySchool = "primarySchool"
    case profileAvatarPlaceholder = "profileAvatar_placeholder"
    case profileAvatarBackground = "profile_avatarBackground"
    case profileCollect = "profile_collect"
    case profileComment = "profile_comment"
    case profileHeaderBackground = "profile_headerBackground"
    case profileLogin = "profile_login"
    case profileNormal = "profile_normal"
    case profileOrder = "profile_order"
    case profileUncomment = "profile_uncomment"
    case profileUnpaid = "profile_unpaid"
    case pullArrow = "pullArrow"
    case qcpayIcon = "qcpay_icon"
    case radioButtonNormal = "radioButton_normal"
    case radioButtonSelected = "radioButton_selected"
    case radioButtonTap = "radioButton_tap"
    case refreshImage = "refreshImage"
    case reportTitleBackground = "reportTitle_background"
    case reportTitleIcon = "reportTitle_icon"
    case reportDisable = "report_disable"
    case reportNormal = "report_normal"
    case rightArrow = "rightArrow"
    case scheduleNormal = "schedule_normal"
    case searchNormal = "search_normal"
    case selected = "selected"
    case selfStudy = "selfStudy"
    case selfStudyDetail = "selfStudy_detail"
    case seniorHigh = "seniorHigh"
    case serivceNormal = "serivce_normal"
    case shareNormal = "share_normal"
    case sharePress = "share_press"
    case snsIconWechatSession = "sns_icon_wechat_session"
    case snsIconWechatTimeline = "sns_icon_wechat_timeline"
    case starEmpty = "starEmpty"
    case starFull = "starFull"
    case style = "style"
    case subject = "subject"
    case subjectBackground = "subject_background"
    case subjectEnglish = "subject_english"
    case subjectMath = "subject_math"
    case tagsTitle = "tagsTitle"
    case tagsIcon = "tags_icon"
    case teacherDetailHeaderPlaceholder = "teacherDetailHeader_placeholder"
    case teachingAgeIcon = "teachingAge_icon"
    case timeSlotBought = "timeSlot_bought"
    case timePoint = "time_point"
    case timeTop = "time_top"
    case titleLeftLine = "titleLeftLine"
    case titleRightLine = "titleRightLine"
    case uncomment = "uncomment"
    case unselected = "unselected"
    case upArrow = "upArrow"
    case verifyCode = "verifyCode"
    case vipLayer = "vipLayer"
    case vipIcon = "vip_icon"
    case wechatIcon = "wechat_icon"
    
    // custom
    case none = ""
    case refreshGif2x = "refreshImage@2x.gif"
    case refreshGif3x = "refreshImage@3x.gif"
    
    var image: Image {
        return Image(asset: self)
    }
}


extension Image {
    convenience init!(asset: ImageAsset) {
        self.init(named: asset.rawValue)
    }
}
