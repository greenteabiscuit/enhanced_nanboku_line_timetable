//
//  enhanced_tokyo_timetable_widget.swift
//  enhanced_tokyo_timetable_widget
//
//  Created by lvcha mmm on 2023/12/13.
//

import WidgetKit
import SwiftUI

// Define the class with two Int fields: hour and min
class TimePoint {
    var hour: Int
    var min: Int
    var date: Date
    var dest: String
    
    init(hour: Int, min: Int, dest: String) {
        let today = Calendar.current.startOfDay(for: Date())
        self.hour = hour
        self.min = min
        self.date = Calendar.current.date(bySettingHour: hour, minute: min, second: 0, of: today)!
        self.dest = dest
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.placeholder)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let seconds = Calendar.current.component(.second, from: currentDate)
        let startDate = Calendar.current.date(byAdding: .second, value: -seconds, to: currentDate)!
        
        let entries = (0 ..< 60).map {
            let date = Calendar.current.date(byAdding: .second, value: $0 * 60 - 1, to: startDate)!
            let otherDate = Calendar.current.date(byAdding: .second, value: $0 * 60, to: startDate)!
            let calendar = Calendar.current
            let components = calendar.dateComponents([.weekday], from: otherDate)
            
            let weekday = components.weekday
            if weekday == 1 || weekday == 7 {
                let (first, second) = Provider.getNextWeekendSchedule(now: otherDate)
                return Entry(date: date, closestDate: first, secondClosestDate: second)
            }
            // weekday
            let (first, second) = Provider.getNextSchedule(now: otherDate)
            return Entry(date: date, closestDate: first, secondClosestDate: second)
        }
        completion(.init(entries: entries, policy: .atEnd))
    }
    
    static var weekdaySchedule: [[TimePoint]] = [
        [TimePoint(hour: 15, min: 13, dest: "六本木一丁目"), TimePoint(hour: 15, min: 17, dest: "永田町"), TimePoint(hour: 15, min: 23, dest: "飯田橋"), TimePoint(hour: 15, min: 28, dest: "東大前")],
        [TimePoint(hour: 15, min: 25, dest: "六本木一丁目"), TimePoint(hour: 15, min: 29, dest: "永田町"), TimePoint(hour: 15, min: 35, dest: "飯田橋"), TimePoint(hour: 15, min: 41, dest: "東大前")],
        [TimePoint(hour: 15, min: 37, dest: "六本木一丁目"), TimePoint(hour: 15, min: 41, dest: "永田町"), TimePoint(hour: 15, min: 47, dest: "飯田橋"), TimePoint(hour: 15, min: 52, dest: "東大前")],
        [TimePoint(hour: 15, min: 49, dest: "六本木一丁目"), TimePoint(hour: 15, min: 53, dest: "永田町"), TimePoint(hour: 15, min: 59, dest: "飯田橋"), TimePoint(hour: 16, min: 04, dest: "東大前")],
        [TimePoint(hour: 16, min: 01, dest: "六本木一丁目"), TimePoint(hour: 16, min: 05, dest: "永田町"), TimePoint(hour: 16, min: 11, dest: "飯田橋"), TimePoint(hour: 16, min: 16, dest: "東大前")],
        [TimePoint(hour: 16, min: 19, dest: "六本木一丁目"), TimePoint(hour: 16, min: 23, dest: "永田町"), TimePoint(hour: 16, min: 29, dest: "飯田橋"), TimePoint(hour: 16, min: 34, dest: "東大前")],
        [TimePoint(hour: 19, min: 41, dest: "六本木一丁目"), TimePoint(hour: 19, min: 45, dest: "永田町"), TimePoint(hour: 19, min: 52, dest: "飯田橋"), TimePoint(hour: 19, min: 57, dest: "東大前")],
        [TimePoint(hour: 20, min: 27, dest: "六本木一丁目"), TimePoint(hour: 20, min: 31, dest: "永田町"), TimePoint(hour: 20, min: 37, dest: "飯田橋"), TimePoint(hour: 20, min: 43, dest: "東大前")],
        [TimePoint(hour: 21, min: 0, dest: "六本木一丁目"), TimePoint(hour: 21, min: 4, dest: "永田町"), TimePoint(hour: 21, min: 11, dest: "飯田橋"), TimePoint(hour: 21, min: 16, dest: "東大前")],
        [TimePoint(hour: 22, min: 00, dest: "六本木一丁目"), TimePoint(hour: 22, min: 04, dest: "永田町"), TimePoint(hour: 22, min: 10, dest: "飯田橋"), TimePoint(hour: 22, min: 16, dest: "東大前")],
        [TimePoint(hour: 22, min: 41, dest: "六本木一丁目"), TimePoint(hour: 22, min: 45, dest: "永田町"), TimePoint(hour: 22, min: 51, dest: "飯田橋"), TimePoint(hour: 22, min: 56, dest: "東大前")],
        [TimePoint(hour: 23, min: 19, dest: "六本木一丁目"), TimePoint(hour: 23, min: 23, dest: "永田町"), TimePoint(hour: 23, min: 29, dest: "飯田橋"), TimePoint(hour: 23, min: 35, dest: "東大前")]
    ]

    static var weekendSchedule: [[TimePoint]] = [
        [TimePoint(hour: 5, min: 11, dest: "六本木一丁目"),
        TimePoint(hour: 5, min: 15, dest: "永田町"),
        TimePoint(hour: 5, min: 21, dest: "飯田橋"),
        TimePoint(hour: 5, min: 26, dest: "東大前")],
        [TimePoint(hour: 5, min: 38, dest: "六本木一丁目"),
        TimePoint(hour: 5, min: 42, dest: "永田町"),
        TimePoint(hour: 5, min: 48, dest: "飯田橋"),
        TimePoint(hour: 5, min: 53, dest: "東大前")],
        [TimePoint(hour: 6, min: 10, dest: "六本木一丁目"),
        TimePoint(hour: 6, min: 14, dest: "永田町"),
        TimePoint(hour: 6, min: 20, dest: "飯田橋"),
        TimePoint(hour: 6, min: 25, dest: "東大前")],
        [TimePoint(hour: 6, min: 41, dest: "六本木一丁目"),
        TimePoint(hour: 6, min: 45, dest: "永田町"),
        TimePoint(hour: 6, min: 51, dest: "飯田橋"),
        TimePoint(hour: 6, min: 56, dest: "東大前")],
        [TimePoint(hour: 6, min: 50, dest: "六本木一丁目"),
        TimePoint(hour: 6, min: 54, dest: "永田町"),
        TimePoint(hour: 7, min: 0, dest: "飯田橋"),
        TimePoint(hour: 7, min: 6, dest: "東大前")],
        [TimePoint(hour: 7, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 7, min: 29, dest: "永田町"),
        TimePoint(hour: 7, min: 35, dest: "飯田橋"),
        TimePoint(hour: 7, min: 40, dest: "東大前")],
        [TimePoint(hour: 7, min: 32, dest: "六本木一丁目"),
        TimePoint(hour: 7, min: 36, dest: "永田町"),
        TimePoint(hour: 7, min: 42, dest: "飯田橋"),
        TimePoint(hour: 7, min: 47, dest: "東大前")],
        [TimePoint(hour: 7, min: 38, dest: "六本木一丁目"),
        TimePoint(hour: 7, min: 42, dest: "永田町"),
        TimePoint(hour: 7, min: 48, dest: "飯田橋"),
        TimePoint(hour: 7, min: 53, dest: "東大前")],
        [TimePoint(hour: 8, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 8, min: 17, dest: "永田町"),
        TimePoint(hour: 8, min: 24, dest: "飯田橋"),
        TimePoint(hour: 8, min: 29, dest: "東大前")],
        [TimePoint(hour: 8, min: 34, dest: "六本木一丁目"),
        TimePoint(hour: 8, min: 38, dest: "永田町"),
        TimePoint(hour: 8, min: 44, dest: "飯田橋"),
        TimePoint(hour: 8, min: 49, dest: "東大前")],
        [TimePoint(hour: 8, min: 39, dest: "六本木一丁目"),
        TimePoint(hour: 8, min: 43, dest: "永田町"),
        TimePoint(hour: 8, min: 49, dest: "飯田橋"),
        TimePoint(hour: 8, min: 54, dest: "東大前")],
        [TimePoint(hour: 8, min: 44, dest: "六本木一丁目"),
        TimePoint(hour: 8, min: 48, dest: "永田町"),
        TimePoint(hour: 8, min: 54, dest: "飯田橋"),
        TimePoint(hour: 8, min: 59, dest: "東大前")],
        [TimePoint(hour: 8, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 8, min: 53, dest: "永田町"),
        TimePoint(hour: 8, min: 59, dest: "飯田橋"),
        TimePoint(hour: 9, min: 4, dest: "東大前")],
        [TimePoint(hour: 8, min: 54, dest: "六本木一丁目"),
        TimePoint(hour: 8, min: 58, dest: "永田町"),
        TimePoint(hour: 9, min: 4, dest: "飯田橋"),
        TimePoint(hour: 9, min: 9, dest: "東大前")],
        [TimePoint(hour: 8, min: 59, dest: "六本木一丁目"),
        TimePoint(hour: 9, min: 3, dest: "永田町"),
        TimePoint(hour: 9, min: 9, dest: "飯田橋"),
        TimePoint(hour: 9, min: 14, dest: "東大前")],
        [TimePoint(hour: 9, min: 9, dest: "六本木一丁目"),
        TimePoint(hour: 9, min: 13, dest: "永田町"),
        TimePoint(hour: 9, min: 19, dest: "飯田橋"),
        TimePoint(hour: 9, min: 24, dest: "東大前")],
        [TimePoint(hour: 9, min: 18, dest: "六本木一丁目"),
        TimePoint(hour: 9, min: 22, dest: "永田町"),
        TimePoint(hour: 9, min: 28, dest: "飯田橋"),
        TimePoint(hour: 9, min: 33, dest: "東大前")],
        [TimePoint(hour: 9, min: 23, dest: "六本木一丁目"),
        TimePoint(hour: 9, min: 27, dest: "永田町"),
        TimePoint(hour: 9, min: 33, dest: "飯田橋"),
        TimePoint(hour: 9, min: 38, dest: "東大前")],
        [TimePoint(hour: 9, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 9, min: 41, dest: "永田町"),
        TimePoint(hour: 9, min: 48, dest: "飯田橋"),
        TimePoint(hour: 9, min: 53, dest: "東大前")],
        [TimePoint(hour: 9, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 9, min: 47, dest: "永田町"),
        TimePoint(hour: 9, min: 54, dest: "飯田橋"),
        TimePoint(hour: 9, min: 59, dest: "東大前")],
        [TimePoint(hour: 9, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 9, min: 53, dest: "永田町"),
        TimePoint(hour: 10, min: 0, dest: "飯田橋"),
        TimePoint(hour: 10, min: 5, dest: "東大前")],
        [TimePoint(hour: 10, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 10, min: 5, dest: "永田町"),
        TimePoint(hour: 10, min: 12, dest: "飯田橋"),
        TimePoint(hour: 10, min: 17, dest: "東大前")],
        [TimePoint(hour: 10, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 10, min: 11, dest: "永田町"),
        TimePoint(hour: 10, min: 18, dest: "飯田橋"),
        TimePoint(hour: 10, min: 23, dest: "東大前")],
        [TimePoint(hour: 10, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 10, min: 17, dest: "永田町"),
        TimePoint(hour: 10, min: 24, dest: "飯田橋"),
        TimePoint(hour: 10, min: 29, dest: "東大前")],
        [TimePoint(hour: 10, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 10, min: 29, dest: "永田町"),
        TimePoint(hour: 10, min: 36, dest: "飯田橋"),
        TimePoint(hour: 10, min: 41, dest: "東大前")],
        [TimePoint(hour: 10, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 10, min: 41, dest: "永田町"),
        TimePoint(hour: 10, min: 48, dest: "飯田橋"),
        TimePoint(hour: 10, min: 53, dest: "東大前")],
        [TimePoint(hour: 10, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 10, min: 47, dest: "永田町"),
        TimePoint(hour: 10, min: 54, dest: "飯田橋"),
        TimePoint(hour: 10, min: 59, dest: "東大前")],
        [TimePoint(hour: 10, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 10, min: 53, dest: "永田町"),
        TimePoint(hour: 11, min: 0, dest: "飯田橋"),
        TimePoint(hour: 11, min: 5, dest: "東大前")],
        [TimePoint(hour: 11, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 11, min: 5, dest: "永田町"),
        TimePoint(hour: 11, min: 12, dest: "飯田橋"),
        TimePoint(hour: 11, min: 17, dest: "東大前")],
        [TimePoint(hour: 11, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 11, min: 11, dest: "永田町"),
        TimePoint(hour: 11, min: 18, dest: "飯田橋"),
        TimePoint(hour: 11, min: 23, dest: "東大前")],
        [TimePoint(hour: 11, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 11, min: 17, dest: "永田町"),
        TimePoint(hour: 11, min: 24, dest: "飯田橋"),
        TimePoint(hour: 11, min: 29, dest: "東大前")],
        [TimePoint(hour: 11, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 11, min: 29, dest: "永田町"),
        TimePoint(hour: 11, min: 36, dest: "飯田橋"),
        TimePoint(hour: 11, min: 41, dest: "東大前")],
        [TimePoint(hour: 11, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 11, min: 41, dest: "永田町"),
        TimePoint(hour: 11, min: 48, dest: "飯田橋"),
        TimePoint(hour: 11, min: 53, dest: "東大前")],
        [TimePoint(hour: 11, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 11, min: 47, dest: "永田町"),
        TimePoint(hour: 11, min: 54, dest: "飯田橋"),
        TimePoint(hour: 11, min: 59, dest: "東大前")],
        [TimePoint(hour: 11, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 11, min: 53, dest: "永田町"),
        TimePoint(hour: 12, min: 0, dest: "飯田橋"),
        TimePoint(hour: 12, min: 5, dest: "東大前")],
        [TimePoint(hour: 12, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 12, min: 5, dest: "永田町"),
        TimePoint(hour: 12, min: 12, dest: "飯田橋"),
        TimePoint(hour: 12, min: 17, dest: "東大前")],
        [TimePoint(hour: 12, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 12, min: 11, dest: "永田町"),
        TimePoint(hour: 12, min: 18, dest: "飯田橋"),
        TimePoint(hour: 12, min: 23, dest: "東大前")],
        [TimePoint(hour: 12, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 12, min: 17, dest: "永田町"),
        TimePoint(hour: 12, min: 24, dest: "飯田橋"),
        TimePoint(hour: 12, min: 29, dest: "東大前")],
        [TimePoint(hour: 12, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 12, min: 29, dest: "永田町"),
        TimePoint(hour: 12, min: 36, dest: "飯田橋"),
        TimePoint(hour: 12, min: 41, dest: "東大前")],
        [TimePoint(hour: 12, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 12, min: 41, dest: "永田町"),
        TimePoint(hour: 12, min: 48, dest: "飯田橋"),
        TimePoint(hour: 12, min: 53, dest: "東大前")],
        [TimePoint(hour: 12, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 12, min: 47, dest: "永田町"),
        TimePoint(hour: 12, min: 54, dest: "飯田橋"),
        TimePoint(hour: 12, min: 59, dest: "東大前")],
        [TimePoint(hour: 12, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 12, min: 53, dest: "永田町"),
        TimePoint(hour: 13, min: 0, dest: "飯田橋"),
        TimePoint(hour: 13, min: 5, dest: "東大前")],
        [TimePoint(hour: 13, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 13, min: 5, dest: "永田町"),
        TimePoint(hour: 13, min: 12, dest: "飯田橋"),
        TimePoint(hour: 13, min: 17, dest: "東大前")],
        [TimePoint(hour: 13, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 13, min: 11, dest: "永田町"),
        TimePoint(hour: 13, min: 18, dest: "飯田橋"),
        TimePoint(hour: 13, min: 23, dest: "東大前")],
        [TimePoint(hour: 13, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 13, min: 17, dest: "永田町"),
        TimePoint(hour: 13, min: 24, dest: "飯田橋"),
        TimePoint(hour: 13, min: 29, dest: "東大前")],
        [TimePoint(hour: 13, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 13, min: 29, dest: "永田町"),
        TimePoint(hour: 13, min: 36, dest: "飯田橋"),
        TimePoint(hour: 13, min: 41, dest: "東大前")],
        [TimePoint(hour: 13, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 13, min: 41, dest: "永田町"),
        TimePoint(hour: 13, min: 48, dest: "飯田橋"),
        TimePoint(hour: 13, min: 53, dest: "東大前")],
        [TimePoint(hour: 13, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 13, min: 47, dest: "永田町"),
        TimePoint(hour: 13, min: 54, dest: "飯田橋"),
        TimePoint(hour: 13, min: 59, dest: "東大前")],
        [TimePoint(hour: 13, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 13, min: 53, dest: "永田町"),
        TimePoint(hour: 14, min: 0, dest: "飯田橋"),
        TimePoint(hour: 14, min: 5, dest: "東大前")],
        [TimePoint(hour: 14, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 14, min: 5, dest: "永田町"),
        TimePoint(hour: 14, min: 12, dest: "飯田橋"),
        TimePoint(hour: 14, min: 17, dest: "東大前")],
        [TimePoint(hour: 14, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 14, min: 11, dest: "永田町"),
        TimePoint(hour: 14, min: 18, dest: "飯田橋"),
        TimePoint(hour: 14, min: 23, dest: "東大前")],
        [TimePoint(hour: 14, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 14, min: 17, dest: "永田町"),
        TimePoint(hour: 14, min: 24, dest: "飯田橋"),
        TimePoint(hour: 14, min: 29, dest: "東大前")],
        [TimePoint(hour: 14, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 14, min: 29, dest: "永田町"),
        TimePoint(hour: 14, min: 36, dest: "飯田橋"),
        TimePoint(hour: 14, min: 41, dest: "東大前")],
        [TimePoint(hour: 14, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 14, min: 41, dest: "永田町"),
        TimePoint(hour: 14, min: 48, dest: "飯田橋"),
        TimePoint(hour: 14, min: 53, dest: "東大前")],
        [TimePoint(hour: 14, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 14, min: 47, dest: "永田町"),
        TimePoint(hour: 14, min: 54, dest: "飯田橋"),
        TimePoint(hour: 14, min: 59, dest: "東大前")],
        [TimePoint(hour: 14, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 14, min: 53, dest: "永田町"),
        TimePoint(hour: 15, min: 0, dest: "飯田橋"),
        TimePoint(hour: 15, min: 5, dest: "東大前")],
        [TimePoint(hour: 15, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 15, min: 5, dest: "永田町"),
        TimePoint(hour: 15, min: 12, dest: "飯田橋"),
        TimePoint(hour: 15, min: 17, dest: "東大前")],
        [TimePoint(hour: 15, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 15, min: 11, dest: "永田町"),
        TimePoint(hour: 15, min: 18, dest: "飯田橋"),
        TimePoint(hour: 15, min: 23, dest: "東大前")],
        [TimePoint(hour: 15, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 15, min: 17, dest: "永田町"),
        TimePoint(hour: 15, min: 24, dest: "飯田橋"),
        TimePoint(hour: 15, min: 29, dest: "東大前")],
        [TimePoint(hour: 15, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 15, min: 29, dest: "永田町"),
        TimePoint(hour: 15, min: 36, dest: "飯田橋"),
        TimePoint(hour: 15, min: 41, dest: "東大前")],
        [TimePoint(hour: 15, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 15, min: 41, dest: "永田町"),
        TimePoint(hour: 15, min: 48, dest: "飯田橋"),
        TimePoint(hour: 15, min: 53, dest: "東大前")],
        [TimePoint(hour: 15, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 15, min: 47, dest: "永田町"),
        TimePoint(hour: 15, min: 54, dest: "飯田橋"),
        TimePoint(hour: 15, min: 59, dest: "東大前")],
        [TimePoint(hour: 15, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 15, min: 53, dest: "永田町"),
        TimePoint(hour: 16, min: 0, dest: "飯田橋"),
        TimePoint(hour: 16, min: 5, dest: "東大前")],
        [TimePoint(hour: 16, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 16, min: 5, dest: "永田町"),
        TimePoint(hour: 16, min: 12, dest: "飯田橋"),
        TimePoint(hour: 16, min: 17, dest: "東大前")],
        [TimePoint(hour: 16, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 16, min: 11, dest: "永田町"),
        TimePoint(hour: 16, min: 18, dest: "飯田橋"),
        TimePoint(hour: 16, min: 23, dest: "東大前")],
        [TimePoint(hour: 16, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 16, min: 17, dest: "永田町"),
        TimePoint(hour: 16, min: 24, dest: "飯田橋"),
        TimePoint(hour: 16, min: 29, dest: "東大前")],
        [TimePoint(hour: 16, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 16, min: 29, dest: "永田町"),
        TimePoint(hour: 16, min: 36, dest: "飯田橋"),
        TimePoint(hour: 16, min: 41, dest: "東大前")],
        [TimePoint(hour: 16, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 16, min: 41, dest: "永田町"),
        TimePoint(hour: 16, min: 48, dest: "飯田橋"),
        TimePoint(hour: 16, min: 53, dest: "東大前")],
        [TimePoint(hour: 16, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 16, min: 47, dest: "永田町"),
        TimePoint(hour: 16, min: 54, dest: "飯田橋"),
        TimePoint(hour: 16, min: 59, dest: "東大前")],
        [TimePoint(hour: 16, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 16, min: 53, dest: "永田町"),
        TimePoint(hour: 17, min: 0, dest: "飯田橋"),
        TimePoint(hour: 17, min: 5, dest: "東大前")],
        [TimePoint(hour: 17, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 17, min: 5, dest: "永田町"),
        TimePoint(hour: 17, min: 12, dest: "飯田橋"),
        TimePoint(hour: 17, min: 17, dest: "東大前")],
        [TimePoint(hour: 17, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 17, min: 11, dest: "永田町"),
        TimePoint(hour: 17, min: 18, dest: "飯田橋"),
        TimePoint(hour: 17, min: 23, dest: "東大前")],
        [TimePoint(hour: 17, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 17, min: 17, dest: "永田町"),
        TimePoint(hour: 17, min: 24, dest: "飯田橋"),
        TimePoint(hour: 17, min: 29, dest: "東大前")],
        [TimePoint(hour: 17, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 17, min: 29, dest: "永田町"),
        TimePoint(hour: 17, min: 36, dest: "飯田橋"),
        TimePoint(hour: 17, min: 41, dest: "東大前")],
        [TimePoint(hour: 17, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 17, min: 41, dest: "永田町"),
        TimePoint(hour: 17, min: 48, dest: "飯田橋"),
        TimePoint(hour: 17, min: 53, dest: "東大前")],
        [TimePoint(hour: 17, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 17, min: 47, dest: "永田町"),
        TimePoint(hour: 17, min: 54, dest: "飯田橋"),
        TimePoint(hour: 17, min: 59, dest: "東大前")],
        [TimePoint(hour: 17, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 17, min: 53, dest: "永田町"),
        TimePoint(hour: 18, min: 0, dest: "飯田橋"),
        TimePoint(hour: 18, min: 5, dest: "東大前")],
        [TimePoint(hour: 18, min: 1, dest: "六本木一丁目"),
        TimePoint(hour: 18, min: 5, dest: "永田町"),
        TimePoint(hour: 18, min: 12, dest: "飯田橋"),
        TimePoint(hour: 18, min: 17, dest: "東大前")],
        [TimePoint(hour: 18, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 18, min: 11, dest: "永田町"),
        TimePoint(hour: 18, min: 18, dest: "飯田橋"),
        TimePoint(hour: 18, min: 23, dest: "東大前")],
        [TimePoint(hour: 18, min: 13, dest: "六本木一丁目"),
        TimePoint(hour: 18, min: 17, dest: "永田町"),
        TimePoint(hour: 18, min: 24, dest: "飯田橋"),
        TimePoint(hour: 18, min: 29, dest: "東大前")],
        [TimePoint(hour: 18, min: 25, dest: "六本木一丁目"),
        TimePoint(hour: 18, min: 29, dest: "永田町"),
        TimePoint(hour: 18, min: 36, dest: "飯田橋"),
        TimePoint(hour: 18, min: 41, dest: "東大前")],
        [TimePoint(hour: 18, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 18, min: 41, dest: "永田町"),
        TimePoint(hour: 18, min: 48, dest: "飯田橋"),
        TimePoint(hour: 18, min: 53, dest: "東大前")],
        [TimePoint(hour: 18, min: 43, dest: "六本木一丁目"),
        TimePoint(hour: 18, min: 47, dest: "永田町"),
        TimePoint(hour: 18, min: 54, dest: "飯田橋"),
        TimePoint(hour: 18, min: 59, dest: "東大前")],
        [TimePoint(hour: 18, min: 49, dest: "六本木一丁目"),
        TimePoint(hour: 18, min: 53, dest: "永田町"),
        TimePoint(hour: 19, min: 0, dest: "飯田橋"),
        TimePoint(hour: 19, min: 5, dest: "東大前")],
        [TimePoint(hour: 19, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 19, min: 11, dest: "永田町"),
        TimePoint(hour: 19, min: 18, dest: "飯田橋"),
        TimePoint(hour: 19, min: 23, dest: "東大前")],
        [TimePoint(hour: 19, min: 14, dest: "六本木一丁目"),
        TimePoint(hour: 19, min: 17, dest: "永田町"),
        TimePoint(hour: 19, min: 24, dest: "飯田橋"),
        TimePoint(hour: 19, min: 29, dest: "東大前")],
        [TimePoint(hour: 19, min: 27, dest: "六本木一丁目"),
        TimePoint(hour: 19, min: 31, dest: "永田町"),
        TimePoint(hour: 19, min: 37, dest: "飯田橋"),
        TimePoint(hour: 19, min: 42, dest: "東大前")],
        [TimePoint(hour: 19, min: 47, dest: "六本木一丁目"),
        TimePoint(hour: 19, min: 51, dest: "永田町"),
        TimePoint(hour: 19, min: 57, dest: "飯田橋"),
        TimePoint(hour: 20, min: 2, dest: "東大前")],
        [TimePoint(hour: 19, min: 53, dest: "六本木一丁目"),
        TimePoint(hour: 19, min: 57, dest: "永田町"),
        TimePoint(hour: 20, min: 3, dest: "飯田橋"),
        TimePoint(hour: 20, min: 8, dest: "東大前")],
        [TimePoint(hour: 20, min: 0, dest: "六本木一丁目"),
        TimePoint(hour: 20, min: 4, dest: "永田町"),
        TimePoint(hour: 20, min: 10, dest: "飯田橋"),
        TimePoint(hour: 20, min: 15, dest: "東大前")],
        [TimePoint(hour: 20, min: 22, dest: "六本木一丁目"),
        TimePoint(hour: 20, min: 26, dest: "永田町"),
        TimePoint(hour: 20, min: 32, dest: "飯田橋"),
        TimePoint(hour: 20, min: 37, dest: "東大前")],
        [TimePoint(hour: 20, min: 29, dest: "六本木一丁目"),
        TimePoint(hour: 20, min: 33, dest: "永田町"),
        TimePoint(hour: 20, min: 40, dest: "飯田橋"),
        TimePoint(hour: 20, min: 45, dest: "東大前")],
        [TimePoint(hour: 20, min: 36, dest: "六本木一丁目"),
        TimePoint(hour: 20, min: 40, dest: "永田町"),
        TimePoint(hour: 20, min: 46, dest: "飯田橋"),
        TimePoint(hour: 20, min: 51, dest: "東大前")],
        [TimePoint(hour: 20, min: 51, dest: "六本木一丁目"),
        TimePoint(hour: 20, min: 55, dest: "永田町"),
        TimePoint(hour: 21, min: 2, dest: "飯田橋"),
        TimePoint(hour: 21, min: 7, dest: "東大前")],
        [TimePoint(hour: 21, min: 15, dest: "六本木一丁目"),
        TimePoint(hour: 21, min: 19, dest: "永田町"),
        TimePoint(hour: 21, min: 25, dest: "飯田橋"),
        TimePoint(hour: 21, min: 30, dest: "東大前")],
        [TimePoint(hour: 21, min: 22, dest: "六本木一丁目"),
        TimePoint(hour: 21, min: 26, dest: "永田町"),
        TimePoint(hour: 21, min: 32, dest: "飯田橋"),
        TimePoint(hour: 21, min: 37, dest: "東大前")],
        [TimePoint(hour: 21, min: 44, dest: "六本木一丁目"),
        TimePoint(hour: 21, min: 48, dest: "永田町"),
        TimePoint(hour: 21, min: 55, dest: "飯田橋"),
        TimePoint(hour: 22, min: 0, dest: "東大前")],
        [TimePoint(hour: 21, min: 51, dest: "六本木一丁目"),
        TimePoint(hour: 21, min: 55, dest: "永田町"),
        TimePoint(hour: 22, min: 2, dest: "飯田橋"),
        TimePoint(hour: 22, min: 7, dest: "東大前")],
        [TimePoint(hour: 22, min: 7, dest: "六本木一丁目"),
        TimePoint(hour: 22, min: 11, dest: "永田町"),
        TimePoint(hour: 22, min: 17, dest: "飯田橋"),
        TimePoint(hour: 22, min: 22, dest: "東大前")],
        [TimePoint(hour: 22, min: 23, dest: "六本木一丁目"),
        TimePoint(hour: 22, min: 27, dest: "永田町"),
        TimePoint(hour: 22, min: 34, dest: "飯田橋"),
        TimePoint(hour: 22, min: 39, dest: "東大前")],
        [TimePoint(hour: 22, min: 30, dest: "六本木一丁目"),
        TimePoint(hour: 22, min: 34, dest: "永田町"),
        TimePoint(hour: 22, min: 41, dest: "飯田橋"),
        TimePoint(hour: 22, min: 46, dest: "東大前")],
        [TimePoint(hour: 22, min: 37, dest: "六本木一丁目"),
        TimePoint(hour: 22, min: 41, dest: "永田町"),
        TimePoint(hour: 22, min: 47, dest: "飯田橋"),
        TimePoint(hour: 22, min: 52, dest: "東大前")],
        [TimePoint(hour: 22, min: 53, dest: "六本木一丁目"),
        TimePoint(hour: 22, min: 56, dest: "永田町"),
        TimePoint(hour: 23, min: 3, dest: "飯田橋"),
        TimePoint(hour: 23, min: 8, dest: "東大前")],
        [TimePoint(hour: 23, min: 0, dest: "六本木一丁目"),
        TimePoint(hour: 23, min: 3, dest: "永田町"),
        TimePoint(hour: 23, min: 10, dest: "飯田橋"),
        TimePoint(hour: 23, min: 15, dest: "東大前")],
        [TimePoint(hour: 23, min: 17, dest: "六本木一丁目"),
        TimePoint(hour: 23, min: 21, dest: "永田町"),
        TimePoint(hour: 23, min: 27, dest: "飯田橋"),
        TimePoint(hour: 23, min: 32, dest: "東大前")],
        [TimePoint(hour: 23, min: 26, dest: "六本木一丁目"),
        TimePoint(hour: 23, min: 30, dest: "永田町"),
        TimePoint(hour: 23, min: 36, dest: "飯田橋"),
        TimePoint(hour: 23, min: 41, dest: "東大前")],
        [TimePoint(hour: 23, min: 35, dest: "六本木一丁目"),
        TimePoint(hour: 23, min: 39, dest: "永田町"),
        TimePoint(hour: 23, min: 45, dest: "飯田橋"),
        TimePoint(hour: 23, min: 50, dest: "東大前")],
        [TimePoint(hour: 23, min: 51, dest: "六本木一丁目"),
        TimePoint(hour: 23, min: 54, dest: "永田町"),
        TimePoint(hour: 0, min: 1, dest: "飯田橋"),
        TimePoint(hour: 0, min: 6, dest: "東大前")],
        [TimePoint(hour: 23, min: 59, dest: "六本木一丁目"),
        TimePoint(hour: 0, min: 3, dest: "永田町"),
        TimePoint(hour: 0, min: 9, dest: "飯田橋"),
        TimePoint(hour: 0, min: 14, dest: "東大前")]
      ]
    
    // define function getNextSchedule
    // input: now: Date
    // output: (first: [TimePoint], second: [TimePoint])
    // iterate through all the first element in the weekdaySchedule, and find the first one that is later than now
    // if the first one is later than now, return the first one and the second one
    // if the first one is earlier than now, return the first one and the first one in the next schedule
    static func getNextSchedule(now: Date) -> ([TimePoint], [TimePoint]) {
        var first: [TimePoint] = []
        var second: [TimePoint] = []
        for (index, schedule) in weekdaySchedule.enumerated() {
            if schedule[schedule.count - 1].date > now {
                first = weekdaySchedule[index]
                second = weekdaySchedule[index + 1]
                break
            }
        }
        if first.isEmpty {
            first = weekdaySchedule[0]
            second = weekdaySchedule[1]
        }
        return (first, second)
    } 
    
    static func getNextWeekendSchedule(now: Date) -> ([TimePoint], [TimePoint]) {
        var first: [TimePoint] = []
        var second: [TimePoint] = []
        for (index, schedule) in weekendSchedule.enumerated() {
            if schedule[schedule.count - 1].date > now {
                first = weekendSchedule[index]
                second = weekendSchedule[index + 1]
                break
            }
        }
        if first.isEmpty {
            first = weekendSchedule[0]
            second = weekendSchedule[1]
        }
        return (first, second)
    }
}

struct Entry: TimelineEntry {
    var date: Date = .now
    var closestDate: [TimePoint] = []
    var secondClosestDate: [TimePoint] = []

    static var placeholder: Self {
        .init()
    }
}

struct enhanced_tokyo_timetable_widget: Widget {
    let kind: String = "enhanced_tokyo_timetable_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) {
            enhanced_tokyo_timetable_widgetEntryView(entry: $0)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemLarge) {
    enhanced_tokyo_timetable_widget()
} timeline: {
    Entry.placeholder
}
