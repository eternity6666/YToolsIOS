//
//  FundDetailView.swift
//  YTools
//
//  Created by eternity6666 on 2023/4/2.
//

import SwiftUI

struct FundDetailView: View {
    @Binding var fundDetailData: FundDetailData?
    
    var body: some View {
        if (fundDetailData == nil) {
            Text("加载中...")
        } else {
            VStack {
                Text(fundDetailData?.name ?? "")
                Text(fundDetailData?.code ?? "")
            }
        }
    }
}

struct FundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FundDetailView(fundDetailData: .constant(FundDetailData.init()))
    }
}
