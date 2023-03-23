//
//  YToolsApp.swift
//  YTools
//
//  Created by eternity6666 on 2022/12/7.
//

import SwiftUI
import ActivityKit

@main
struct YToolsApp: App {
    var body: some Scene {
        WindowGroup {
            Button {
                startWidget()
            } label: {
                Text("start Live Activity")
            }

            NavigationView {
                ContentView()
            }
        }
    }
    
    func startWidget() {
        let data = YWidgetsAttributes(name: "yangzuohua")
        let state = YWidgetsAttributes.ContentState(value: 20)
        
        do {
            let deliveryActivity = try Activity<YWidgetsAttributes>.request(
                attributes: data,
                contentState: state,
                pushType: nil
            )
            print("try request Live Activity")
        } catch (let error) {
            print("\(error.localizedDescription)")
        }
    }
}
