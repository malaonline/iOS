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
    case uploadAvatar(data: Data, profileId: Int)
    case saveStudentName(name: String, parentId: Int)
    case saveSchoolName(name: String, parentId: Int)
    case userCoupons(onlyValid: Bool)
    case evaluationStatus(subjectId: Int)
    case getStudentSchedule(onlyPassed: Bool)
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
        case .sendSMS, .verifySMS:
            return "/sms"
        case .profileInfo(let id), .uploadAvatar(_, let id):
            return "/profiles/\(id)"
        case .parentInfo(let id), .saveStudentName(_, let id), .saveSchoolName(_, let id):
            return "/parents/\(id)"
        case .userCoupons:
            return "/coupons"
        case .evaluationStatus(let id):
            return "/subject/\(id)/record"
        case .getStudentSchedule:
            return "/timeslots"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .profileInfo, .parentInfo, .userCoupons, .evaluationStatus, .getStudentSchedule:
            return .get
        case .sendSMS, .verifySMS:
            return .post
        case .uploadAvatar, .saveStudentName, .saveSchoolName:
            return .patch
        }
    }
    public var parameters: [String : Any]? {
        switch self {
        case .sendSMS(let phone):
            return ["action": "send", "phone": phone]
        case .verifySMS(let phone, let code):
            return ["action": "verify", "phone": phone, "code": code]
        case .saveStudentName(let name, _):
            return ["student_name": name]
        case .saveSchoolName(let name, _):
            return ["student_school_name": name]
        case .userCoupons(let onlyValid):
            return ["only_valid": String(onlyValid)]
        case .getStudentSchedule(let onlyPassed):
            return ["for_review": String(onlyPassed)]
            
        default:
            return nil
        }
    }
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .sendSMS, .verifySMS, .saveStudentName, .saveSchoolName:
            return JSONEncoding.default
        case .profileInfo, .parentInfo, .uploadAvatar, .userCoupons, .evaluationStatus, .getStudentSchedule:
            return URLEncoding.default
        }
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        switch self {
        case .uploadAvatar(let imageData, _):
            return .upload(UploadType.multipart([MultipartFormData(provider: .data(imageData), name: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")]))
        default:
            return .request
        }
        
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
