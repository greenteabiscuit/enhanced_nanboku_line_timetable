//
//  SwiftUIView.swift
//  enhanced_tokyo_timetable_widgetExtension
//
//  Created by lvcha mmm on 2024/02/07.
//

import SwiftUI

struct enhanced_tokyo_timetable_widgetEntryView : View {
    var entry: Entry

    func getDayMessage() -> String {
        let today = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: today)
        
        // Weekday is 1 for Sunday, 7 for Saturday
        if weekday == 1 || weekday == 7 {
            return "休日"
        } else {
            return "平日"
        }
    }
    
    var body: some View {
        HStack(alignment: .center, content: {
            Text(getDayMessage())
        })
        .padding(.top, 20)
        .font(.system(size: 16))
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
                ForEach(0..<4, id: \.self) { num in
                    if let date = entry.closestDate.indices.contains(num) ? entry.closestDate[num].date : nil {
                        Text(date, formatter: Self.dateFormatter)
                    }
                }
            }
            .font(.system(size: 16))
        
            
            VStack(alignment: .leading, spacing: 41) {
                ForEach(0..<4, id: \.self) { num in
                    if let date = entry.secondClosestDate.indices.contains(num) ? entry.secondClosestDate[num].date : nil {
                        Text(date, formatter: Self.dateFormatter)
                    }
                }
            }
            .font(.system(size: 16))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
