//
//  Extensions.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import SwiftUI

extension Int {
    // function to convert time to Hours:Minutes:Seconds format
    func asUniversalTime(style: DateComponentsFormatter.UnitsStyle) -> (String,String) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let travelTime = Calendar.current.date(byAdding: .second, value: self, to: Date())!
        return (formatter.string(from: Double(self)) ?? "", timeFormatter.string(from: travelTime))
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
