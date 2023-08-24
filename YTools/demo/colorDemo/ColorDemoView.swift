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
    @State private var rect: CGRect = .zero
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            VStack {
                colorMainView
                    .frameGetter($rect)
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
                Button {
                    saveAndShare(
                        img: UIApplication.shared.windows[0].rootViewController?.view.asImage(
                            rect: rect
                        )
                    )
                } label: {
                    Text("分享")
                }

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
            let ratio = 1.0
            let width = size.width
            let height = size.height
            let significandWidth = Double(size.width.significandWidth)
            let significandHeight = Double(size.height.significandWidth)
            let widthSize = width / significandWidth / ratio
            let heightSize = height / significandHeight / ratio
            for i in stride(from: 0, through: widthSize, by: 0.5) {
                for j in stride(from: 0, through: heightSize, by: 0.5) {
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

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

@available(iOS 15.0, *)
struct ColorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDemoView()
    }
}
