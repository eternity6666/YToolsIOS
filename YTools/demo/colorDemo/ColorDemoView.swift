//
//  ColorDemoView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/13.
//

import SwiftUI

@available(iOS 15.0, *)
struct ColorDemoView: View {
    @State private var green: Int = 0
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            VStack {
                colorMainView
                    .padding()
                    .frame(width: size, height: size)
                HStack {
                    Text("0")
                        .font(.system(.title))
                        .onTapGesture {
                            green = max(green - 10, 0)
                        }
                    progressView.frame(
                        height: 20
                    )
                    Text("256")
                        .font(.system(.title))
                        .onTapGesture {
                            green = min(green + 10, 256)
                        }
                }.padding(
                    EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                )
            }
            .fillMaxSize()
        }
    }
    
    private var progressView: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let minSize = min(size.width, size.height)
                let ratio = 0.5
                context.fill(
                    RoundedRectangle(
                        cornerRadius: ratio * minSize
                    ).path(
                        in: CGRect(
                            origin: CGPoint(
                                x: 0,
                                y: size.height * (1 - ratio) * 0.5
                            ),
                            size: CGSize(
                                width: size.width,
                                height: size.height * ratio
                            )
                        )
                    ),
                    with: .linearGradient(
                        Gradient(colors: [
                            Color.init(red: 1.0, green: 1.0, blue: 1.0),
                            Color.init(red: 0.0, green: 1.0, blue: 0.0)
                        ]),
                        startPoint: .zero,
                        endPoint: CGPoint(x: size.width, y: size.height)
                    )
                )
                context.fill(
                    Circle().path(
                        in: CGRect(
                            origin: CGPoint(
                                x: CGFloat(green) * (size.width - minSize * 0.9) / 256, y: size.height * 0.05
                            ),
                            size: CGSize(
                                width: minSize * 0.9,
                                height: minSize * 0.9
                            )
                        )
                    ),
                    with: .color(.green)
                )
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newLocation = Int(value.location.x / geo.size.width * 256)
                        green = min(max(newLocation, 0), 256)
                    }
            )
        }
    }
    
    private var colorMainView: some View {
        Canvas { context, size in
            let ratio = 1
            let width = Int(size.width)
            let height = Int(size.height)
            let significandWidth = size.width.significandWidth
            let significandHeight = size.height.significandWidth
            let widthSize = width / significandWidth / ratio
            let heightSize = height / significandHeight / ratio
            for i in 0 ..< widthSize {
                for j in 0 ..< heightSize {
                    let h = Double(256 * i) / Double(widthSize)
                    let l = Double(256 * j) / Double(heightSize)
                    let r = h
                    let g = Double(green)
                    let b = l
                    let color = Color.init(
                        red: r / 256.0,
                        green: g / 256.0,
                        blue: b / 256
                    )
                    context.fill(
                        Rectangle().path(
                            in: CGRect(
                                x: i * significandWidth * ratio,
                                y: j * significandHeight * ratio,
                                width: significandWidth * ratio,
                                height: significandHeight * ratio
                            )
                        ),
                        with: .color(color)
                    )
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct ColorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDemoView()
    }
}
