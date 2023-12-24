//
//  enhanced_tokyo_timetable_widget.swift
//  enhanced_tokyo_timetable_widget
//
//  Created by lvcha mmm on 2023/12/13.
//

import WidgetKit
import SwiftUI

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
        completion(.init(entries: [], policy: .atEnd))
    }
    
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
    
    static var weekdaySchedule: [[TimePoint]] = [
        [TimePoint(hour: 19, min: 41, dest: "六本木一丁目"), TimePoint(hour: 19, min: 45, dest: "永田町"), TimePoint(hour: 19, min: 52, dest: "飯田橋"), TimePoint(hour: 19, min: 57, dest: "東大前")],
        [TimePoint(hour: 21, min: 0, dest: "六本木一丁目"), TimePoint(hour: 21, min: 4, dest: "永田町"), TimePoint(hour: 21, min: 11, dest: "飯田橋"), TimePoint(hour: 21, min: 16, dest: "東大前")]
    ]
}

struct Entry: TimelineEntry {
    var date: Date = .now
    var closestDate: Date? = .now
    var secondClosestDate: Date? = .now

    static var placeholder: Self {
        .init()
    }
}
struct enhanced_tokyo_timetable_widgetEntryView : View {
    var entry: Provider.Entry

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
                Text("六本木一丁目")
                Text("永田町")
                Text("飯田橋")
                Text("東大前")
            }
            .font(.system(size: 16))
            
            // Number columns
            VStack(alignment: .leading, spacing: 41) {
                Text("19:41")
                Text("19:45")
                Text("19:52")
                Text("19:57")
            }
            .font(.system(size: 16))
        
            
            VStack(alignment: .leading, spacing: 41) {
                Text("21:00")
                Text("21:04")
                Text("21:11")
                Text("21:16")
            }
            .font(.system(size: 16))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct enhanced_tokyo_timetable_widget: Widget {
    let kind: String = "enhanced_tokyo_timetable_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) {
            enhanced_tokyo_timetable_widgetEntryView(entry: $0)
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
