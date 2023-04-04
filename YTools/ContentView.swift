//
//  ContentView.swift
//  YTools
//
//  Created by eternity6666 on 2022/12/7.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink {
                    LazyView(NineMainView())
                } label: {
                    ContentItemView(title: "九格")
                }
                NavigationLink {
                    LazyView(SortMainView())
                } label: {
                    ContentItemView(title: "冒泡", color: Color.blue)
                }
                NavigationLink {
                    LazyView(Game2048View())
                } label: {
                    ContentItemView(title: "2048")
                }
                if #available(iOS 15.0, *) {
                    NavigationLink {
                        LazyView(ColorDemoView())
                    } label: {
                        ContentItemView(title: "Color Demo")
                    }
                    NavigationLink {
                        LazyView(ClockMainView())
                    } label: {
                        ContentItemView(title: "自定义时钟")
                    }
                }
                NavigationLink {
                    LazyView(FundMainView())
                } label: {
                    ContentItemView(title: "Fund")
                }
            }
            .padding()
        }
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentItemView: View {
    let title: String
    let color: Color
    
    init(title: String, color: Color = randomColor()) {
        self.title = title
        self.color = color
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: 20, design: .rounded))
            .padding()
            .fillMaxWidth()
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .foregroundColor(Color.systemBackground)
                    .shadow(radius: 1)
            )
    }
}
