//
//  MalaLog.swift
//  mala-ios
//
//  Created by 王新宇 on 2/25/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import Foundation

func println(_ object: Any) {
    #if USE_DEV_SERVER
        Swift.print(object)
    #endif
}
