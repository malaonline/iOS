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
    public let MalaBaseUrl = "http://dev.malalaoshi.com/api/v1"
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

typealias nullDictionary = [String: AnyObject]

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
