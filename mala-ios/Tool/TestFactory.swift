//
//  TestFactory.swift
//  mala-ios
//
//  Created by Elors on 1/12/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class TestFactory {

    // MARK: - Model
    class func tags() -> [String] {
        return [
            "幽默",
            "常识教育",
            "100%进步率",
            "学员过千",
            "押题达人",
            "幽默风趣",
            "心理专家",
            "亲和力强",
            "公立学校老师",
            "最受学生欢迎",
            "80后名师",
            "英语演讲冠军",
            "麻辣金牌教师",
            "权威奥数教练"
        ]
    }
    
    class func testCourseModels() -> [CourseModel] {
        return [
            CourseModel(id: 65, start: 1457942400, end: 1457949600, subject: "物理", school: "洛阳社区三店", is_passed: true, teacher: TeacherModel(), comment: CommentModel(id: 15, timeslot: 65, score: 2, content: "这个老师还行")),
            CourseModel(id: 66, start: 1457789400, end: 1457796600, subject: "物理", school: "洛阳社区三店", is_passed: true, teacher: TeacherModel(), comment: CommentModel(id: 15, timeslot: 65, score: 2, content: "这个老师还行")),
            CourseModel(id: 67, start: 1457797200, end: 1457804400, subject: "物理", school: "洛阳社区三店", is_passed: true, teacher: TeacherModel(), comment: CommentModel(id: 15, timeslot: 65, score: 2, content: "这个老师还行")),
        ]
    }
    
    class func testLiveClass() -> LiveClassModel {
        return LiveClassModel(
            lecturerAvatar: "http://s3.cn-north-1.amazonaws.com.cn/dev-upload/avatars/avatar21_161101?X-Amz-Expires=86400&X-Amz-Signature=517143d11c51518bba37c9f71c4b9f59327daf9c8b9ed9afe183127e14a49412&X-Amz-SignedHeaders=host&X-Amz-Date=20161018T040232Z&X-Amz-Credential=AKIAOSV3WMTYCF7T4LTA/20161018/cn-north-1/s3/aws4_request&X-Amz-Algorithm=AWS4-HMAC-SHA256",
            lecturerName: "刘孟军",
            lecturerTitle: "CCTV日语频道著名主持人",
            assistantAvatar: "http://s3.cn-north-1.amazonaws.com.cn/dev-upload/avatars/avatar22_11290?X-Amz-Expires=86400&X-Amz-Signature=0e082c8967e8d8bac5be78d225ef5a104d5c9069dd0a2d21c2ac928e24ff10d3&X-Amz-SignedHeaders=host&X-Amz-Date=20161018T041156Z&X-Amz-Credential=AKIAOSV3WMTYCF7T4LTA/20161018/cn-north-1/s3/aws4_request&X-Amz-Algorithm=AWS4-HMAC-SHA256",
            assistantName: "王新宇",
            roomCapacity: 20,
            courseName: "标准日本语中高级加强班周六上午班",
            courseStart: 1477101600,
            courseEnd: 1477713600,
            courseGrade: "全年级",
            courseFee: 48000,
            courseLessons: 16,
            coursePeriod: "每周六 10:00-12:00",
            courseDesc: "课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah课程介绍 blah blah",
            studentsCount: 13,
            lecturerBio: "多年海外留学经历\n非常多年海外留学经历\n特别特别多年海外留学经历"
        )
    }
    
    class func testPrices() -> [GradeModel] {
        return [
            GradeModel(id: 2, name: "一年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17001),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16501),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16001),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15001),
            ]),
            GradeModel(id: 3, name: "二年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17002),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16502),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16002),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15002),
                ]),
            GradeModel(id: 4, name: "三年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17003),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16503),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16003),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15003),
                ]),
            GradeModel(id: 5, name: "四年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17004),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16504),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16004),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15004),
                ]),
            GradeModel(id: 6, name: "五年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17005),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16505),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16005),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15005),
                ]),
            GradeModel(id: 7, name: "六年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17006),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16506),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16006),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15006),
                ]),
        ]
    }
    
    class func testPingppPayment(_ charge: JSONDictionary) {
        
        let object = charge as NSDictionary
        
        Pingpp.createPayment(object,
            viewController: UIViewController(),
            appURLScheme: "alipay") { (result, error) -> Void in
                if result == "success" {
                    // 支付成功
                    println("支付成功")
                }else {
                    // 支付失败或取消
                    println("支付失败或取消")
                }
        }
    }
 }
