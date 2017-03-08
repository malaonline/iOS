//
//  OperatorOverload.swift
//  mala-ios
//
//  Created by Elors on 12/23/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

///  Compare Tuple With NSIndexPath 
///
///  - parameter FirIndexPath: NSIndexPath Object (like {section:0, row:0})
///  - parameter SecIndexPath: Tuple (like (0,0))
///
///  - returns: Bool
func ==(firIndexPath: IndexPath, secIndexPath: (section: Int, row: Int)) -> Bool {
    return firIndexPath.section == secIndexPath.section && firIndexPath.row == secIndexPath.row
}


/// Compare Custom Array With Empty Array
///
/// - parameter FirArray: Custom Model Array
/// - parameter SecArray: Empty Array
///
/// - returns: Bool
func !=(firArray: [[ClassScheduleDayModel]], secArray: [Any]) -> Bool {
    if firArray.count == 0 {
        return false
    }
    return true
}

///  Random Number
///
///  - parameter range: range
///
///  - returns: Int
func randomInRange(_ range: Range<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound)
    return  Int(arc4random_uniform(count)) + range.lowerBound
}

func ==<T>(lhs: Listener<T>, rhs: Listener<T>) -> Bool {
    return lhs.name == rhs.name
}


// MARK: - Auto
func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
