//
//  SortMainView.swift
//  YTools
//
//  Created by Simple on 2022/12/11.
//

import SwiftUI

struct SortMainView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                Section {
                    SortPicView(list: [70, 80, 20, 30, 79, 100])
                }
                SortPicView(list: [90, 100, 80, 30, 40, 99, 105, 20, 95, 10])
                SortPicView(list: [70, 80, 20, 30, 30, 40, 99, 105, 79, 100])
            }
        }
    }
}

struct SortMainView_Previews: PreviewProvider {
    static var previews: some View {
        SortMainView()
    }
}
