//
//  UIExtension.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/15.
//

import Foundation
import SwiftUI

extension View {
    func fillMaxSize() -> some View {
        return frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    
    func fillMaxWidth() -> some View {
        return frame(minWidth: 0, maxWidth: .infinity)
    }
    
    func fillMaxHeight() -> some View {
        return frame(minHeight: 0, maxHeight: .infinity)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
}
