//
//  MalaNetworking.swift
//  mala-ios
//
//  Created by Elors on 12/21/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit
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

// MARK: - Enum
/// 请求方法类型
public enum Method: String, CustomStringConvertible {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    
    public var description: String {
        return self.rawValue
    }
}

///  内容编码集类型
public enum ContentType: String {
    case JSON = "application/json"
    case URLEncoded = "application/x-www-form-urlencoded; charset=utf-8"
}

///  错误原因
///
///  - CouldNotParseJSON:   无法解析JSON
///  - NoData:              无数据
///  - NoSuccessStatusCode: 状态码异常
///  - Other:               其他
public enum Reason: CustomStringConvertible {
    case couldNotParseJSON
    case noData
    case noSuccessStatusCode(statusCode: Int)
    case other(NSError?)
    
    public var description: String {
        switch self {
        case .couldNotParseJSON:
            return "CouldNotParseJSON"
        case .noData:
            return "NoData"
        case .noSuccessStatusCode(let statusCode):
            return "NoSuccessStatusCode: \(statusCode)"
        case .other(let error):
            return "Other, Error: \(error?.description)"
        }
    }
}

// MARK: - Property
/// 网络请求次数
var MalaNetworkActivityCount = 0 {
    didSet {
        UIApplication.shared.isNetworkActivityIndicatorVisible = (MalaNetworkActivityCount > 0)
    }
}

// MARK: - Model
///  请求资源对象
public struct Resource<A>: CustomStringConvertible {
    let path: String
    let method: Method
    let requestBody: Data?
    let headers: [String:String]
    let parse: (Data) -> A?
    
    public var description: String {
        let decodeRequestBody: [String: AnyObject]
        if let requestBody = requestBody {
            decodeRequestBody = decodeJSON(requestBody)!
        } else {
            decodeRequestBody = [:]
        }
        
        return "Resource(Method: \(method), path: \(path), headers: \(headers), requestBody: \(decodeRequestBody))"
    }
}

// MARK: - Method
///  请求错误缺省处理方法
///
///  - parameter reason:       错误原因
///  - parameter errorMessage: 错误信息
func defaultFailureHandler(_ reason: Reason, errorMessage: String?) {
    println("\n***************************** MalaNetworking Failure *****************************")
    println("Reason: \(reason)")
    if let errorMessage = errorMessage {
        println("errorMessage: >>>\(errorMessage)<<<\n")
    }
}

///  解析出Data(JSON格式)中的error字符串信息
///
///  - parameter data: NSData对象
///
///  - returns: error字符串信息
func errorMessageInData(_ data: Data?) -> String? {
    if let data = data {
        if let json = decodeJSON(data) {
            if let errorMessage = json["error"] as? String {
                return errorMessage
            }
        }
    }
    return nil
}

public func apiRequest<A>(_ modifyRequest: (NSMutableURLRequest) -> (), baseURL: URL, resource: Resource<A>, failure: @escaping (Reason, String?) -> Void, completion: @escaping (A) -> Void) {
    #if STAGING
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = URLSession(configuration: sessionConfig, delegate: _sessionDelegate, delegateQueue: nil)
    #else
        let session = URLSession.shared
    #endif
    
    var request = NSMutableURLRequest(url: baseURL.appendingPathComponent(resource.path))
    request.httpMethod = resource.method.rawValue
    
    
    func needEncodesParametersForMethod(_ method: Method) -> Bool {
        switch method {
        case .GET, .HEAD, .DELETE:
            return true
        default:
            return false
        }
    }
    
    func query(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject! = parameters[key]
            components += queryComponents(key, value: value)
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    
    if needEncodesParametersForMethod(resource.method) {
        if let requestBody = resource.requestBody {
            if var URLComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) {
                URLComponents.percentEncodedQuery = (URLComponents.percentEncodedQuery != nil ? URLComponents.percentEncodedQuery! + "&" : "") + query(decodeJSON(requestBody)!)
                request.url = URLComponents.url
            }
        }
        
    } else {
        request.httpBody = resource.requestBody as Data?
    }
    
    modifyRequest(request)
    
    for (key, value) in resource.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
        
        // println("RequestURL@Malalaoshi - \(request.URLString)")
        
        if let httpResponse = response as? HTTPURLResponse {
            
            // 识别StatusCode并处理
            switch httpResponse.statusCode {
            // 成功, 订单创建
            case 200, 201:
                if let responseData = data {
                    
                    if let result = resource.parse(responseData) {
                        completion(result)
                    } else {
                        let dataString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                        println("\(dataString)\n")
                        
                        failure(Reason.couldNotParseJSON, errorMessageInData(data))
                        println("\(resource)\n")
                        // println(request.cURLString)
                    }
                    
                } else {
                    failure(Reason.noData, errorMessageInData(data))
                    println("\(resource)\n")
                    // println(request.cURLString)
                }
                break
                
            // 失败, 其他
            default:
                failure(Reason.noSuccessStatusCode(statusCode: httpResponse.statusCode), errorMessageInData(data))
                println("\(resource)\n")
                // println(request.cURLString)
                
                // 对于 401: errorMessage: >>>HTTP Token: Access denied<<<
                // 用户需要重新登录，所以
                if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                    
                    // 确保是自家服务
                    if let requestHost = request.url?.host, requestHost == NSURL(string: MalaBaseUrl)!.host {
                        
                        DispatchQueue.main.async {
                            // 重新登陆
                            MalaUserDefaults.userNeedRelogin()
                        }
                    }
                }
                break
            }
        } else {
            // 请求无响应, 错误处理
            failure(Reason.other(error as NSError?), errorMessageInData(data))
            println("\(resource)")
            // println(request.cURLString)
        }
        
        ///  开启网络请求指示器
        DispatchQueue.main.async {
            MalaNetworkActivityCount -= 1
        }
    }
    
    ///  执行任务
    task.resume()
    
    ///  关闭网络请求指示器
    DispatchQueue.main.async {
        MalaNetworkActivityCount += 1
    }
}


func queryComponents(_ key: String, value: AnyObject) -> [(String, String)] {
    func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CharacterSet = [":", "/", "?", "&", "=", ";", "+", "!", "@", "#", "$", "(", ")", "'", ",", "*"]
        return (string as NSString).addingPercentEncoding(withAllowedCharacters: legalURLCharactersToBeEscaped) ?? ""
    }
    
    var components: [(String, String)] = []
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value: value)
        }
    } else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents("\(key)[]", value: value)
        }
    } else {
        components.append((escape(key), escape("\(value)")))
    }
    
    return components
}


// MARK: - JSON Handle
/// 字典别名
public typealias JSONDictionary = [String: AnyObject]

///  解析NSData to JSONDictionary
///
///  - parameter data: NSData
///
///  - returns: JSONDictionary
func decodeJSON(_ data: Data) -> JSONDictionary? {
    if data.count > 0 {
        guard let result = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions()) else {
            return JSONDictionary()
        }
        
        if let dictionary = result as? JSONDictionary {
            return dictionary
        } else if let array = result as? [JSONDictionary] {
            return ["data": array as AnyObject]
        } else {
            return JSONDictionary()
        }
        
    } else {
        return JSONDictionary()
    }
}

///  编码JSONDictionary to NSData
///
///  - parameter dict: JSONDictionary
///
///  - returns: NSData
func encodeJSON(_ dict: JSONDictionary) -> Data? {
    return dict.count > 0 ? (try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())) : nil
}

///  根据请求数据返回对应的Resource结构体（无Token）
///
///  - parameter path:              Api路径
///  - parameter method:            请求方法
///  - parameter requestParameters: 参数字典
///  - parameter parse:             JSON解析器
///
///  - returns: Resource结构体
public func jsonResource<A>(path: String, method: Method, requestParameters: JSONDictionary, parse: @escaping (JSONDictionary) -> A?) -> Resource<A> {
    return jsonResource(nil, path: path, method: method, requestParameters: requestParameters, parse: parse)
}

///  根据请求数据返回对应的Resource结构体（有Token）
///
///  - parameter path:              Api路径
///  - parameter method:            请求方法
///  - parameter requestParameters: 参数字典
///  - parameter parse:             JSON解析器
///
///  - returns: Resource结构体
public func authJsonResource<A>(path: String, method: Method, requestParameters: JSONDictionary, parse: @escaping (JSONDictionary) -> A?) -> Resource<A> {
    let token = MalaUserDefaults.userAccessToken.value
    return jsonResource(token, path: path, method: method, requestParameters: requestParameters, parse: parse)
}

///  根据请求数据返回对应的Resource结构体
///
///  - parameter token:             用户令牌
///  - parameter path:              Api路径
///  - parameter method:            请求方法
///  - parameter requestParameters: 参数字典
///  - parameter parse:             JSON解析器
///
///  - returns: Resource结构体
public func jsonResource<A>(_ token: String?, path: String, method: Method, requestParameters: JSONDictionary, parse: @escaping (JSONDictionary) -> A?) -> Resource<A> {
    /// JSON解析器
    let jsonParse: (Data) -> A? = { data in
        if let json = decodeJSON(data) {
            return parse(json)
        }
        return nil
    }
    /// 请求头
    var headers = [
        "Content-Type": "application/json",
    ]
    let locale = Locale.current as NSLocale
    if let
        languageCode = locale.object(forKey: .languageCode) as? String,
        let countryCode = locale.object(forKey: .countryCode) as? String {
            headers["Accept-Language"] = languageCode + "-" + countryCode
    }
    /// 请求体
    let jsonBody = encodeJSON(requestParameters)
    /// 用户令牌
    if let token = token {
        headers["Authorization"] = "Token \(token)"
    }
    return Resource(path: path, method: method, requestBody: jsonBody, headers: headers, parse: jsonParse)
}











// Result Closure
typealias RequestCallBack = (_ result: AnyObject?, _ error: NSError?)->()

class MalaNetworking {
    // Singleton
    private init() {}
    static let sharedTools = MalaNetworking()
}


// MARK: - Request Method
extension MalaNetworking {
    
    ///  Request for GradeList
    ///
    ///  - parameter finished: Closure for Finished
    func loadGrades(_ finished: @escaping RequestCallBack) {
        request(MalaBaseUrl+gradeList, parameters: nil, finished: finished)
    }
    
    ///  Request for SubjectList
    ///
    ///  - parameter finished: Closure for Finished
    func loadSubjects(_ finished: @escaping RequestCallBack) {
        request(MalaBaseUrl+subjectList, parameters: nil, finished: finished)
    }
    
    ///  Request for TagList
    ///
    ///  - parameter finished: Closure for Finished
    func loadTags(_ finished: @escaping RequestCallBack) {
        request(MalaBaseUrl+tagList, parameters: nil, finished: finished)
    }
    
    ///  Request for MemberserviceList
    ///
    ///  - parameter finished: Closure for Finished
    func loadMemberServices(_ finished: @escaping RequestCallBack) {
        request(MalaBaseUrl+memberServiceList, parameters: nil, finished: finished)
    }
    
    ///  Request for TeacherList
    ///
    ///  - parameter parameters: Filter Dict
    ///  - parameter page:       page number
    ///  - parameter finished:   Closure for Finished
    func loadTeachers(_ parameters: [String: AnyObject]?, page: Int = 1, finished: @escaping RequestCallBack) {
        var params = parameters ?? [String: AnyObject]()
        params["page"] = page as AnyObject?
        if let city = MalaCurrentCity {
            params["region"] = city.id as AnyObject?
        }
        if let school = MalaCurrentSchool {
            params["school"] = school.id as AnyObject?
        }
        request(MalaBaseUrl+teacherList, parameters: params, finished: finished)
    }
    
    ///  Request for Teacher Detail
    ///
    ///  - parameter id:       id of teacher
    ///  - parameter finished: Closure for Finished
    func loadTeacherDetail(_ id: Int, finished: @escaping RequestCallBack) {
        request(MalaBaseUrl+teacherList+"/"+String(id), parameters: nil, finished: finished)
    }
    
    ///  Request for verify SMS
    ///
    ///  - parameter number:   string for phone number
    ///  - parameter code:     string for verify code
    ///  - parameter finished: Closure for Finished
    func verifySMS(_ number: String, code: String, finished: @escaping RequestCallBack) {
        var params = [String: AnyObject]()
        params["action"] = "verify" as AnyObject?
        params["phone"] = number as AnyObject?
        params["code"] = code as AnyObject?
        request(MalaBaseUrl+sms, method: .post, parameters: params, finished: finished)
    }
    
    ///  Request for SchoolList
    ///
    ///  - parameter finished: Closure for Finished
    func loadSchools(_ finished: @escaping RequestCallBack) {
        request(MalaBaseUrl+schools, parameters: nil, finished: finished)
    }
}


// MARK: - Encapsulation Alamofire Framework
extension MalaNetworking {
    
    ///  NetWork Request
    ///
    ///  - parameter method:     OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
    ///  - parameter URLString:  String for URL
    ///  - parameter parameters: Dictionary for Parameters
    ///  - parameter finished:   Closure for Finished
    fileprivate func request(_ URLString: URLConvertible, method: HTTPMethod = .get, parameters: Parameters?, finished: @escaping RequestCallBack) {
        
        // Show Networking Symbol
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Request
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // hide Networking Symbol
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            println(response.request!.cURLString)
            if response.result.isFailure {
                println("Network Request Failure - \(response.result.error)")
            }
            // Finished
            finished(response.result.value as AnyObject?, response.result.error as NSError?)
        }
    }
}
