//
//  MAAPI.swift
//  mala-ios
//
//  Created by 王新宇 on 15/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya
import Result

public enum MAAPI {
    case sendSMS(phone: String)
    case verifySMS(phone: String, code: String)
    case profileInfo(id: Int)
    case parentInfo(id: Int)
}

extension MAAPI: TargetType {
    
    // MARK: - TargetType protocol
#if USE_PRD_SERVER
    public var baseURL: URL { return URL(string: "https://www.malalaoshi.com/api/v1")! }
#elseif USE_STAGE_SERVER
    public var baseURL: URL { return URL(string: "https://stage.malalaoshi.com/api/v1")! }
#else
    public var baseURL: URL { return URL(string: "http://dev.malalaoshi.com/api/v1")! }
#endif
    public var path: String {
        switch self {
        case .sendSMS(_), .verifySMS(_, _):
            return "/sms"
        case .profileInfo(let id):
            return "/profiles/\(id)"
        case .parentInfo(let id):
            return "/parents/\(id)"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .profileInfo(_), .parentInfo(_):
            return .get
        case .sendSMS(_), .verifySMS(_, _):
            return .post
        }
    }
    public var parameters: [String : Any]? {
        switch self {
        case .sendSMS(let phone):
            return ["action": "send", "phone": phone]
        case .verifySMS(let phone, let code):
            return ["action": "verify", "phone": phone, "code": code]
        default:
            return nil
        }
    }
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .profileInfo, .parentInfo:
            return URLEncoding.default
        case .sendSMS, .verifySMS:
            return JSONEncoding.default
        }
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        return .request
    }
}

extension MAAPI: AccessTokenAuthorizable {
    public var shouldAuthorize: Bool {
        switch self {
        case .sendSMS, .verifySMS:
            return false
        default:
            return true
        }
    }
}
