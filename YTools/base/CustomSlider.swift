//
//  CustomSlide.swift
//  YTools
//
//  Created by eternity6666 on 2023/8/23.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var value: Double
    var `in`: ClosedRange<Int>
    var buttonColor = Color.white
    var background: AnyShapeStyle = AnyShapeStyle(.gray)
    
    var body: some View {
        GeometryReader { geo in
            let padding = 3.0
            let minSize = min(geo.size.width, geo.size.height)
            let buttonSize = minSize - padding * 2
            let radius = minSize * 0.5
            
            ZStack {
                let viewWidth = geo.size.width - padding * 2 - buttonSize
                RoundedRectangle(cornerRadius: radius)
                    .fill(background)
                    .onTapGesture { location in
                        print("点击 RoundedRectangle \(location)")
                        updateValue(
                            location: location,
                            geo: geo,
                            padding: padding,
                            buttonSize: buttonSize,
                            viewWidth: viewWidth
                        )
                    }
                
                HStack {
                    Circle()
                        .foregroundColor(buttonColor)
                        .frame(width: buttonSize, height: buttonSize)
                        .shadow(radius: 2)
                        .offset(x: CGFloat((self.value - Double(self.in.lowerBound)) / Double(self.in.count) * viewWidth))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    updateValue(
                                        location: v.location,
                                        geo: geo,
                                        padding: padding,
                                        buttonSize: buttonSize,
                                        viewWidth: viewWidth
                                    )
                                }
                        )
                    Spacer()
                }
                .padding(.all, padding)
            }
        }
    }
    
    private func updateValue(
        location: CGPoint,
        geo: GeometryProxy,
        padding: Double,
        buttonSize: Double,
        viewWidth: Double
    ) {
        let x = max(padding + buttonSize / 2, min(geo.size.width - padding * 2, location.x))
        withAnimation {
            self.value = max(
                Double(self.in.lowerBound),
                min(
                    Double(self.in.upperBound),
                    Double(self.in.lowerBound) + Double(self.in.count) * (x - buttonSize / 2 - padding) / viewWidth
                )
            )
        }
    }
}

struct CustomSlider_Previews: PreviewProvider {
    struct CustomSliderDemo: View {
        @State private var value = 256.0
        var body: some View {
            VStack {
                CustomSlider(
                    value: $value,
                    in: 0...256,
                    background: AnyShapeStyle(
                        LinearGradient.linearGradient(
                            colors: [
                                .init(red: 1.0, green: 0.5, blue: 0.5),
                                .init(red: 0.5, green: 1.0, blue: 1.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                )
                .frame(width: 256.0 + 3.0 * 2, height: 50)
                Text("\(value)")
                    .frame(height: 300)
                    .frame(alignment: .bottom)
            }
        }
    }
    
    static var previews: some View {
        CustomSliderDemo()
    }
}
