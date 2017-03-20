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
}
