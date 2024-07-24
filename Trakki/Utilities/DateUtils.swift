//
//  DateUtils.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import Foundation

struct DateUtils {
    static func getCurrentDateFormatted(format: String = "EEE, d MMM") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    static func formatDateString(_ dateString: String, from inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to outputFormat: String = "EEE, d MMM yyyy, h:mm a") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    static func startOfMonth(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
}
