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
