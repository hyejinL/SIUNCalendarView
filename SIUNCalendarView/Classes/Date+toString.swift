//
//  Date+toString.swift
//  SIUNCalendarView
//
//  Created by 이혜진 on 2019. 2. 24..
//

import Foundation

extension Date {
    enum FormatType {
        case year
        case none
        case noDay
        
        var description: String {
            switch self {
            case .year:
                return "yyyy.MM.dd"
            case .none:
                return "MM.dd"
            case .noDay:
                return "yyyy.MM"
            }
        }
    }
    
    func toString(of type: FormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = type.description
        return dateFormatter.string(from: self)
    }
}
