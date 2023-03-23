//
//  YWidgetsAttributes.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/23.
//

import Foundation
import SwiftUI
import ActivityKit

struct YWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }
    
    // Fixed non-changing properties about your activity go here!
    var name: String
}
