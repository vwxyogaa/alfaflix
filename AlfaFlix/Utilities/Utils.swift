//
//  Utils.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation

class Utils: NSObject {
    static func convertDateSimple(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let tgl = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            return dateFormatter.string(from: tgl)
        }
        return date
    }
    
    static func convertDateToYearOnly(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let tgl = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "yyyy"
            
            return dateFormatter.string(from: tgl)
        }
        return date
    }
    
    static func convertDateToMonthDayDesc(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let tgl = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMMM dd"
            
            return dateFormatter.string(from: tgl)
        }
        return date
    }
    
    static func convertDateValidToDesc(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        if let tgl = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            return dateFormatter.string(from: tgl)
        }
        return date
    }
    
    static func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
}
