//
//  Extension+Date.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/9.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

extension Date {
    
    static let SecondsInWeek: Int = 604800
    static let SecondsInDay: Int = 86400
    static let SecondsInHour: Int = 3600
    
    
    /// Return a new `Date` by adding a week to this `Date`.
    ///
    /// - Parameter weeks: The value to add, in weeks.
    /// - Returns: Date
    func addingWeeks(_ weeks: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(Date.SecondsInWeek * weeks))
    }
    
    /// Return a new `Date` by adding a day to this `Date`.
    ///
    /// - Parameter days: The value to add, in days.
    /// - Returns: Date
    func addingDays(_ days: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(Date.SecondsInDay * days))
    }
    
    /// Return a new `Date` by adding a hour to this `Date`.
    ///
    /// - Parameter hours: The value to add, in hours.
    /// - Returns: Date
    func addingHours(_ hours: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(Date.SecondsInHour * hours))
    }
    
    /// Return a new `Date` by subtracting a week to this `Date`.
    ///
    /// - Parameter weeks: The value to subtract, in weeks.
    /// - Returns: Date
    func subtractingWeeks(_ weeks: Int) -> Date {
        return self.addingTimeInterval(-(TimeInterval(Date.SecondsInWeek * weeks)))
    }
    
    /// Return a new `Date` by subtracting a day to this `Date`.
    ///
    /// - Parameter days: The value to subtract, in days.
    /// - Returns: Date
    func subtractingDays(_ days: Int) -> Date {
        return self.addingTimeInterval(-(TimeInterval(Date.SecondsInDay * days)))
    }
    
    /// Return a new `Date` by subtracting a hour to this `Date`.
    ///
    /// - Parameter hours: The value to subtract, in hours.
    /// - Returns: Date
    func subtractingHours(_ hours: Int) -> Date {
        return self.addingTimeInterval(-(TimeInterval(Date.SecondsInHour * hours)))
    }
}
