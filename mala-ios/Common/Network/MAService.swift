//
//  MAService.swift
//  mala-ios
//
//  Created by 王新宇 on 13/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {
    
    /// Get Verification code
    ///
    /// - Parameters:
    ///   - phone:          Phone number
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func sendSMS(phone: String, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.sendSMS(phone: phone), failureHandler: failureHandler, completion: { json in
            let sent = (json["sent"] as? Bool) ?? false
            completion(sent)
        })
    }
    
    /// Verification the SMS code
    ///
    /// - Parameters:
    ///   - phone:          Phone number
    ///   - code:           Verification code
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func verifySMS(phone: String, code: String, failureHandler: failureHandler? = nil, completion: @escaping (LoginUser?) -> Void) -> Cancellable {
        return self.sendRequest(.verifySMS(phone: phone, code: code), failureHandler: failureHandler, completion: { json in
            guard let verified = json["verified"] as? Bool, verified == true else {
                completion(nil)
                return
            }
            
            if let firstLogin = json["first_login"] as? Bool,
               let accessToken = json["token"] as? String,
               let parentID = json["parent_id"] as? Int,
               let userID = json["user_id"] as? Int,
               let profileID = json["profile_id"] as? Int {
                completion(LoginUser(accessToken: accessToken, userID: userID, parentID: parentID, profileID: profileID, firstLogin: firstLogin, avatarURLString: ""))
                return
            }
            completion(nil)
        })
    }
    
    /// Get user profile info
    ///
    /// - Parameters:
    ///   - id:             Profile id of account
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userProfile(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (ProfileInfo?) -> Void) -> Cancellable {
        return self.sendRequest(.profileInfo(id: id), failureHandler: failureHandler, completion: { json in
            guard let _ = json["id"] else {
                completion(nil)
                return
            }
            if let id = json["id"] as? Int,
               let gender = json["gender"] as? String? {
                completion(ProfileInfo(id: id, gender: gender, avatar: (json["avatar"] as? String) ?? ""))
                return
            }
            completion(nil)
        })
    }
    
    /// Get user parent info
    ///
    /// - Parameters:
    ///   - id:             Parent id of account
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userParents(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (ParentInfo?) -> Void) -> Cancellable {
        return self.sendRequest(.parentInfo(id: id), failureHandler: failureHandler, completion: { json in
            guard let _ = json["id"] else {
                completion(nil)
                return
            }
            
            if let id = json["id"] as? Int,
               let studentName = json["student_name"] as? String?,
               let schoolName = json["student_school_name"] as? String? {
                completion(ParentInfo(id: id, studentName: studentName, schoolName: schoolName))
                return
            }
            completion(nil)
        })
    }
    
    /// Upload user avatar
    ///
    /// - Parameters:
    ///   - imageData:      Data of image
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func uploadAvatar(imageData: Data, failureHandler: failureHandler? = nil, completion: @escaping (Bool?) -> Void) -> Cancellable {
        let id = MalaUserDefaults.profileID.value ?? -1
        return self.sendRequest(.uploadAvatar(data: imageData, profileId: id), failureHandler: failureHandler, completion: { json in
            guard let result = json["done"] as? Bool else {
                completion(nil)
                return
            }
            completion(result)
        })
    }
    
    /// Save student name
    ///
    /// - Parameters:
    ///   - name:           Student's name
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func saveStudentName(name: String, failureHandler: failureHandler? = nil, completion: @escaping (Bool?) -> Void) -> Cancellable {
        let id = MalaUserDefaults.parentID.value ?? -1
        return self.sendRequest(.saveStudentName(name: name, parentId: id), failureHandler: failureHandler, completion: { json in
            guard let result = json["done"] as? Bool else {
                completion(nil)
                return
            }
            completion(result)
        })
    }
    
    /// Save student name
    ///
    /// - Parameters:
    ///   - name:           Student's name
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func saveSchoolName(name: String, failureHandler: failureHandler? = nil, completion: @escaping (Bool?) -> Void) -> Cancellable {
        let id = MalaUserDefaults.parentID.value ?? -1
        return self.sendRequest(.saveSchoolName(name: name, parentId: id), failureHandler: failureHandler, completion: { json in
            guard let result = json["done"] as? Bool else {
                completion(nil)
                return
            }
            completion(result)
        })
    }
    
    /// Get user coupons
    ///
    /// - Parameters:
    ///   - onlyValid:      Only return validate coupon
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userCoupons(onlyValid: Bool = false, failureHandler: failureHandler? = nil, completion: @escaping ([CouponModel]) -> Void) -> Cancellable {
        return self.sendRequest(.userCoupons(onlyValid: onlyValid), failureHandler: failureHandler, completion: { json in
            guard let couponsData = json["results"] as? [JSON], couponsData.count != 0 else {
                completion([])
                return
            }
            var coupons = [CouponModel]()
            for couponJSON in couponsData {
                guard let _ = couponJSON["id"] else { break }
                
                if let id = couponJSON["id"] as? Int,
                   let name = couponJSON["name"] as? String,
                   let amount = couponJSON["amount"] as? Int,
                   let expired_at = couponJSON["expired_at"] as? TimeInterval,
                   let minPrice = couponJSON["mini_total_price"] as? Int,
                   let used = couponJSON["used"] as? Bool {
                    let coupon = CouponModel(id: id, name: name, amount: amount, expired_at: expired_at, minPrice: minPrice, used: used)
                    coupon.setupStatus()
                    coupons.append(coupon)
                }
            }
            completion(coupons)
        })
    }
    
    /// Get the evaluation state
    ///
    /// - Parameters:
    ///   - subjectId:      Id of the subject
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func subjectEvaluationStatus(subjectId: Int, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.evaluationStatus(subjectId: subjectId), failureHandler: failureHandler, completion: { json in
            if let result = json["evaluated"] as? Bool {
                completion(!result)
            }
            completion(true)
        })
    }
    
    /// Get the student's schedule of the course
    ///
    /// - Parameters:
    ///   - onlyPassed:     
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getStudentSchedule(onlyPassed: Bool = false, failureHandler: failureHandler? = nil, completion: @escaping ([StudentCourseModel]) -> Void) -> Cancellable {
        return self.sendRequest(.getStudentSchedule(onlyPassed: onlyPassed), failureHandler: failureHandler, completion: { json in

            var schedule: [StudentCourseModel] = []
            guard let courses = json["results"] as? [JSON], courses.count != 0 else {
                completion(schedule)
                return
            }
            for course in courses {
                schedule.append(StudentCourseModel(dict: course))
            }
            completion(schedule)
        })
    }
    
    /// Get user order list
    ///
    /// - Parameters:
    ///   - page:           Page number
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getOrderList(page: Int = 1, failureHandler: failureHandler? = nil, completion: @escaping ([OrderForm], Int) -> Void) -> Cancellable {
        return self.sendRequest(.getOrderList(page: page), failureHandler: failureHandler, completion: { json in
            
            var list: [OrderForm] = []
            
            guard let orders = json["results"] as? [JSON],
                  let count = json["count"] as? Int, count != 0 else {
                    completion(list, 0)
                    return
            }
            
            for order in orders {
                if let _ = order["id"] as? Int {
                    list.append(OrderForm(dict: order))
                }
            }
            completion(list, count)
        })
    }
    
    /// Get user new messages count
    ///
    /// - Parameters:
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userNewMessageCount(failureHandler: failureHandler? = nil, completion: @escaping (UserMessageCenterModel?) -> Void) -> Cancellable {
        return self.sendRequest(.userNewMessageCount(), failureHandler: failureHandler, completion: { json in
            guard let _ = json["unpaid_num"] as? Int,
                  let _ = json["tocomment_num"] as? Int else {
                completion(nil)
                return
            }
            completion(UserMessageCenterModel(dict: json))
        })
    }
    
    /// Get list of teacher that user collected
    ///
    /// - Parameters:
    ///   - page:           Page number
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userCollection(page: Int = 1, failureHandler: failureHandler? = nil, completion: @escaping ([TeacherModel], Int) -> Void) -> Cancellable {
        return self.sendRequest(.userCollection(page: page), failureHandler: failureHandler, completion: { json in
            
            var teachers: [TeacherModel] = []
            var count = 0
            
            if let all = json["count"] as? Int,
               let results = json["results"] as? [JSON], results.count > 0 {
                count = all
                for teacher in results {
                    teachers.append(TeacherModel(dict: teacher))
                }
            }
            completion(teachers, count)
        })
    }
    
    /// Add a new element to user collection
    ///
    /// - Parameters:
    ///   - id:             Teacher id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func addCollection(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.addCollection(id: id), failureHandler: failureHandler, completion: { json in
            completion(true)
        })
    }
    
    /// remove an element from user collection
    ///
    /// - Parameters:
    ///   - id:             Teacher id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func removeCollection(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.removeCollection(id: id), failureHandler: failureHandler, completion: { json in
            completion(true)
        })
    }
    
    /// Get list of all teacher
    ///
    /// - Parameters:
    ///   - condition:      Filter condition
    ///   - page:           Page number
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func loadTeachers(condition: JSON?, page: Int = 1, failureHandler: failureHandler? = nil, completion: @escaping ([TeacherModel], Int) -> Void) -> Cancellable {
        return self.sendRequest(.loadTeachers(condition: condition, page: page), failureHandler: failureHandler, completion: { json in
            
            var list: [TeacherModel] = []
            
            guard let teachers = json["results"] as? [JSON],
                  let count = json["count"] as? Int, count != 0 else {
                    completion(list, 0)
                    return
            }
            
            for teacher in teachers {
                if let _ = teacher["id"] as? Int {
                    list.append(TeacherModel(dict: teacher))
                }
            }
            completion(list, count)
        })
    }
    
    /// Load detail data of the teacher
    ///
    /// - Parameters:
    ///   - id:             Teacher id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func loadTeacherDetail(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (TeacherDetailModel?) -> Void) -> Cancellable {
        return self.sendRequest(.loadTeacherDetail(id: id), failureHandler: failureHandler, completion: { json in
            completion(TeacherDetailModel(dict: json))
        })
    }
    
    /// Get teacher available time at given school
    ///
    /// - Parameters:
    ///   - teacherId:      Teacher id
    ///   - schoolId:       School id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getTeacherAvailableTime(teacherId: Int, atSchool schoolId: Int, failureHandler: failureHandler? = nil, completion: @escaping ([[ClassScheduleDayModel]]) -> Void) -> Cancellable {
        return self.sendRequest(.getTeacherAvailableTime(teacherId: teacherId, schoolId: schoolId), failureHandler: failureHandler, completion: { json in
            
            var weekSchedule: [[ClassScheduleDayModel]] = []
            
            // loop week
            for index in 1...7 {
                if let day = json[String(index)] as? [[String: AnyObject]] {
                    var daySchedule: [ClassScheduleDayModel] = []
                    for dict in day {
                        daySchedule.append(ClassScheduleDayModel(dict: dict))
                    }
                    weekSchedule.append(daySchedule)
                }
            }
            completion(weekSchedule) 
        })
    }
    
    /// Get teacher price of grade at given school
    ///
    /// - Parameters:
    ///   - teacherId:      Teacher id
    ///   - schoolId:       School id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getTeacherGradePrice(teacherId: Int, atSchool schoolId: Int, failureHandler: failureHandler? = nil, completion: @escaping ([GradeModel]) -> Void) -> Cancellable {
        return self.sendRequest(.getTeacherGradePrice(teacherId: teacherId, schoolId: schoolId), failureHandler: failureHandler, completion: { json in
            
            var prices: [GradeModel] = []
            
            if let results = json["results"] as? [JSON], results.count > 0 {
                for grade in results {
                    if let id      = grade["grade"] as? Int,
                       let name    = grade["grade_name"] as? String,
                       let price   = grade["prices"] as? [[String: AnyObject]] {
                        prices.append(GradeModel(id: id, name: name, prices: price))
                    }
                }
            }
            completion(prices)
        })
    }
    
    /// Get a list of live-class at given school
    ///
    /// - Parameters:
    ///   - page:           Page number
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getLiveClasses(page: Int = 1, failureHandler: failureHandler? = nil, completion: @escaping ([LiveClassModel], Int) -> Void) -> Cancellable {
        return self.sendRequest(.getLiveClasses(schoolId: MalaCurrentSchool?.id, page: page), failureHandler: failureHandler, completion: { json in
            
            var list: [LiveClassModel] = []
            
            guard let classes = json["results"] as? [JSON],
                  let count = json["count"] as? Int, count != 0 else {
                    completion(list, 0)
                    return
            }
            
            for course in classes {
                if let _ = course["id"] as? Int {
                    list.append(LiveClassModel(dict: course))
                }
            }
            completion(list, count)
        })
    }
    
    /// Get detail data of live-class
    ///
    /// - Parameters:
    ///   - id:             Live-class id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getLiveClassDetail(id: Int = 0, failureHandler: failureHandler? = nil, completion: @escaping (LiveClassModel) -> Void) -> Cancellable {
        return self.sendRequest(.getLiveClassDetail(id: id), failureHandler: failureHandler, completion: { json in
            completion(LiveClassModel(dict: json))
        })
    }
    
    /// Get detail data of course
    ///
    /// - Parameters:
    ///   - id:             Course id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getCourseInfo(id: Int = 0, failureHandler: failureHandler? = nil, completion: @escaping (CourseModel?) -> Void) -> Cancellable {
        return self.sendRequest(.getCourseInfo(id: id), failureHandler: failureHandler, completion: { json in
            
            guard let _ = json["id"] as? Int else {
                completion(nil)
                return
            }
            
            if let _ = json["id"] as? Int,
               let _ = json["start"] as? TimeInterval,
               let _ = json["end"] as? TimeInterval,
               let _ = json["subject"] as? String,
               let _ = json["school"] as? String,
               let _ = json["is_passed"] as? Bool,
               let _ = json["teacher"] as? JSON {
                completion(CourseModel(dict: json))
                return
            }
            completion(nil)
            return
        })
    }
    
    /// Get the time-slots using given
    ///
    /// - Parameters:
    ///   - id:             Teacher id
    ///   - hours:          Course-hourse that user selected
    ///   - timeSlots:      Teacher time-slot that user selected
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getConcreteTimeslots(id: Int, hours: Int, timeSlots: [Int], failureHandler: failureHandler? = nil, completion: @escaping ([[TimeInterval]]?) -> Void) -> Cancellable {
        return self.sendRequest(.getConcreteTimeslots(id: id, hours: hours, timeSlots: timeSlots), failureHandler: failureHandler, completion: { json in
            
            guard let data = json["data"] as? [[TimeInterval]], data.count != 0 else {
                completion(nil)
                return
            }
            
            completion(data)
            return
        })
    }
    
    /// Create comment
    ///
    /// - Parameters:
    ///   - comment:        Comment model
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func createComment(comment: CommentModel, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.createComment(comment: comment), failureHandler: failureHandler, completion: { json in
            
            guard let _ = json["id"] as? Int else {
                completion(false)
                return
            }
            
            MalaToCommentCount -= 1
            completion(true)
            return
        })
    }
    
    
    /// Get detail data of given comment
    ///
    /// - Parameters:
    ///   - id:             Comment id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getCommentInfo(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (CommentModel?) -> Void) -> Cancellable {
        return self.sendRequest(.getCommentInfo(id: id), failureHandler: failureHandler, completion: { json in
            
            guard let _ = json["id"] as? Int else {
                completion(nil)
                return
            }
            
            if let _ = json["id"] as? Int,
               let _ = json["timeslot"] as? Int,
               let _ = json["score"] as? Int,
               let _ = json["content"] as? String {
                completion(CommentModel(dict: json))
                return
            }
            
            completion(nil)
            return
        })
    }
    
    /// Create order using given params
    ///
    /// - Parameters:
    ///   - order:          Params of order
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func createOrder(order: JSON, failureHandler: failureHandler? = nil, completion: @escaping (OrderForm) -> Void) -> Cancellable {
        return self.sendRequest(.createOrder(order: order), failureHandler: failureHandler, completion: { json in
            
            // failure
            if let result = json["ok"] as? Bool,
               let errorCode = json["code"] as? Int {
                completion(OrderForm(result: result, code: errorCode))
                return
            }
            
            // success
            if let id = json["id"] as? Int,
               let amount = json["to_pay"] as? Int {
                let order = OrderForm()
                order.id = id
                order.amount = amount
                
                completion(order)
                return
            }
            
            completion(OrderForm(result: false, code: -9))
            return
        })
    }
    
    /// Get chargeToken using payment-channel and order id
    ///
    /// - Parameters:
    ///   - channel:        Payment channel
    ///   - id:             Order id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getChargeToken(channel: MalaPaymentChannel, id: Int, failureHandler: failureHandler? = nil, completion: @escaping (JSON?) -> Void) -> Cancellable {
        return self.sendRequest(.getChargeToken(channel: channel, id: id), failureHandler: failureHandler, completion: { json in
            // failure, usually means that time-slot has been allocated to someone else
            if let result = json["ok"] as? Bool,
               let _ = json["code"] as? Int {
                completion(["result": result])
                return
            }
            
            // success
            completion(json)
            return
        })
    }
    
    /// Get detail data of order
    ///
    /// - Parameters:
    ///   - id:             Order id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getOrderInfo(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (OrderForm?) -> Void) -> Cancellable {
        return self.sendRequest(.getOrderInfo(id: id), failureHandler: failureHandler, completion: { json in
            // failure
            if let result = json["ok"] as? Bool,
               let errorCode = json["code"] as? Int {
                completion(OrderForm(result: result, code: errorCode))
                return
            }
            // success
            if let _ = json["id"] as? Int {
                completion(OrderForm(dict: json))
                return
            }
            
            completion(nil)
            return
        })
    }
    
    /// Cancel order
    ///
    /// - Parameters:
    ///   - id:             Order id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func cancelOrder(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (Bool) -> Void) -> Cancellable {
        return self.sendRequest(.cancelOrder(id: id), failureHandler: failureHandler, completion: { json in
            
            if let result = json["ok"] as? Bool {
                if result { MalaUnpaidOrderCount -= 1 }
                completion(result)
                return
            }
            
            completion(false)
            return
        })
    }
    
    /// Get policy HTML
    ///
    /// - Parameters:
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userProtocolHTML(failureHandler: failureHandler? = nil, completion: @escaping (String?) -> Void) -> Cancellable {
        return self.sendRequest(.userProtocolHTML(), failureHandler: failureHandler, completion: { json in
            
            guard let _ = json["updated_at"] as? Int,
                  let htmlString = json["content"] as? String else {
                    completion(nil)
                    return
            }
            
            completion(htmlString)
            return
        })
    }
    
    /// Get user study-report overview
    ///
    /// - Parameters:
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userStudyReport(failureHandler: failureHandler? = nil, completion: @escaping ([SimpleReportResultModel]) -> Void) -> Cancellable {
        return self.sendRequest(.userStudyReportOverview(), failureHandler: failureHandler, completion: { json in
            
            var reports = [SimpleReportResultModel]()
            
            if let results = json["results"] as? [JSON] {
                for report in results {
                    reports.append(SimpleReportResultModel(dict: report))
                }
            }
            
            completion(reports)
            return
        })
    }
    
    /// Get user subject-report
    ///
    /// - Parameters:
    ///   - id:             Subject id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func userSubjectReport(id: Int, failureHandler: failureHandler? = nil, completion: @escaping (SubjectReport) -> Void) -> Cancellable {
        return self.sendRequest(.userSubjectReport(id: id), failureHandler: failureHandler, completion: { json in
            completion(SubjectReport(dict: json))
        })
    }
    
    /// Load regions
    ///
    /// - Parameters:
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func loadRegions(failureHandler: failureHandler? = nil, completion: @escaping ([BaseObjectModel]) -> Void) -> Cancellable {
        return self.sendRequest(.loadRegions(), failureHandler: failureHandler, completion: { json in
            
            var cities: [BaseObjectModel] = []
            
            if let results = json["results"] as? [JSON], results.count > 0 {
                for school in results {
                    cities.append(BaseObjectModel(dict: school))
                }
            }
            
            completion(cities)
            return
        })
    }
    
    /// Get list of school using given id
    ///
    /// - Parameters:
    ///   - regionId:       Region id
    ///   - teacherId:      Teacher id
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func getSchools(regionId: Int? = nil, teacherId: Int? = nil, failureHandler: failureHandler? = nil, completion: @escaping ([SchoolModel]) -> Void) -> Cancellable {
        return self.sendRequest(.getSchools(regionId: regionId, teacherId: teacherId), failureHandler: failureHandler, completion: { json in
            
            var schools: [SchoolModel] = []
            
            if let results = json["results"] as? [JSON], results.count > 0 {
                for school in results {
                    schools.append(SchoolModel(dict: school))
                }
            }
            
            completion(sortSchoolsByDistance(schools))
            return
        })
    }
    
    /// Load list of all tags
    ///
    /// - Parameters:
    ///   - failureHandler: FailureHandler
    ///   - completion:     Completion
    /// - Returns:          Cancellable
    @discardableResult
    func loadTags(failureHandler: failureHandler? = nil, completion: @escaping ([BaseObjectModel]) -> Void) -> Cancellable {
        return self.sendRequest(.loadTags(), failureHandler: failureHandler, completion: { json in
            
            var tags: [BaseObjectModel] = []
            let results = ResultModel(dict: json).results
            for object in results! {
                if let dict = object as? JSON {
                   let set = BaseObjectModel(dict: dict)
                    tags.append(set)
                }
            }
            completion(tags)
        })
    }
}
