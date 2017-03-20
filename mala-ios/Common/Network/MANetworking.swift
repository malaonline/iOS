//
//  MANetworking.swift
//  mala-ios
//
//  Created by 王新宇 on 13/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya

let MAProvider = MoyaProvider<MAAPI>(endpointClosure: endpointClosure, plugins: [MANetworkPlugin()])

extension MoyaProvider {
    public typealias JSON = [String: Any]
    public typealias failureHandler = ((MoyaError) -> Void)
}

extension Moya.Response {
    
    fileprivate func JSON() -> [String: Any]? {
        do {
            if let json = try self.mapJSON() as? [String: Any] {
                return json
            }else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

extension MoyaProvider {
    
    @discardableResult
    func sendRequest(_ target: MAAPI, failureHandler: failureHandler? = nil, completion: @escaping (JSON) -> Void) -> Cancellable {
        
        func defaultFailureHandler(_ error: MoyaError) {
            println("\n************************ MANetworking Failure ************************")
            println("Error: \(error)")
            if let errorMessage = error.errorDescription {
                println("ErrorMessage: >>>\(errorMessage)<<<\n")
            }
        }
        
        let _failureHandler = (failureHandler != nil) ? failureHandler! : defaultFailureHandler
        
        return MAProvider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    guard let json = try response.mapJSON() as? JSON else {
                        _failureHandler(MoyaError.jsonMapping(response))
                        return
                    }
                    completion(json)
                }catch {
                    _failureHandler(MoyaError.jsonMapping(response))
                }
            case let .failure(error):
                _failureHandler(error)
            }
        }
    }
}
