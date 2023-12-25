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
            let (first, second) = Provider.getNextSchedule(now: otherDate)
            return Entry(date: date, closestDate: first, secondClosestDate: second)
        }
        completion(.init(entries: entries, policy: .atEnd))
    }
    
    static var weekdaySchedule: [[TimePoint]] = [
        [TimePoint(hour: 19, min: 41, dest: "六本木一丁目"), TimePoint(hour: 19, min: 45, dest: "永田町"), TimePoint(hour: 19, min: 52, dest: "飯田橋"), TimePoint(hour: 19, min: 57, dest: "東大前")],
        [TimePoint(hour: 21, min: 0, dest: "六本木一丁目"), TimePoint(hour: 21, min: 4, dest: "永田町"), TimePoint(hour: 21, min: 11, dest: "飯田橋"), TimePoint(hour: 21, min: 16, dest: "東大前")]
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
        for schedule in weekdaySchedule {
            if schedule[0].date > now {
                first = schedule
                second = schedule
                break
            }
        }
        if first.isEmpty {
            first = weekdaySchedule[0]
            second = weekdaySchedule[1]
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
struct enhanced_tokyo_timetable_widgetEntryView : View {
    var entry: Entry

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // Line and circles
            ZStack {
                VStack { // Vertical line
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 45) { // Circles with background to hide the line
                    ForEach(0..<4, id: \.self) { _ in
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 1)
                            .background(Circle().fill(Color.white)) // Background circle to mask the line
                            .frame(width: 15, height: 15)
                    }
                }
            }
            .padding(.top, 50)
            .padding(.bottom, 50)

            // Texts next to the circles
            VStack(alignment: .leading, spacing: 41) {
                ForEach(0..<4, id: \.self) {
                    num in Text(String(entry.closestDate.isEmpty ? "" : entry.closestDate[num].dest))
                }
            }
            .font(.system(size: 16))
            
            // Number columns
            VStack(alignment: .leading, spacing: 41) {
                ForEach(0..<4, id: \.self) {
                    num in Text("\(entry.closestDate[num].date, formatter: Self.dateFormatter)")
                }
            }
            .font(.system(size: 16))
        
            
            VStack(alignment: .leading, spacing: 41) {
                ForEach(0..<4, id: \.self) {
                    num in Text("\(entry.closestDate[num].date, formatter: Self.dateFormatter)")
                }
            }
            .font(.system(size: 16))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
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
