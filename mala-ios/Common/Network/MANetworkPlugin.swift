//
//  MANetworkPlugin.swift
//  mala-ios
//
//  Created by 王新宇 on 15/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya
import Result

/// A protocol for controlling the behavior of `MANetworkPlugin`.
public protocol HUDController {
    
    /// Declares whether or not `MANetworkPlugin` should show HUD when request.
    var shouldShowHUD: Bool { get }
}

public final class MANetworkPlugin: PluginType {
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        guard let controller = target as? HUDController, controller.shouldShowHUD == true else {
            return
        }
        ThemeHUD.showActivityIndicator()
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        ThemeHUD.hideActivityIndicator()
    }
    
    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}
