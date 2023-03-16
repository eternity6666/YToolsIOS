//
//  SortPicView.swift
//  YTools
//
//  Created by Simple on 2022/12/11.
//

import SwiftUI

struct SortPicView: View {
    var list: [Int] = []
    @State private var showList: [Int]
    private var listColor: [Int: Color] = [:]
    @State private var selectedI: Int = -1
    @State private var selectedJ: Int = -1
    
    init(list: [Int]) {
        self.list = list
        showList = list
        list.forEach { value in
            listColor[value] = randomColor()
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                HStack(spacing: Self.calculateSpacing(geo, list: showList)) {
                    ForEach(showList.indices, id: \.self) { index in
                        VStack(spacing: 0) {
                            Text("\(showList[index])")
                                .foregroundColor(Color.white)
                            HStack {}
                                .fillMaxSize()
                        }
                        .border(borderShapeStyle(index), width: borderShapeWidth(index))
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 20,
                            maxHeight: Self.itemHeight(geo, item: showList[index], list: showList)
                        )
                        .background(listColor[showList[index]])
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: Alignment.bottom
                        )
                    }
                }
                .padding(Self.calculateEdgeInsets(geo, list: showList))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 250, maxHeight: 250)
            HStack {
                Button("点击") {
                    sortList()
                }
                Button("重置") {
                    showList = list
                }
            }
        }
    }
    
    private func borderShapeStyle(_ index: Int) -> some ShapeStyle {
        if (index == selectedI) {
            return Color.red
        } else if (index == selectedJ) {
            return Color.blue
        }
        return .blue
    }
    
    private func borderShapeWidth(_ index: Int)-> CGFloat {
        if (index == selectedI) {
            return 4.0
        } else if (index == selectedJ) {
            return 4.0
        }
        return 0.0
    }
    
    private func sortList() {
        DispatchQueue.global().async {
            for i in 0..<showList.endIndex {
                selectedI = i
                for j in (i+1)..<showList.endIndex {
                    selectedJ = j
                    if (showList[i] > showList[j]) {
                        let tmp = self.showList[i]
                        self.showList[i] = self.showList[j]
                        self.showList[j] = tmp
                    }
                    sleep(1)
                }
            }
            selectedI = -1
            selectedJ = -1
        }
    }
    
    
    private static func itemHeight(_ geo: GeometryProxy, item: Int, list: [Int]) -> CGFloat {
        let result = geo.size.height * CGFloat(item) / CGFloat(list.max() ?? 1)
        return result
    }
    
    private static func calculateEdgeInsets(_ geo: GeometryProxy, list: [Int]) -> EdgeInsets {
        let hor = calculateSpacing(geo, list: list)
        return EdgeInsets(top: 0, leading: hor, bottom: 0, trailing: hor)
    }
    
    private static func calculateSpacing(_ geo: GeometryProxy, list: [Int]) -> CGFloat {
        if (list.endIndex <= 0) {
            return 1.0
        }
        let len = list.endIndex
        let result = geo.size.width / CGFloat(Float(len + 1) + 4 * Float(len) / 0.628)
        return result
    }
}

struct SortPicView_Previews: PreviewProvider {
    static var previews: some View {
        SortPicView(
            list: [90, 100, 80, 30, 40, 99, 105, 20, 95, 10]
        )
    }
}
