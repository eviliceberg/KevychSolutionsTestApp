//
//  Date+Ext.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 20.06.2025.
//

import Foundation

extension Date {
    func toDayMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
}
