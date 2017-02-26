//
//  NSDate+Comparisons.swift
//  Emojr
//
//  Created by James on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension Date {
    func isGreaterThanDate(_ dateToCompare : Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    
    func isLessThanDate(_ dateToCompare : Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedAscending
    }
    
    func addDays(_ daysToAdd : Int) -> Date
    {
        let secondsInDays : TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        
        return self.addingTimeInterval(secondsInDays)
    }
    
    
    func addHours(_ hoursToAdd : Int) -> Date
    {
        let secondsInHours : TimeInterval = Double(hoursToAdd) * 60 * 60
        
        return self.addingTimeInterval(secondsInHours)
    }
}
