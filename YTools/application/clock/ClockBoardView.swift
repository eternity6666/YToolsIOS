//
//  ClockBoardView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/24.
//

import SwiftUI

struct ClockBoardView: View {
    @Binding var time: ClockData
    var body: some View {
        ZStack {
            clockFaceView
            buildClockNeedle()
        }
    }
    
    var clockFaceView: some View {
        Canvas { context, size in
            let centerX = size.width * 0.5
            let centerY = size.height * 0.5
            let centerSize = 5.0
            context.fill(
                Path(
                    ellipseIn: CGRect(
                        x: centerX - centerSize * 0.5,
                        y: centerY - centerSize * 0.5,
                        width: centerSize,
                        height: centerSize
                    )
                ),
                with: .color(.black)
            )
            let diameter = min(size.width, size.height) * 0.9
            let radius = diameter * 0.5
            context.stroke(
                Circle().path(
                    in: CGRect(
                        x: centerX - radius,
                        y: centerY - radius,
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
            for i in 1 ..< 5 {
                let x = radius * 0.85 * sin(2 * Double.pi * Double(i) / 4)
                let y = -1 * radius * 0.85 * cos(2 * Double.pi * Double(i) / 4)
                context.draw(
                    Text("\(3 * i)"),
                    at: CGPoint(x: centerX + x, y: centerY + y),
                    anchor: .center
                )
            }
        }
    }
    
    private func buildClockNeedle() -> some View {
        return Canvas { context, size in
            let centerX = size.width * 0.5
            let centerY = size.height * 0.5
            let diameter = min(size.width, size.height) * 0.9
            let radius = diameter * 0.5
            
            context.draw(
                Text("\(time.hour):\(time.minute):\(time.second)"),
                at: CGPoint(x: centerX, y: centerY - radius * 0.3),
                anchor: .center
            )
            
            let hourPath = Path { path in
                path.move(to: CGPoint(x: centerX, y: centerY))
                let hour = Double(time.hour) + (Double(time.minute) + (Double(time.second) + Double(time.millisecond) / 1000) / 60) / 60
                let endX = centerX + 0.7 * radius * sin(2 * Double.pi * hour / 12)
                let endY = centerY - 0.7 * radius * cos(2 * Double.pi * hour / 12)
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            context.stroke(hourPath, with: .color(.red), lineWidth: 6.0)
            
            let minutePath = Path { path in
                path.move(to: CGPoint(x: centerX, y: centerY))
                let minute = Double(time.minute) + (Double(time.second) + Double(time.millisecond) / 1000) / 60
                let endX = centerX + 0.75 * radius * sin(2 * Double.pi * minute / 60)
                let endY = centerY - 0.75 * radius * cos(2 * Double.pi * minute / 60)
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            context.stroke(minutePath, with: .color(.black), lineWidth: 4.0)
            
            let secondPath = Path { path in
                path.move(to: CGPoint(x: centerX, y: centerY))
                let second = Double(time.second) + Double(time.millisecond) / 1000
                let endX = centerX + 0.8 * radius * sin(2 * Double.pi * second / 60)
                let endY = centerY - 0.8 * radius * cos(2 * Double.pi * second / 60)
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            context.stroke(secondPath, with: .color(.black), lineWidth: 2.0)
        }
    }
}
