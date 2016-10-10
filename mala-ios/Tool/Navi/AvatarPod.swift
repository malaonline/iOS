//
//  AvatarPod.swift
//  Navi
//
//  Created by NIX on 15/9/26.
//  Copyright © 2015年 nixWork. All rights reserved.
//

import UIKit

func ==(lhs: AvatarPod.Request, rhs: AvatarPod.Request) -> Bool {
    return lhs.key == rhs.key
}

open class AvatarPod {

    static let sharedInstance = AvatarPod()

    let cache = NSCache()

    public enum CacheType {
        case memory
        case disk
        case cloud
    }

    public typealias Completion = (_ finished: Bool, _ image: UIImage, _ cacheType: CacheType) -> Void

    struct Request: Equatable {

        let avatar: Avatar
        let completion: Completion

        var key: String {
            return avatar.key
        }
    }

    private struct RequestPool {

        private var requests: [Request]

        init() {

            self.requests = [Request]()
        }

        mutating func addRequest(_ request: Request) {

            requests.append(request)
        }

        func requestsWithURL(_ URL: Foundation.URL) -> [Request] {

            return requests.filter({ $0.avatar.URL == URL })
        }

        mutating func removeRequestsWithURL(_ URL: Foundation.URL) {

            let requestsToRemove = requests.filter({ $0.avatar.URL == URL })

            requestsToRemove.forEach({
                if let index = requests.index(of: $0) {
                    requests.remove(at: index)
                }
            })
        }

        mutating func removeAllRequests() {
            requests = []
        }
    }

    private var requestPool = RequestPool()

    private func completeRequest(_ request: Request, withStyledImage styledImage: UIImage, cacheType: CacheType) {

        DispatchQueue.main.async {
            request.completion(true, styledImage, cacheType)
        }

        cache.setObject(styledImage, forKey: request.key)
    }

    private let cacheQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)

    private func completeRequestsWithURL(_ URL: Foundation.URL, image: UIImage, cacheType: CacheType) {

        DispatchQueue.main.async {

            let requests = self.requestPool.requestsWithURL(URL)

            requests.forEach({ request in

                self.cacheQueue.async {

                    let styledImage = image.navi_avatarImageWithStyle(request.avatar.style)

                    self.completeRequest(request, withStyledImage: styledImage, cacheType: cacheType)

                    // save images to local

                    request.avatar.saveOriginalImage(image, styledImage: styledImage)
                }
            })

            self.requestPool.removeRequestsWithURL(URL)
        }
    }

    // MARK: - API

    open class func wakeAvatar(_ avatar: Avatar, completion: @escaping Completion) {

        guard let URL = avatar.URL else {

            completion(false, avatar.placeholderImage ?? UIImage(), .memory)

            return
        }

        let request = Request(avatar: avatar, completion: completion)

        let key = request.key

        if let image = sharedInstance.cache.object(forKey: key) as? UIImage {
            completion(finished: true, image: image, cacheType: .memory)

        } else {
            if let placeholderImage = avatar.placeholderImage {
                completion(false, placeholderImage, .memory)
            }

            sharedInstance.cacheQueue.async {

                if let styledImage = avatar.localStyledImage {
                    sharedInstance.completeRequest(request, withStyledImage: styledImage, cacheType: .disk)

                } else {
                    DispatchQueue.main.async {

                        sharedInstance.requestPool.addRequest(request)

                        if sharedInstance.requestPool.requestsWithURL(URL as URL).count > 1 {
                            // do nothing

                        } else {
                            sharedInstance.cacheQueue.async {

                                if let image = avatar.localOriginalImage {
                                    sharedInstance.completeRequestsWithURL(URL as URL, image: image, cacheType: .disk)

                                } else {
                                    if let data = try? Data(contentsOf: URL as URL), let image = UIImage(data: data) {
                                        sharedInstance.completeRequestsWithURL(URL as URL, image: image, cacheType: .cloud)

                                    } else {
                                        DispatchQueue.main.async {
                                            sharedInstance.requestPool.removeRequestsWithURL(URL as URL)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    open class func clear() {
        
        sharedInstance.requestPool.removeAllRequests()
        
        sharedInstance.cache.removeAllObjects()
    }
}

