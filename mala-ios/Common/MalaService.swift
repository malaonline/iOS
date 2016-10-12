//
//  MalaService.swift
//  mala-ios
//
//  Created by 王新宇 on 2/25/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Api
#if USE_PRD_SERVER
    public let MalaBaseUrl = "https://www.malalaoshi.com/api/v1"
#elseif USE_STAGE_SERVER
    public let MalaBaseUrl = "https://stage.malalaoshi.com/api/v1"
#else
    public let MalaBaseUrl = "https://dev.malalaoshi.com/api/v1"
#endif

public let MalaBaseURL = URL(string: MalaBaseUrl)!
public let gradeList = "/grades"
public let subjectList = "/subjects"
public let tagList = "/tags"
public let memberServiceList = "/memberservices"
public let teacherList = "/teachers"
public let sms = "/sms"
public let schools = "/schools"
public let weeklytimeslots = "/weeklytimeslots"
public let coupons = "/coupons"


// MARK: - typealias
typealias nullDictionary = [String: AnyObject]


// MARK: - Model
///  登陆用户信息结构体
struct LoginUser: CustomStringConvertible {
    let accessToken: String
    let userID: Int
    let parentID: Int?
    let profileID: Int
    let firstLogin: Bool?
    let avatarURLString: String?
    
    var description: String {
        return "LoginUser(accessToken: \(accessToken), userID: \(userID), parentID: \(parentID), profileID: \(profileID))" +
        ", firstLogin: \(firstLogin)), avatarURLString: \(avatarURLString))"
    }
}

///  SMS验证结果结构体
struct VerifyingSMS: CustomStringConvertible {
    let verified: String
    let first_login: String
    let token: String?
    let parent_id: String
    let reason: String?
    
    var description: String {
        return "VerifyingSMS(verified: \(verified), first_login: \(first_login), token: \(token), parent_id: \(parent_id), reason: \(reason))"
    }
}

///  个人账号信息结构体
struct profileInfo: CustomStringConvertible {
    let id: Int
    let gender: String?
    let avatar: String?
    
    var description: String {
        return "parentInfo(id: \(id), gender: \(gender), avatar: \(avatar)"
    }
}

///  家长账号信息结构体
struct parentInfo: CustomStringConvertible {
    let id: Int
    let studentName: String?
    let schoolName: String?
    
    var description: String {
        return "parentInfo(id: \(id), studentName: \(studentName), schoolName: \(schoolName)"
    }
}


// MARK: - Support Method
///  登陆成功后，获取个人信息和家长信息并保存到UserDefaults
func getInfoWhenLoginSuccess() {
    
    // 个人信息
    getAndSaveProfileInfo()
    
    // 家长信息
    getAndSaveParentInfo()
}

func getAndSaveProfileInfo() {
    let profileID = MalaUserDefaults.profileID.value ?? 0
    getProfileInfo(profileID, failureHandler: { (reason, errorMessage) -> Void in
        defaultFailureHandler(reason, errorMessage: errorMessage)
        // 错误处理
        if let errorMessage = errorMessage {
            println("MalaService - getProfileInfo Error \(errorMessage)")
        }
        },completion: { (profile) -> Void in
            println("保存Profile信息: \(profile)")
            saveProfileInfoToUserDefaults(profile)
    })
}

func getAndSaveParentInfo() {
    let parentID = MalaUserDefaults.parentID.value ?? 0
    getParentInfo(parentID, failureHandler: { (reason, errorMessage) -> Void in
        defaultFailureHandler(reason, errorMessage: errorMessage)
        // 错误处理
        if let errorMessage = errorMessage {
            println("MalaService - getParentInfo Error \(errorMessage)")
        }
        },completion: { (parent) -> Void in
            println("保存Parent信息: \(parent)")
            saveParentInfoToUserDefaults(parent)
    })
}


// MARK: - User

///  保存用户信息到UserDefaults
///  - parameter loginUser: 登陆用户模型
func saveTokenAndUserInfo(_ loginUser: LoginUser) {
    MalaUserDefaults.userID.value = loginUser.userID
    MalaUserDefaults.parentID.value = loginUser.parentID
    MalaUserDefaults.profileID.value = loginUser.profileID
    MalaUserDefaults.firstLogin.value = loginUser.firstLogin
    MalaUserDefaults.userAccessToken.value = loginUser.accessToken
}
////  保存个人信息到UserDefaults
///
///  - parameter profile: 个人信息模型
func saveProfileInfoToUserDefaults(_ profile: profileInfo) {
    MalaUserDefaults.gender.value = profile.gender
    MalaUserDefaults.avatar.value = profile.avatar
}
///  保存家长信息到UserDefaults
///
///  - parameter parent: 家长信息模型
func saveParentInfoToUserDefaults(_ parent: parentInfo) {
    MalaUserDefaults.studentName.value = parent.studentName
    MalaUserDefaults.schoolName.value = parent.schoolName
}

///  获取验证码
///
///  - parameter mobile:         手机号码
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func sendVerifyCodeOfMobile(_ mobile: String, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    /// 参数字典
    let requestParameters = [
        "action": VerifyCodeMethod.Send.rawValue,
        "phone": mobile
    ]
    /// 返回值解析器
    let parse: (JSONDictionary) -> Bool? = { data in
        
        if let result = data["sent"] as? Bool {
            return result
        }
        return false
    }
    
    /// 请求资源对象
    let resource = jsonResource(path: "/sms", method: .POST, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    /// 若未实现请求错误处理，进行默认的错误处理
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  验证手机号
///
///  - parameter mobile:         手机号码
///  - parameter verifyCode:     验证码
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func verifyMobile(_ mobile: String, verifyCode: String, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (LoginUser) -> Void) {
    let requestParameters = [
        "action": VerifyCodeMethod.Verify.rawValue,
        "phone": mobile,
        "code": verifyCode
    ]
    
    let parse: (JSONDictionary) -> LoginUser? = { data in
        return parseLoginUser(data)
    }
    
    let resource = jsonResource(path: "/sms", method: .POST, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  根据个人id获取个人信息
///
///  - parameter parentID:       个人
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getProfileInfo(_ profileID: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (profileInfo) -> Void) {
    let parse: (JSONDictionary) -> profileInfo? = { data in
        return parseProfile(data)
    }
    
    let resource = authJsonResource(path: "/profiles/\(profileID)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  根据家长id获取家长信息
///
///  - parameter parentID:       家长id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getParentInfo(_ parentID: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (parentInfo) -> Void) {
    let parse: (JSONDictionary) -> parentInfo? = { data in
        return parseParent(data)
    }
    
    let resource = authJsonResource(path: "/parents/\(parentID)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  上传用户头像
///
///  - parameter imageData:      头像
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func updateAvatarWithImageData(_ imageData: Data, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    
    guard let token = MalaUserDefaults.userAccessToken.value else {
        println("updateAvatar error - no token")
        return
    }
    
    guard let profileID = MalaUserDefaults.profileID.value else {
        println("updateAvatar error - no profileID")
        return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Token \(token)"]
    let url: URLConvertible = MalaBaseUrl + "/profiles/\(profileID)"
    
    Alamofire.upload(imageData, to: url, method: .patch, headers: headers).responseJSON { (response) in
        
        println("upload - response: \(response)")
        
        guard
            let data = response.data,
            let json = decodeJSON(data),
            let uploadResult = json["done"] as? String else {
                failureHandler?(.couldNotParseJSON, nil)
                return
        }
        let result = (uploadResult == "true" ? true : false)
        completion(result)
    }
}

///  保存学生姓名
///
///  - parameter name:           姓名
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func saveStudentName(_ name: String, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    
    guard let parentID = MalaUserDefaults.parentID.value else {
        println("saveStudentSchoolName error - no profileID")
        return
    }
    
    let requestParameters = [
        "student_name": name,
    ]
    
    let parse: (JSONDictionary) -> Bool? = { data in
        if let result = data["done"] as? String, result == "true" {
            return true
        }else {
            return false
        }
    }
    
    let resource = authJsonResource(path: "/parents/\(parentID)", method: .PATCH, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  保存学生学校名称
///
///  - parameter name:           学校名称
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func saveStudentSchoolName(_ name: String, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    
    guard let parentID = MalaUserDefaults.parentID.value else {
        println("saveStudentSchoolName error - no profileID")
        return
    }
    
    let requestParameters = [
        "student_school_name": name,
    ]
    
    let parse: (JSONDictionary) -> Bool? = { data in
        if let result = data["done"] as? Bool {
            return result
        }
        return false
    }
    
    let resource = authJsonResource(path: "/parents/\(parentID)", method: .PATCH, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  优惠券列表解析函数
///
///  - parameter onlyValid:      是否只返回可用奖学金
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getCouponList(_ onlyValid: Bool = false, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([CouponModel]) -> Void) {

    let parse: ([JSONDictionary]) -> [CouponModel] = { couponData in
        /// 解析优惠券JSON数组
        var coupons = [CouponModel]()
        for couponInfo in couponData {
            if let coupon = parseCoupon(couponInfo) {
                coupon.setupStatus()
                coupons.append(coupon)
            }
        }
        return coupons
    }
    
    ///  获取优惠券列表JSON对象
    headBlockedCoupons(onlyValid, failureHandler: failureHandler) { (jsonData) -> Void in
        if let coupons = jsonData["results"] as? [JSONDictionary], coupons.count != 0 {
            completion(parse(coupons))
        }else {
            completion([])
        }
    }
}

///  获取优惠券列表
///
///  - parameter onlyValid:      是否只返回可用奖学金
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func headBlockedCoupons(_ onlyValid: Bool = false, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (JSONDictionary) -> Void) {
    
    let parse: (JSONDictionary) -> JSONDictionary? = { data in
        return data
    }
    let requestParameters = ["only_valid": String(onlyValid)]
    let resource = authJsonResource(path: "/coupons", method: .GET, requestParameters: requestParameters as JSONDictionary, parse: parse)
    apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
}

///  判断用户是否第一次购买此学科的课程
///
///  - parameter subjectID:      学科id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func isHasBeenEvaluatedWithSubject(_ subjectID: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {

    let parse: (JSONDictionary) -> Bool = { data in
        if let result = data["evaluated"] as? Bool {
            // 服务器返回结果为：用户是否已经做过此学科的建档测评，是则代表非首次购买。故取反处理。
            return !result
        }
        return true
    }
    
    let resource = authJsonResource(path: "/subject/\(subjectID)/record", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取学生上课时间表
///
///  - parameter onlyPassed:     是否只获取已结束的课程
///  - parameter page:           页数
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getStudentCourseTable(_ onlyPassed: Bool = false, page: Int = 1, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([StudentCourseModel]) -> Void) {
    
    let parse: (JSONDictionary) -> [StudentCourseModel] = { data in
        return parseStudentCourse(data)
    }
    let requestParameters = ["for_review": String(onlyPassed)]    
    let resource = authJsonResource(path: "/timeslots", method: .GET, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取用户订单列表
///
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getOrderList(_ page: Int = 1, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([OrderForm], Int) -> Void) {
    
    let requestParameters: JSONDictionary = [
        "page": page as AnyObject,
        ]
    
    let parse: (JSONDictionary) -> ([OrderForm], Int) = { data in
        return parseOrderList(data)
    }
    
    let resource = authJsonResource(path: "/orders", method: .GET, requestParameters: requestParameters, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取用户新消息数量
///
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getUserNewMessageCount(_ failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (_ order: Int, _ comment: Int) -> Void) {
    
    let parse: (JSONDictionary) -> (order: Int, comment: Int) = { data in
        if
            let order = data["unpaid_num"] as? Int,
            let comment = data["tocomment_num"] as? Int {
            return (order, comment)
        }else {
            return (0, 0)
        }
    }
    
    let resource = authJsonResource(path: "/my_center", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取用户收藏老师列表
///
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getFavoriteTeachers(_ page: Int = 1, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([TeacherModel], Int) -> Void) {
    
    let requestParameters = [
        "page": page,
        ]
    
    let parse: (JSONDictionary) -> ([TeacherModel], Int) = { data in
        return parseFavoriteTeacherResult(data)
    }
    
    let resource = authJsonResource(path: "/favorites", method: .GET, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  收藏老师
///
///  - parameter id:             老师id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func addFavoriteTeacher(_ id: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    
    let requestParameters = [
        "teacher": id,
        ]
    
    let parse: (JSONDictionary) -> Bool = { data in
        return true
    }
    
    let resource = authJsonResource(path: "/favorites", method: .POST, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  取消收藏老师
///
///  - parameter id:             老师id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func removeFavoriteTeacher(_ id: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    let parse: (JSONDictionary) -> Bool = { data in
        return true
    }
    
    let resource = authJsonResource(path: "/favorites/\(id)", method: .DELETE, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}


// MARK: - Teacher
///  获取老师详情数据
///
///  - parameter id:             老师id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func loadTeacherDetailData(_ id: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (TeacherDetailModel?) -> Void) {
    
    let parse: (JSONDictionary) -> TeacherDetailModel? = { data in
        let model: TeacherDetailModel?
        model = TeacherDetailModel(dict: data)
        return model
    }
    
    var resource: Resource<TeacherDetailModel>?
    
    if MalaUserDefaults.isLogined {
        resource = authJsonResource(path: "/teachers/\(id)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    }else {
        resource = jsonResource(path: "/teachers/\(id)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    }
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource!, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource!, failure: defaultFailureHandler, completion: completion)
    }
}
///  获取[指定老师]在[指定上课地点]的可用时间表
///
///  - parameter teacherId:      老师id
///  - parameter schoolId:       上课地点id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getTeacherAvailableTimeInSchool(_ teacherId: Int, schoolId: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([[ClassScheduleDayModel]]) -> Void) {
    
    let requestParameters = [
        "school_id": schoolId,
    ]
    
    let parse: (JSONDictionary) -> [[ClassScheduleDayModel]] = { data in
        return parseClassSchedule(data)
    }
    
    let resource = authJsonResource(path: "teachers/\(teacherId)/weeklytimeslots", method: .GET, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}
///  获取[指定老师]在[指定上课地点]的价格阶梯
///
///  - parameter teacherID:      老师id
///  - parameter schoolID:       上课地点id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getTeacherGradePrice(_ teacherId: Int, schoolId: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([GradeModel]) -> Void) {
    
    let parse: (JSONDictionary) -> [GradeModel] = { data in
        return parseTeacherGradePrice(data)
    }
    
    let resource = authJsonResource(path: "teacher/\(teacherId)/school/\(schoolId)/prices", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}
func loadTeachersWithConditions(_ conditions: JSONDictionary?, failureHandler: ((Reason, String?) -> Void)?, completion: ([TeacherModel]) -> Void) {
    
}


// MARK: - Course
///  获取课程信息
///
///  - parameter id:             课程id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getCourseInfo(_ id: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (CourseModel) -> Void) {
    
    let parse: (JSONDictionary) -> CourseModel? = { data in
        return parseCourseInfo(data)
    }
    
    let resource = authJsonResource(path: "timeslots/\(id)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取上课时间表
///
///  - parameter teacherID:      老师id
///  - parameter hours:          课时
///  - parameter timeSlots:      所选上课时间
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getConcreteTimeslots(_ teacherID: Int, hours: Int, timeSlots: [Int], failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([[TimeInterval]]?) -> Void) {
    
    guard timeSlots.count != 0 else {
        ThemeHUD.hideActivityIndicator()
        return
    }
    
    let timeSlotStrings = timeSlots.map { (id) -> String in
        return String(id)
    }
    
    let requestParameters = [
        "teacher": teacherID,
        "hours": hours,
        "weekly_time_slots": timeSlotStrings.joined(separator: " ")
        ] as [String : Any]
    
    let parse: (JSONDictionary) -> [[TimeInterval]]? = { data in
        return parseConcreteTimeslot(data)
    }
    
    let resource = authJsonResource(path: "concrete/timeslots", method: .GET, requestParameters: (requestParameters as JSONDictionary), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}


// MARK: - Comment
///  创建评价
///
///  - parameter comment:        评价对象
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func createComment(_ comment: CommentModel, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    
    let requestParameters = [
        "timeslot": comment.timeslot,
        "score": comment.score,
        "content": comment.content
    ] as [String : Any]
    
    let parse: (JSONDictionary) -> Bool = { data in
        return true //(data != nil)
    }
    
    let resource = authJsonResource(path: "comments", method: .POST, requestParameters: (requestParameters as JSONDictionary), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取评价信息
///
///  - parameter id:             评价id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getCommentInfo(_ id: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (CommentModel) -> Void) {
    
    let parse: (JSONDictionary) -> CommentModel? = { data in
        return parseCommentInfo(data)
    }
    
    let resource = authJsonResource(path: "comments/\(id)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}


// MARK: - Payment
///  创建订单
///
///  - parameter orderForm:      订单对象字典
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func createOrderWithForm(_ orderForm: JSONDictionary, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (OrderForm) -> Void) {
    // teacher              老师id
    // school               上课地点id
    // grade                年级(&价格)id
    // subject              学科id
    // coupon               优惠卡券id
    // hours                用户所选课时数
    // weekly_time_slots    用户所选上课时间id数组
    
    /// 返回值解析器
    let parse: (JSONDictionary) -> OrderForm? = { data in
        return parseOrderCreateResult(data)
    }
    
    let resource = authJsonResource(path: "/orders", method: .POST, requestParameters: orderForm, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取支付信息
///
///  - parameter channel:        支付方式
///  - parameter orderID:        订单id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getChargeTokenWithChannel(_ channel: MalaPaymentChannel, orderID: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (JSONDictionary?) -> Void) {
    let requestParameters = [
        "action": PaymentMethod.Pay.rawValue,
        "channel": channel.rawValue
    ]
    
    let parse: (JSONDictionary) -> JSONDictionary? = { data in
        return parseChargeToken(data)
    }
    
    let resource = authJsonResource(path: "/orders/\(orderID)", method: .PATCH, requestParameters: requestParameters as JSONDictionary, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取订单信息
///
///  - parameter orderID:        订单id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getOrderInfo(_ orderID: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (OrderForm) -> Void) {
    /// 返回值解析器
    let parse: (JSONDictionary) -> OrderForm? = { data in
        return parseOrderFormInfo(data)
    }
    
    let resource = authJsonResource(path: "/orders/\(orderID)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  取消订单
///
///  - parameter orderID:        订单id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func cancelOrderWithId(_ orderID: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (Bool) -> Void) {
    /// 返回值解析器
    let parse: (JSONDictionary) -> Bool = { data in
        if let result = data["ok"] as? Bool {
            return result
        }
        return false
    }
    
    let resource = authJsonResource(path: "/orders/\(orderID)", method: .DELETE, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}


// MARK: - Study Report
///  获取学习报告总览
///  包括每个已报名学科，及其支持情况、答题数、正确数
///
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getStudyReportOverview(_ failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([SimpleReportResultModel]) -> Void) {
    /// 返回值解析器
    let parse: (JSONDictionary) -> [SimpleReportResultModel] = { data in
        return parseStudyReportResult(data)
    }
    
    let resource = authJsonResource(path: "/study_report", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取单个学科的学习报告
///
///  - parameter id: 学科id
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getSubjectReport(_ id: Int, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (SubjectReport) -> Void) {
    /// 返回值解析器
    let parse: (JSONDictionary) -> SubjectReport = { data in
        return parseStudyReport(data)
    }
    
    let resource = authJsonResource(path: "/study_report/\(id)", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}


// MARK: - Other
///  获取城市数据列表
///
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func loadRegions(_ failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([BaseObjectModel]) -> Void) {
    let parse: (JSONDictionary) -> [BaseObjectModel] = { data in
        return parseCitiesResult(data)
    }
    
    let resource = jsonResource(path: "/regions", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取学校数据列表
///
///  - parameter region: 城市id（传入即为筛选指定城市学校列表，为空则使用当前选择的城市id）
///  - parameter teacher: 老师id（传入即为筛选该老师指定的上课地点）
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getSchools(_ cityId: Int? = nil, teacher: Int? = nil, failureHandler: ((Reason, String?) -> Void)?, completion: @escaping ([SchoolModel]) -> Void) {
    
    let parse: (JSONDictionary) -> [SchoolModel] = { data in
        return sortSchoolsByDistance(parseSchoolsResult(data))
    }
    
    var params = nullDictionary()
    
    if let id = cityId {
        params["region"] = id as AnyObject?
    } else if let region = MalaCurrentCity {
        params["region"] = region.id as AnyObject?
    }
    if let teacherId = teacher {
        params["teacher"] = teacherId as AnyObject?
    }
    
    let resource = authJsonResource(path: "/schools", method: .GET, requestParameters: params, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}

///  获取用户协议HTML
///
///  - parameter failureHandler: 失败处理闭包
///  - parameter completion:     成功处理闭包
func getUserProtocolHTML(_ failureHandler: ((Reason, String?) -> Void)?, completion: @escaping (String?) -> Void) {
    
    let parse: (JSONDictionary) -> String? = { data in
        return parseUserProtocolHTML(data)
    }
    
    let resource = authJsonResource(path: "/policy", method: .GET, requestParameters: nullDictionary(), parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: MalaBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}



// MARK: - Parse
/// 订单JSON解析器
let parseOrderForm: (JSONDictionary) -> OrderForm? = { orderInfo in
    
    // 订单创建失败
    if
        let result = orderInfo["ok"] as? Bool,
        let errorCode = orderInfo["code"] as? Int {
        return OrderForm(result: result, code: errorCode)
    }
    
    // 订单创建成功
    if
        let id          = orderInfo["id"] as? Int,
        let teacher     = orderInfo["teacher"] as? Int,
        let teacherName = orderInfo["teacher_name"] as? String,
        let school      = orderInfo["school"] as? String,
        let grade       = orderInfo["grade"] as? String,
        let subject     = orderInfo["subject"] as? String,
        let hours       = orderInfo["hours"] as? Int,
        let status      = orderInfo["status"] as? String,
        let orderId     = orderInfo["order_id"] as? String,
        let amount      = orderInfo["to_pay"] as? Int,
        let evaluated   = orderInfo["evaluated"] as? Bool {
        // 创建订单模型
        let order = OrderForm(id: id, orderId: orderId, teacherId: teacher, teacherName: teacherName, schoolName: school, gradeName: grade, subjectName: subject, orderStatus: status, amount: amount, evaluated: evaluated)
        // 教师头像
        if let avatar = orderInfo["teacher_avatar"] as? String {
            order.avatarURL = avatar
        }
        return order
    }
    return nil
}
/// 订单JSON解析器
let parseOrderFormInfo: (JSONDictionary) -> OrderForm? = { orderInfo in
    
    // 订单创建失败
    if
        let result = orderInfo["ok"] as? Bool,
        let errorCode = orderInfo["code"] as? Int {
        return OrderForm(result: result, code: errorCode)
    }
    
    // 订单创建成功
    if
        let id              = orderInfo["id"] as? Int,
        let teacher         = orderInfo["teacher"] as? Int,
        let teacherName     = orderInfo["teacher_name"] as? String,
        let school          = orderInfo["school"] as? String,
        let schoolId        = orderInfo["school_id"] as? Int,
        let grade           = orderInfo["grade"] as? String,
        let subject         = orderInfo["subject"] as? String,
        let hours           = orderInfo["hours"] as? Int,
        let status          = orderInfo["status"] as? String,
        let orderId         = orderInfo["order_id"] as? String,
        let amount          = orderInfo["to_pay"] as? Int,
        let createdAt       = orderInfo["created_at"] as? TimeInterval,
        let timeSlots       = orderInfo["timeslots"] as? [[TimeInterval]],
        let evaluated       = orderInfo["evaluated"] as? Bool,
        let isTimeAllocated = orderInfo["is_timeslot_allocated"] as? Bool,
        let isteacherPublished = orderInfo["is_teacher_published"] as? Bool {
        // 订单信息
        let order = OrderForm(id: id, orderId: orderId, teacherId: teacher, teacherName: teacherName, schoolId: schoolId, schoolName: school, gradeName: grade, subjectName: subject, orderStatus: status, hours: hours, amount: amount, timeSlots: timeSlots, createAt: createdAt, evaluated: evaluated, teacherPublished: isteacherPublished)
        // 判断是否存在支付时间（未支付状态无此数据）
        if let paidAt = orderInfo["paid_at"] as? TimeInterval {
            order.paidAt = paidAt
        }
        // 判断是否存在支付渠道（订单取消状态无此数据）
        if let chargeChannel   = orderInfo["charge_channel"] as? String {
            order.chargeChannel = chargeChannel
        }
        // 教师头像
        if let avatar = orderInfo["teacher_avatar"] as? String {
            order.avatarURL = avatar
        }
        return order
    }
    return nil
}
/// 订单创建返回结果JSON解析器
let parseOrderCreateResult: (JSONDictionary) -> OrderForm? = { orderInfo in
    
    println("结果：\(orderInfo)")
    
    // 订单创建失败
    if
        let result = orderInfo["ok"] as? Bool,
        let errorCode = orderInfo["code"] as? Int {
        return OrderForm(result: result, code: errorCode)
    }
    
    // 订单创建成功
    if
        let id = orderInfo["id"] as? Int,
        let amount = orderInfo["to_pay"] as? Int {
        let order = OrderForm()
        order.id = id
        order.amount = amount
        return order
    }
    return nil
}
/// SMS验证结果JSON解析器
let parseLoginUser: (JSONDictionary) -> LoginUser? = { userInfo in
    /// 判断验证结果是否正确
    guard let verified = userInfo["verified"], (verified as? Bool) == true else {
        return nil
    }
    
    if
        let firstLogin = userInfo["first_login"] as? Bool,
        let accessToken = userInfo["token"] as? String,
        let parentID = userInfo["parent_id"] as? Int,
        let userID = userInfo["user_id"] as? Int,
        let profileID = userInfo["profile_id"] as? Int {
            return LoginUser(accessToken: accessToken, userID: userID, parentID: parentID, profileID: profileID, firstLogin: firstLogin, avatarURLString: "")
    }
    return nil
}
/// 个人信息JSON解析器
let parseProfile: (JSONDictionary) -> profileInfo? = { profileData in
    /// 判断验证结果是否正确
    guard let profileID = profileData["id"] else {
        return nil
    }
    
    if
        let id = profileData["id"] as? Int,
        let gender = profileData["gender"] as? String? {
            let avatar = (profileData["avatar"] as? String) ?? ""
            return profileInfo(id: id, gender: gender, avatar: avatar)
    }
    return nil
}
/// 家长信息JSON解析器
let parseParent: (JSONDictionary) -> parentInfo? = { parentData in
    /// 判断验证结果是否正确
    guard let parentID = parentData["id"] else {
        return nil
    }
    
    if
        let id = parentData["id"] as? Int,
        let studentName = parentData["student_name"] as? String?,
        let schoolName = parentData["student_school_name"] as? String? {
            return parentInfo(id: id, studentName: studentName, schoolName: schoolName)
    }
    return nil
}
/// 优惠券JSON解析器
let parseCoupon: (JSONDictionary) -> CouponModel? = { couponInfo in

    /// 检测返回值有效性
    guard let id = couponInfo["id"] else {
        return nil
    }
    
    if
        let id = couponInfo["id"] as? Int,
        let name = couponInfo["name"] as? String,
        let amount = couponInfo["amount"] as? Int,
        let expired_at = couponInfo["expired_at"] as? TimeInterval,
        let minPrice = couponInfo["mini_total_price"] as? Int,
        let used = couponInfo["used"] as? Bool {
        return CouponModel(id: id, name: name, amount: amount, expired_at: expired_at, minPrice: minPrice, used: used)
    }
    return nil
}
/// 可用上课时间表JSON解析器
let parseClassSchedule: (JSONDictionary) -> [[ClassScheduleDayModel]] = { scheduleInfo in
    
    // 本周时间表
    var weekSchedule: [[ClassScheduleDayModel]] = []
    
    // 循环一周七天的可用时间表
    for index in 1...7 {
        if let day = scheduleInfo[String(index)] as? [[String: AnyObject]] {
            var daySchedule: [ClassScheduleDayModel] = []
            for dict in day {
                daySchedule.append(ClassScheduleDayModel(dict: dict))
            }
            weekSchedule.append(daySchedule)
        }
    }
    return weekSchedule
}
/// 学生上课时间表JSON解析器
let parseStudentCourse: (JSONDictionary) -> [StudentCourseModel] = { courseInfos in
    
    /// 学生上课时间数组
    var courseList: [StudentCourseModel] = []
    
    /// 确保相应格式正确，且存在数据
    guard let courses = courseInfos["results"] as? [JSONDictionary], courses.count != 0 else {
        return courseList
    }
    
    ///  遍历字典数组，转换为模型
    for course in courses {

        if
            let id = course["id"] as? Int,
            let start = course["start"] as? TimeInterval,
            let end = course["end"] as? TimeInterval,
            let subject = course["subject"] as? String,
            let grade = course["grade"] as? String,
            let school = course["school"] as? String,
            let is_passed = course["is_passed"] as? Bool,
            let is_expired = course["is_expired"] as? Bool {
            
            let model = StudentCourseModel(id: id, start: start, end: end, subject: subject, grade: grade, school: school, is_passed: is_passed, is_expired: is_expired)
            
            if let is_commented = course["is_commented"] as? Bool {
                model.is_commented = is_commented
            }
            
            /// 老师模型
            if
                let teacherDict = course["teacher"] as? JSONDictionary,
                let id = teacherDict["id"] as? Int,
                let avatar = teacherDict["avatar"] as? String,
                let name = teacherDict["name"] as? String {
                model.teacher = TeacherModel(id: id, name: name, avatar: avatar)
            }
            /// 评价模型
            if
                let commentDict = course["comment"] as? JSONDictionary,
                let id = commentDict["id"] as? Int,
                let timeslot = commentDict["timeslot"] as? Int,
                let score = commentDict["score"] as? Int,
                let content = commentDict["content"] as? String {
                model.comment = CommentModel(id: id, timeslot: timeslot, score: score, content: content)
            }
            
            courseList.append(model)
        }else {
            continue
        }
    }
    return courseList
}
/// 课程信息JSON解析器
let parseCourseInfo: (JSONDictionary) -> CourseModel? = { courseInfo in
    
    guard let id = courseInfo["id"] as? Int else {
        return nil
    }
    
    if
        let id = courseInfo["id"] as? Int,
        let start = courseInfo["start"] as? TimeInterval,
        let end = courseInfo["end"] as? TimeInterval,
        let subject = courseInfo["subject"] as? String,
        let school = courseInfo["school"] as? String,
        let is_passed = courseInfo["is_passed"] as? Bool,
        let teacher = courseInfo["teacher"] as? JSONDictionary {
            return CourseModel(dict: courseInfo)
    }
    return nil
}
/// 评论信息JSON解析器
let parseCommentInfo: (JSONDictionary) -> CommentModel? = { commentInfo in
    
    guard let id = commentInfo["id"] as? Int else {
        return nil
    }
    
    if
        let id = commentInfo["id"] as? Int,
        let timeslot = commentInfo["timeslot"] as? Int,
        let score = commentInfo["score"] as? Int,
        let content = commentInfo["content"] as? String {
            return CommentModel(dict: commentInfo)
    }
    return nil
}
/// 用户协议JSON解析器
let parseUserProtocolHTML: (JSONDictionary) -> String? = { htmlInfo in
    
    guard
        let updatedAt = htmlInfo["updated_at"] as? Int,
        let htmlString = htmlInfo["content"] as? String else {
        return nil
    }

    return htmlString
}
/// 上课时间表JSON解析器
let parseConcreteTimeslot: (JSONDictionary) -> [[TimeInterval]]? = { timeSlotsInfo in
    
    guard let data = timeSlotsInfo["data"] as? [[TimeInterval]], data.count != 0 else {
        return nil
    }
    
    return data
}
/// 订单列表JSON解析器
let parseOrderList: (JSONDictionary) -> ([OrderForm], Int) = { ordersInfo in
    
    var orderList: [OrderForm] = []
    
    guard
        let orders = ordersInfo["results"] as? [JSONDictionary],
        let count = ordersInfo["count"] as? Int, count != 0 else {
        return (orderList, 0)
    }
    
    for order in orders {
        if
            let id          = order["id"] as? Int,
            let teacher     = order["teacher"] as? Int,
            let teacherName = order["teacher_name"] as? String,
            let schoolId    = order["school_id"] as? Int,
            let schoolName  = order["school"] as? String,
            let grade       = order["grade"] as? String,
            let subject     = order["subject"] as? String,
            let hours       = order["hours"] as? Int,
            let status      = order["status"] as? String,
            let orderId     = order["order_id"] as? String,
            let amount      = order["to_pay"] as? Int,
            let evaluated   = order["evaluated"] as? Bool,
            let isteacherPublished = order["is_teacher_published"] as? Bool {
            // 创建订单模型
            let orderForm = OrderForm(id: id, orderId: orderId, teacherId: teacher, teacherName: teacherName, schoolId: schoolId, schoolName: schoolName, gradeName: grade, subjectName: subject, orderStatus: status, amount: amount, evaluated: evaluated, teacherPublished: isteacherPublished)
            // 教师头像
            if let avatar = order["teacher_avatar"] as? String {
                orderForm.avatarURL = avatar
            }
            orderList.append(orderForm)
        }
    }
    
    return (orderList, count)
}
/// 支付信息JSON解析器
let parseChargeToken: (JSONDictionary) -> JSONDictionary? = { chargeInfo in
    
    // 支付信息获取失败（课程被占用）
    if
        let result = chargeInfo["ok"] as? Bool,
        let errorCode = chargeInfo["code"] as? Int {
        return ["result": result as AnyObject]
    }
    
    // 支付信息获取成功
    return chargeInfo
}
/// 学习报告总览JSON解析器
let parseStudyReportResult: (JSONDictionary) -> [SimpleReportResultModel] = { resultInfo in
    
    var reports = [SimpleReportResultModel]()
    
    if let results = resultInfo["results"] as? [JSONDictionary] {
        for report in results {
            reports.append(SimpleReportResultModel(dict: report))
        }
    }
    return reports
}
/// 单门学习报告数据JSON解析器
let parseStudyReport: (JSONDictionary) -> SubjectReport = { reportInfo in
    var report = SubjectReport(dict: reportInfo)
    return report
}
/// 学校数据列表JSON解析器
let parseSchoolsResult: (JSONDictionary) -> [SchoolModel] = { resultInfo in
    
    var schools: [SchoolModel] = []
    
    if let results = resultInfo["results"] as? [JSONDictionary], results.count > 0 {
        for school in results {
            schools.append(SchoolModel(dict: school))
        }
    }
    return schools
}
/// 老师收藏列表JSON解析器
let parseFavoriteTeacherResult: (JSONDictionary) -> ([TeacherModel], Int) = { resultInfo in
    
    var teachers: [TeacherModel] = []
    var count = 0
    
    if
        let allCount = resultInfo["count"] as? Int,
        let results = resultInfo["results"] as? [JSONDictionary], results.count > 0 {
        count = allCount
        for teacher in results {
            teachers.append(TeacherModel(dict: teacher))
        }
    }
    return (teachers, count)
}
/// 城市数据列表JSON解析器
let parseCitiesResult: (JSONDictionary) -> [BaseObjectModel] = { resultInfo in
    
    var cities: [BaseObjectModel] = []
    
    if let results = resultInfo["results"] as? [JSONDictionary], results.count > 0 {
        for school in results {
            cities.append(BaseObjectModel(dict: school))
        }
    }
    return cities
}
/// 价格阶梯JSON解析器
let parseTeacherGradePrice: (JSONDictionary) -> [GradeModel] = { resultInfo in
    
    var prices: [GradeModel] = []

    if let results = resultInfo["results"] as? [JSONDictionary], results.count > 0 {
        for grade in results {
            if
                let id      = grade["grade"] as? Int,
                let name    = grade["grade_name"] as? String,
                let price   = grade["prices"] as? [[String: AnyObject]] {
                prices.append(GradeModel(id: id, name: name, prices: price))
            }
        }
    }
    return prices
}
