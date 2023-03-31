//
//  ClockData.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/24.
//

import Foundation

struct ClockData {
    var hour: Int
    var minute: Int
    var second: Int
    var millisecond: Int
    
    static let zero = ClockData(hour: 0, minute: 0, second: 0, millisecond: 0)
    
    init(hour: Int, minute: Int, second: Int, millisecond: Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
    }
    
    init(time: Date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH mm ss SSS"
        let strNowTime = timeFormatter.string(from: time)
        let list = strNowTime.split(separator: .init(" "))
        if (list.count == 4) {
            self.hour = Int(list[0]) ?? 0
            self.minute = Int(list[1]) ?? 0
            self.second = Int(list[2]) ?? 0
            self.millisecond = Int(list[3]) ?? 0
        } else {
            self.hour = 0
            self.minute = 0
            self.second = 0
            self.millisecond = 0
        }
    }
}
