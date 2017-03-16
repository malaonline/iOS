//
//  MADefault.swift
//  mala-ios
//
//  Created by 王新宇 on 13/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: MAAPI) -> Endpoint<MAAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    // Sign all non-authenticating requests
    if let token = MalaUserDefaults.userAccessToken.value, target.shouldAuthorize {
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Token \(token)"])
    }else {
        return defaultEndpoint
    }
}
