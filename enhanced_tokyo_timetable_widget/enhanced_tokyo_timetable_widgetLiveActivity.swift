//
//  enhanced_tokyo_timetable_widgetLiveActivity.swift
//  enhanced_tokyo_timetable_widget
//
//  Created by lvcha mmm on 2023/12/13.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct enhanced_tokyo_timetable_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct enhanced_tokyo_timetable_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: enhanced_tokyo_timetable_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension enhanced_tokyo_timetable_widgetAttributes {
    fileprivate static var preview: enhanced_tokyo_timetable_widgetAttributes {
        enhanced_tokyo_timetable_widgetAttributes(name: "World")
    }
}

extension enhanced_tokyo_timetable_widgetAttributes.ContentState {
    fileprivate static var smiley: enhanced_tokyo_timetable_widgetAttributes.ContentState {
        enhanced_tokyo_timetable_widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: enhanced_tokyo_timetable_widgetAttributes.ContentState {
         enhanced_tokyo_timetable_widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: enhanced_tokyo_timetable_widgetAttributes.preview) {
   enhanced_tokyo_timetable_widgetLiveActivity()
} contentStates: {
    enhanced_tokyo_timetable_widgetAttributes.ContentState.smiley
    enhanced_tokyo_timetable_widgetAttributes.ContentState.starEyes
}
