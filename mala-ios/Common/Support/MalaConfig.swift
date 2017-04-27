//
//  MalaConfig.swift
//  mala-ios
//
//  Created by 王新宇 on 2/24/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

open class MalaConfig {
    
    static let appGroupID: String = "group.malalaoshi.parent"
    
    ///  短信倒计时时间
    class func callMeInSeconds() -> Int {
        return 60
    }
    ///  支付方式数
    class func paymentChannelAmount() -> Int {
        return malaPaymentChannels().count
    }
    ///  头像最大大小
    class func avatarMaxSize() -> CGSize {
        return CGSize(width: 414, height: 414)
    }
    ///  头像压缩质量
    class func avatarCompressionQuality() -> CGFloat {
        return 0.7
    }
    ///  头像大小
    class func editProfileAvatarSize() -> CGFloat {
        return 100
    }
    /// 课表单节课程 - 视图高度
    class func singleCourseCellHeight() -> CGFloat {
        return 145.5
    }
    /// 广告信息URL
    class func adURL() -> String {
        #if USE_PRD_SERVER
            return "https://www.malalaoshi.com/m/ad"
        #elseif USE_STAGE_SERVER
            return "https://stage.malalaoshi.com/m/ad"
        #else
            return "http://dev.malalaoshi.com/m/ad"
        #endif
    }
    /// App图标名称
    class func appIcon() -> String {
        #if USE_PRD_SERVER
            return "AppIcon60x60"
        #elseif USE_STAGE_SERVER
            return "AppIcon-stage60x60"
        #else
            return "AppIcon-dev60x60"
        #endif
    }
    ///  app版本号
    class func aboutAPPVersion() -> String {
        let version = String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)
        let buildVersion = String(describing: Bundle.main.infoDictionary!["CFBundleVersion"]!)
        return String(format: "Version %@ (%@)", version, buildVersion)
    }
    ///  版权信息
    class func aboutCopyRightString() -> String {
        return "COPYRIGHT © 2014 - \(Date().year)\n北京麻辣在线网络科技有限公司版权所有"
    }
    ///  关于我们描述HTMLString
    class func aboutDescriptionHTMLString() -> String {
        return "        麻辣老师(MALALAOSHI.COM)成立于2015年6月，由众多资深教育人士和互联网顶尖人才组成，是专注于国内二三四线城市中小学K12课外辅导的O2O服务平台，以效果、费用、便捷为切入口，实现个性化教学和学生的个性发展，推动二三四线城市及偏远地区教育进步。\n\n        麻辣老师通过O2O的方式，以高效和精准的老师推荐，让中小学家长更加方便和经济地找到好老师，提升老师的收入，优化教、学、练、测、评五大环节, 提升教学与学习效率、创新服务模式，带给家长、老师及学生全新的学习体验。"
    }
    ///  奖学金使用规则String
    class func couponRulesDescriptionString() -> String {
        return "一.奖学金券是什么\n1.奖学金券是由麻辣老师发行，使用户在麻辣老师购买课程的过程中，作为抵扣现金的一种虚拟券。\n\n二.使用规则\n1.不同的奖学金券面值、有效期和使用限制不尽相同，使用前请认真核对。\n2.一个订单只能使用一张奖学金券。\n3.奖学金券作为一种优惠手段，无法获得对应的积分。\n4.一个订单中的奖学金券部分不能退款或折现，使用奖学金券购买的订单发生退款后不能返还奖学金券。\n5.如取消订单，订单中所使用的奖学金券可再次使用。\n6.奖学金券面值大于订单金额，差额不予退回；如奖学金券面值小于订单金额，需由用户支付差额；奖学金券不可兑现，且不开发票。\n\n三.特别提示\n1.用户应当出于合法、正当目的，以合理方式使用奖学金券。\n2.麻辣老师将不定期的通过版本更新的方式修改使用规则，请您及时升级为最新版本。\n3.如果用户对使用规则存在任何疑问或需要任何帮助，请及时与麻辣老师客服联系。联系电话：010-57733349\n4.最终解释权归北京麻辣在线网络科技有限公司所有。"
    }
    ///  已买课程说明String
    class func boughtDescriptionString() -> String {
        return "您在该时间段有课程未上完，直到您在该时间段课程全部结束后的12小时，我们都为您保留老师时间，方便您继续购买。"
    }
    
    
    // MARK: - Static Data
    /// [学科id: 学科名称]
    class func malaSubject() -> [Int: String] {
        return [
            1: "数  学",
            2: "英  语",
            3: "语  文",
            4: "物  理",
            5: "化  学",
            6: "地  理",
            7: "历  史",
            8: "政  治",
            9: "生  物"
        ]
    }
    /// [学科名称: 学科id]
    class func malaSubjectName() -> [String: Int] {
        return [
            "数学": 1,
            "英语": 2,
            "语文": 3,
            "物理": 4,
            "化学": 5,
            "地理": 6,
            "历史": 7,
            "政治": 8,
            "生物": 9
        ]
    }
    /// [年级简称: 年级内部id]
    class func malaGradeShortName() -> [String: Int] {
        return [
            "一年级": 0,
            "二年级": 1,
            "三年级": 2,
            "四年级": 3,
            "五年级": 4,
            "六年级": 5,
            "初一": 0,
            "初二": 1,
            "初三": 2,
            "高一": 0,
            "高二": 1,
            "高三": 2,
        ]
    }
    /// [年级id: 年级全称]
    class func malaGradeName() -> [Int: String] {
        return [
            2: "小学一年级",
            3: "小学二年级",
            4: "小学三年级",
            5: "小学四年级",
            6: "小学五年级",
            7: "小学六年级",
            9: "初中一年级",
            10:"初中二年级",
            11:"初中三年级",
            13:"高中一年级",
            14:"高中二年级",
            15:"高中三年级",
        ]
    }
    /// 星期名称对应数组
    class func malaWeekdays() -> [String] {
        return [
            "周日",
            "周一",
            "周二",
            "周三",
            "周四",
            "周五",
            "周六"
        ]
    }
    /// 老师风格标签颜色数组
    class func malaTagColors() -> [UIColor] {
        return [
            UIColor(rgbHexValue: 0x8FBCDD, alpha: 1.0),
            UIColor(rgbHexValue: 0xF6A466, alpha: 1.0),
            UIColor(rgbHexValue: 0x9BC3E1, alpha: 1.0),
            UIColor(rgbHexValue: 0xAC7BD8, alpha: 1.0),
            UIColor(rgbHexValue: 0xA5B2E4, alpha: 1.0),
            UIColor(rgbHexValue: 0xF4BB5B, alpha: 1.0),
            UIColor(rgbHexValue: 0xA4C87F, alpha: 1.0),
            UIColor(rgbHexValue: 0xEDADD0, alpha: 1.0),
            UIColor(rgbHexValue: 0xABCB71, alpha: 1.0),
            UIColor(rgbHexValue: 0x67CFC8, alpha: 1.0),
            UIColor(rgbHexValue: 0xF58F8F, alpha: 1.0),
            UIColor(rgbHexValue: 0x9BC3E1, alpha: 1.0),
            UIColor(rgbHexValue: 0xE5BEED, alpha: 1.0)
        ]
    }
    /// 支付渠道对象列表
    class func malaPaymentChannels() -> [PaymentChannel] {
        return [
            PaymentChannel(imageName: "alipay_icon", title: L10n.alipay, subTitle: L10n.alipaySecurityPayment, channel: .Alipay),
            PaymentChannel(imageName: "wechat_icon", title: L10n.weChatPayment, subTitle: L10n.weChatShortcutPayment, channel: .Wechat),
            PaymentChannel(imageName: "qcpay_icon", title: L10n.payByParents, subTitle: L10n.payByQRCode, channel: .QRPay)
        ]
    }
    
    
    // MARK: - Static Config
    ///  [个人中心]静态结构数据
    class func profileData() -> [[ProfileElementModel]] {        
        return [
            [
                ProfileElementModel(
                    id: 0,
                    controller: FavoriteViewController.self,
                    controllerTitle: L10n.myCollect,
                    type: nil,
                    iconName: "profile_collect",
                    newMessageIconName: "",
                    disabled: true,
                    disabledMessage: L10n.comingSoon
                ),
                ProfileElementModel(
                    id: 1,
                    controller: OrderFormViewController.self,
                    controllerTitle: L10n.myOrder,
                    type: nil,
                    iconName: "profile_order",
                    newMessageIconName: "profile_unpaid"
                ),
                ProfileElementModel(
                    id: 2,
                    controller: CommentViewController.self,
                    controllerTitle: L10n.myComment,
                    type: nil,
                    iconName: "profile_comment",
                    newMessageIconName: "profile_uncomment"
                )
            ],
            [
                ProfileElementModel(
                    id: 3,
                    title: L10n.myCoupon,
                    detail: "",
                    controller: CouponViewController.self,
                    controllerTitle: L10n.myCoupon,
                    type: nil
                )
            ],
            [
                ProfileElementModel(
                    id: 4,
                    title: L10n.aboutMala,
                    detail: "",
                    controller: AboutViewController.self,
                    controllerTitle: L10n.aboutMala,
                    type: nil
                )
            ]
        ]
    }

    
    class func memberServiceData() -> [IntroductionModel] {
        return [
            IntroductionModel(
                title: L10n.tutor,
                image: .selfStudy,
                subTitle: L10n.tutorDesc
            ),
            IntroductionModel(
                title: L10n.report,
                image: .learningReport,
                subTitle: L10n.reportDesc
            ),
            IntroductionModel(
                title: L10n.counseling,
                image: .counseling,
                subTitle: L10n.counselingDesc
            ),
            IntroductionModel(
                title: L10n.lectures,
                image: .featuredLectures,
                subTitle: L10n.lecturesDesc
            ),
            IntroductionModel(
                title: L10n.examOutline,
                image: .examOutlineLecture,
                subTitle: L10n.examOutlineDesc
            ),
            IntroductionModel(
                title: L10n.correctedRecord,
                image: .correctedNotebook,
                subTitle: L10n.correctedRecordDesc
            ),
            IntroductionModel(
                title: L10n.sppsTest,
                image: .sppsTest,
                subTitle: L10n.sppsTestDesc
            ),
            IntroductionModel(
                title: L10n.comingSoon,
                image: .stayTuned,
                subTitle: ""
            )
        ]
    }
    
    class func featureViewData() -> [IntroductionModel] {
        return [
            IntroductionModel(
                title: "要上的课在这里",
                image: .featureInfo,
                subTitle: "购课后 时间地点一目了然"
            ),
            IntroductionModel(
                title: "温馨提醒上课通知",
                image: .featureNotify,
                subTitle: "不会错过上课的日子 暖暖的很贴心"
            ),
            IntroductionModel(
                title: "课程评价看得见",
                image: .featureComment,
                subTitle: "上完课过来发表一下感受吧"
            )
        ]
    }
    
    class func chartsColor() -> [UIColor] {
        return [
            UIColor(named: .ChartYellow),
            UIColor(named: .ChartCyan),
            UIColor(named: .ChartRed),
            UIColor(named: .ChartGreen),
            UIColor(named: .ChartBlue),
            UIColor(named: .ChartGrayBlue),
            UIColor(named: .ChartOrange),
            UIColor(named: .ChartPurple),
            UIColor(named: .ChartGrayRed),
        ]
    }
    
    class func homeworkDataChartsTitle() -> [String] {
        return [
            L10n.Chart.realNumber,
            L10n.Chart.function,
            L10n.Chart.polygon,
            L10n.Chart.circle,
            L10n.Chart.congruent,
            L10n.Chart.similar,
            L10n.Chart.Geo.transfor,
            L10n.Chart.Geo.operation,
            L10n.other
        ]
    }
    
    ///  ［作业数据分析页面］样本数据
    class func homeworkSampleData() -> [SingleHomeworkData] {
        return [
            SingleHomeworkData(id: 1, name: L10n.Chart.realNumber, rate: NSNumber(value: 0.15 as Double)),
            SingleHomeworkData(id: 2, name: L10n.Chart.function, rate: NSNumber(value: 0.20 as Double)),
            SingleHomeworkData(id: 3, name: L10n.Chart.polygon, rate: NSNumber(value: 0.13 as Double)),
            SingleHomeworkData(id: 4, name: L10n.Chart.circle, rate: NSNumber(value: 0.06 as Double)),
            SingleHomeworkData(id: 5, name: L10n.Chart.congruent, rate: NSNumber(value: 0.2 as Double)),
            SingleHomeworkData(id: 6, name: L10n.Chart.similar, rate: NSNumber(value: 0.06 as Double)),
            SingleHomeworkData(id: 7, name: L10n.Chart.Geo.transfor, rate: NSNumber(value: 0.12 as Double)),
            SingleHomeworkData(id: 8, name: L10n.Chart.Geo.operation, rate: NSNumber(value: 0.08 as Double))
        ]
    }
    
    ///  ［题目数据分析页面］样本数据
    class func topicSampleData() -> [SingleTimeIntervalData] {
        return [
            SingleTimeIntervalData(totalItem: 175, errorItem: 77, year: 2016, month: 4, day: 16),
            SingleTimeIntervalData(totalItem: 185, errorItem: 63, year: 2016, month: 5, day: 1),
            SingleTimeIntervalData(totalItem: 192, errorItem: 46, year: 2016, month: 5, day: 16),
            SingleTimeIntervalData(totalItem: 225, errorItem: 43, year: 2016, month: 6, day: 1)

        ]
    }
    
    ///  ［知识点分析页面］样本数据
    class func knowledgeSampleData() -> [SingleTopicData] {
        return [
            SingleTopicData(id: "1", name: L10n.Chart.realNumber, totalItem: 100, rightItem: 49),
            SingleTopicData(id: "2", name: L10n.Chart.function, totalItem: 90, rightItem: 20),
            SingleTopicData(id: "3", name: L10n.Chart.circle, totalItem: 100, rightItem: 80),
            SingleTopicData(id: "4", name: L10n.Chart.polygon, totalItem: 105, rightItem: 60),
            SingleTopicData(id: "5", name: L10n.Chart.congruent, totalItem: 100, rightItem: 30),
            SingleTopicData(id: "6", name: L10n.Chart.similar, totalItem: 125, rightItem: 95),
            SingleTopicData(id: "7", name: L10n.Chart.Geo.transfor, totalItem: 80, rightItem: 40),
            SingleTopicData(id: "8", name: L10n.Chart.Geo.operation, totalItem: 70, rightItem: 40),
        ]
    }
    
    ///  ［知识点分析页面］默认数据
    class func knowledgeDefaultData() -> [SingleTopicData] {
        return [
            SingleTopicData(id: "1", name: L10n.Chart.realNumber, totalItem: 100, rightItem: 0),
            SingleTopicData(id: "2", name: L10n.Chart.function, totalItem: 100, rightItem: 0),
            SingleTopicData(id: "3", name: L10n.Chart.circle, totalItem: 100, rightItem: 0),
            SingleTopicData(id: "4", name: L10n.Chart.polygon, totalItem: 100, rightItem: 0),
            SingleTopicData(id: "5", name: L10n.Chart.congruent, totalItem: 100, rightItem: 0),
            SingleTopicData(id: "6", name: L10n.Chart.similar, totalItem: 100, rightItem: 0),
            SingleTopicData(id: "7", name: L10n.Chart.Geo.transfor, totalItem: 100, rightItem: 0),
            SingleTopicData(id: "8", name: L10n.Chart.Geo.operation, totalItem: 100, rightItem: 0),
        ]
    }
    
    ///  ［能力结构分析页面］样本数据
    class func abilitySampleData() -> [SingleAbilityData] {
        return [
            SingleAbilityData(key: "reason", value: 60),
            SingleAbilityData(key: "data", value: 30),
            SingleAbilityData(key: "spatial", value: 42),
            SingleAbilityData(key: "calc", value: 33),
            SingleAbilityData(key: "appl", value: 82),
            SingleAbilityData(key: "abstract", value: 66)
        ]
    }
    
    ///  ［提分点分析页面］样本数据
    class func scoreSampleData() -> [SingleTopicScoreData] {
        return [
            SingleTopicScoreData(id: "1", name: L10n.Chart.realNumber, score: NSNumber(value: 0.47 as Double), aveScore: NSNumber(value: 0.72 as Double)),
            SingleTopicScoreData(id: "2", name: L10n.Chart.function, score: NSNumber(value: 0.23 as Double), aveScore: NSNumber(value: 0.64 as Double)),
            SingleTopicScoreData(id: "3", name: L10n.Chart.circle, score: NSNumber(value: 0.80 as Double), aveScore: NSNumber(value: 0.70 as Double)),
            SingleTopicScoreData(id: "4", name: L10n.Chart.polygon, score: NSNumber(value: 0.56 as Double), aveScore: NSNumber(value: 0.59 as Double)),
            SingleTopicScoreData(id: "5", name: L10n.Chart.congruent, score: NSNumber(value: 0.27 as Double), aveScore: NSNumber(value: 0.51 as Double)),
            SingleTopicScoreData(id: "6", name: L10n.Chart.similar, score: NSNumber(value: 0.77 as Double), aveScore: NSNumber(value: 0.62 as Double)),
            SingleTopicScoreData(id: "7", name: L10n.Chart.Geo.transfor, score: NSNumber(value: 0.50 as Double), aveScore: NSNumber(value: 0.77 as Double)),
            SingleTopicScoreData(id: "8", name: L10n.Chart.Geo.operation, score: NSNumber(value: 0.55 as Double), aveScore: NSNumber(value: 0.21 as Double))
        ]
    }
}
