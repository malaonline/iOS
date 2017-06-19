//
//  MADefault.swift
//  mala-ios
//
//  Created by 王新宇 on 13/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya

public typealias JSON = [String: Any]

#if USE_PRD_SERVER
    public var MABaseURL: URL { return URL(string: "https://www.malalaoshi.com/api/v1")! }
#elseif USE_STAGE_SERVER
    public var MABaseURL: URL { return URL(string: "https://stage.malalaoshi.com/api/v1")! }
#else
    public var MABaseURL: URL { return URL(string: "https://dev.malalaoshi.com/api/v1")! }
#endif

let endpointClosure = { (target: MAAPI) -> Endpoint<MAAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    // Sign all non-authenticating requests
    if target.shouldAuthorize, let token = MalaUserDefaults.userAccessToken.value {
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Token \(token)"])
    }else {
        return defaultEndpoint
    }
}
