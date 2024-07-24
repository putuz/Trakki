//
//  CalendarUtils.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import Foundation

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}
