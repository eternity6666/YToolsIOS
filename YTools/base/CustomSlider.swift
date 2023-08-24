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
    @State var lastCoordinateValue = 0.0
    var buttonColor = Color.white
    var background: AnyShapeStyle = AnyShapeStyle(.gray)
    
    var body: some View {
        GeometryReader { geo in
            let padding = 3.0
            let thumbSize = geo.size.height - padding * 2
            let radius = geo.size.height * 0.5
            
            ZStack {
                RoundedRectangle(cornerRadius: radius)
                    .fill(background)
                    .overlay {
                        
                    }
                
                HStack {
                    let viewWidth = geo.size.width - padding * 2 - thumbSize
                    Circle()
                        .foregroundColor(buttonColor)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(radius: 2)
                        .offset(x: CGFloat((self.value - Double(self.in.lowerBound)) / Double(self.in.count) * viewWidth))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    withAnimation {
                                        self.value = max(
                                            Double(self.in.lowerBound),
                                            min(
                                                Double(self.in.upperBound),
                                                Double(self.in.lowerBound) + Double(self.in.count) * v.location.x / (geo.size.width - padding * 2 - thumbSize)
                                            )
                                        )
                                    }
                                }
                        )
                    Spacer()
                }
                .padding(.all, padding)
            }
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
                                .init(red: 1.0, green: 0.5, blue: 0.0),
                                .init(red: 1.0, green: 1.0, blue: 1.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                )
                .frame(width: 300, height: 50)
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
