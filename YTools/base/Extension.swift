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
    
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

extension Color {
    static var systemBackground: Color {
        if #available(iOS 15.0, *) {
            return Color(UIColor.systemBackground)
        } else {
            return Color.gray
        }
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

struct FrameGetter: ViewModifier {
    @Binding var frame: CGRect
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { proxy in
                createView(proxy)
            }
        )
    }
    
    private func createView(_ proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.frame = proxy.frame(in: .global)
        }
        return Rectangle().fill(Color.clear)
    }
}
