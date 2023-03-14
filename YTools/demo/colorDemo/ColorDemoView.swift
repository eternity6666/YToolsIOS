//
//  ColorDemoView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/13.
//

import SwiftUI

struct ColorDemoView: View {
    var body: some View {
        let frameSize = CGFloat(400)
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
                    let g = (h + l) / 2
                    let b = l
                    print("r=\(r) g=\(g) b=\(b)")
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
            
        }.frame(width: frameSize, height: frameSize)
    }
}

struct ColorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDemoView()
    }
}
