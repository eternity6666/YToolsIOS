//
//  NineMainView.swift
//  YTools
//
//  Created by eternity6666 on 2022/12/12.
//

import SwiftUI

struct NineMainView: View {
    let pub = NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)
    
    @State private var colorList = Self.initColorList()
    
    init() {
        
    }
    
    var body: some View {
        VStack {
            ForEach(0..<3, id: \.self) { i in
                HStack() {
                    ForEach(0..<3, id: \.self) { j in
                        Button {
                            changeColorList()
                        } label: {
                            RoundedRectangle(cornerRadius: 15.0)
                                .frame(width: 100, height: 100)
                                .foregroundColor(colorList[i][j])
                                .animation(.default, value: colorList[i][j])
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.gray.opacity(0.15))
        .onReceive(pub, perform: { output in
            changeColorList()
        })
    }
    
    private func changeColorList() {
        for i in 0..<3 {
            for j in 0..<3 {
                colorList[i][j] = randomColor()
            }
        }
    }
    
    private static func initColorList() -> [[Color]] {
        var colorList = [[Color]]()
        for _ in 0..<3 {
            var tmp: [Color] = []
            for _ in 0..<3 {
                tmp.append(randomColor())
            }
            colorList.append(tmp)
        }
        return colorList
    }
    
}

struct NineMainView_Previews: PreviewProvider {
    static var previews: some View {
        NineMainView()
    }
}
