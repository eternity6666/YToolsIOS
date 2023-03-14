//
//  Utils.swift
//  YTools
//
//  Created by eternity6666 on 2022/12/12.
//

import Foundation
import SwiftUI

func randomColor() -> Color {
    let hue = Double(arc4random()) / Double(UInt32.max)
    return Color.init(hue: hue, saturation: 0.8, brightness: 0.8)
}
