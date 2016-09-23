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
    
    class func testPrices() -> [GradeModel] {
        return [
            GradeModel(id: 2, name: "一年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17000),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16500),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16000),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15000),
            ]),
            GradeModel(id: 3, name: "二年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17000),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16500),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16000),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15000),
                ]),
            GradeModel(id: 4, name: "三年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17000),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16500),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16000),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15000),
                ]),
            GradeModel(id: 5, name: "四年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17000),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16500),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16000),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15000),
                ]),
            GradeModel(id: 6, name: "五年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17000),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16500),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16000),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15000),
                ]),
            GradeModel(id: 7, name: "六年级", price: [
                GradePriceModel(minHours: 1, maxHours: 10, price: 17000),
                GradePriceModel(minHours: 11, maxHours: 20, price: 16500),
                GradePriceModel(minHours: 21, maxHours: 50, price: 16000),
                GradePriceModel(minHours: 51, maxHours: 10, price: 15000),
                ]),
        ]
    }
    
    class func testDateInThisWeek() {
        println(NSDate().weekday())
        println("周一".dateInThisWeek().formattedDateWithFormat("YYYY/MM/dd"))
    }
    
    class func testPingppPayment(charge: JSONDictionary) {
        
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
