//
//  ColorSelectorDemo.swift
//  YTools
//
//  Created by eternity6666 on 2023/8/23.
//

import SwiftUI

struct ColorSelectorDemo: View {
    @State private var red = 230.0
    @State private var green = 217.0
    @State private var blue = 204.0
    var body: some View {
        GeometryReader { geo in
            let dRed = red / 256.0
            let dGreen = green / 256.0
            let dBlue = blue / 256.0
            if (geo.size.width > geo.size.height) {
                HStack {
                    colorMainView(dRed: dRed, dGreen: dGreen, dBlue: dBlue)
                        .frame(height: geo.size.height)
                    VStack {
                        colorSelector(dRed: dRed, dGreen: dGreen, dBlue: dBlue)
                    }
                }
                .frame(maxWidth: geo.size.width * 0.8)
                .frame(maxWidth: .infinity)
            } else {
                VStack {
                    Spacer()
                    colorMainView(dRed: dRed, dGreen: dGreen, dBlue: dBlue)
                    colorSelector(dRed: dRed, dGreen: dGreen, dBlue: dBlue)
                    Spacer()
                }
                .frame(maxHeight: geo.size.height * 0.8)
                .frame(maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func colorMainView(dRed: Double, dGreen: Double, dBlue: Double) -> some View {
        Rectangle()
            .fill(Color.init(red: dRed, green: dGreen, blue: dBlue))
            .aspectRatio(1, contentMode: .fit)
            .padding(.all, 2)
            .overlay(alignment: .bottom) {
                let count = (dRed < 0.5 ? 1 : 0) + (dGreen < 0.5 ? 1 : 0) + (dBlue < 0.5 ? 1 : 0)
                let fontColor = (count > 1) ? Color.white : Color.black
                Text("Color(\(Int(red)), \(Int(green)), \(Int(blue)))")
                    .bold()
                    .foregroundColor(fontColor)
                    .padding()
            }
    }
    
    @ViewBuilder
    private func colorSelector(dRed: Double, dGreen: Double, dBlue: Double) -> some View {
        progressView(
            currentLength: $red,
            colors: [
                .init(red: 0.0, green: dGreen, blue: dBlue),
                .init(red: 1.0, green: dGreen, blue: dBlue)
            ]
        ) {
            Text("R")
                .bold()
        }
        progressView(
            currentLength: $green,
            colors: [
                .init(red: dRed, green: 0.0, blue: dBlue),
                .init(red: dRed, green: 1.0, blue: dBlue)
            ]
        ) {
            Text("G")
                .bold()
        }
        progressView(
            currentLength: $blue,
            colors: [
                .init(red: dRed, green: dGreen, blue: 0.0),
                .init(red: dRed, green: dGreen, blue: 1.0)
            ]
        ) {
            Text("B")
                .bold()
        }
    }
    
    @ViewBuilder
    private func progressView(
        currentLength: Binding<Double>,
        colors: [Color],
        leading: () -> some View = { EmptyView() }
    ) -> some View {
        HStack {
            leading()
            CustomSlider(
                value: currentLength,
                in: 0...256,
                background: AnyShapeStyle(
                    .linearGradient(
                        colors: colors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            )
            .frame(height: 30)
        }
        .padding(.horizontal, 8)
    }
}

struct ColorSelectorDemo_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectorDemo()
    }
}

