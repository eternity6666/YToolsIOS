//
//  ClockMainView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/10.
//

import SwiftUI

struct ClockMainView: View {
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            VStack {
                ClockBoardView()
                    .frame(width: size * 0.9, height: size * 0.9)
            }
            .fillMaxSize()
        }.fillMaxSize()
    }
}

struct ClockBoardView: View {
    var body: some View {
        ZStack {
            buildClockFaceCanvas()
            buildClockNeedle()
        }.fillMaxSize()
    }
    
    private func buildClockFaceCanvas() -> some View {
        return Canvas { context, size in
            let centerX = size.width * 0.5
            let centerY = size.height * 0.5
            let centerSize = 5.0
            let diameter = min(size.width, size.height) * 0.9
            let radius = diameter / 2
            context.fill(
                Path(
                    ellipseIn: CGRect(
                        x: centerX - centerSize / 2,
                        y: centerY - centerSize / 2,
                        width: centerSize,
                        height: centerSize
                    )
                ),
                with: .color(.black)
            )
            context.stroke(
                Circle().path(
                    in: CGRect(
                        x: size.width * 0.05,
                        y: size.height * 0.05,
                        width: diameter,
                        height: diameter
                    )
                ),
                with: .color(.black),
                lineWidth: 2.0
            )
            for i in 0 ..< 60 {
                let startDx = radius * sin(2 * Double.pi * Double(i) / 60)
                let startDy = radius * cos(2 * Double.pi * Double(i) / 60)
                let startPoint = CGPoint(x: centerX + startDx, y: centerY + startDy)
                let endRatio = i % 5 == 0 ? 0.92 : 0.96
                let endPoint = CGPoint(x: centerX + endRatio * startDx, y: centerY + endRatio * startDy)
                let path = Path { path in
                    path.move(to: startPoint)
                    path.addLine(to: endPoint)
                }
                context.stroke(path, with: .color(.black), lineWidth: 2.0)
            }
        }
    }
    
    private func buildClockNeedle() -> some View {
        return Text("123")
    }
}

struct ClockMainView_Previews: PreviewProvider {
    static var previews: some View {
        ClockMainView()
    }
}
