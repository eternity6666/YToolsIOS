//
//  ClockMainView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/10.
//

import SwiftUI

@available(iOS 15, *)
struct ClockMainView: View {
    @State var time = ClockData(time: .now)
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            VStack {
                ClockBoardView(time: $time)
                    .frame(width: size * 0.9, height: size * 0.9)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                            time = ClockData(time: .now)
                        }
                    }
            }
            .fillMaxSize()
        }.fillMaxSize()
    }
}

struct ClockMainView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15, *) {
            ClockMainView()
        } else {
        }
    }
}
