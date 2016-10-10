//
//  PullToRefreshConst.swift
//  PullToRefreshSwift
//
//  Created by Yuji Hato on 12/11/14.
//
import UIKit

struct PullToRefreshConst {
    static let tag = 810
    static let alpha = false
    static let height: CGFloat = 60
    static let imageName: String = "pulltorefresharrow.png"
    static let animationDuration: Double = 0.4
    static let fixedTop = true // PullToRefreshView fixed Top
}

open class PullToRefreshOption {
    open var backgroundColor = UIColor.clear
    open var indicatorColor = UIColor.gray
    open var autoStopTime: Double = 0.7 // 0 is not auto stop
    open var fixedSectionHeader = false  // Update the content inset for fixed section headers
    
    public init() {
    }
}
