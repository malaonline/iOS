//
//  MADefault.swift
//  mala-ios
//
//  Created by 王新宇 on 13/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya

let endpointClosure = { (target: MAAPI) -> Endpoint<MAAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    // Sign all non-authenticating requests
    if target.shouldAuthorize, let token = MalaUserDefaults.userAccessToken.value {
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Token \(token)"])
    }else {
        return defaultEndpoint
    }
}
