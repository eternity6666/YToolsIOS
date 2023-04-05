//
//  FundMainItemView.swift
//  YTools
//
//  Created by eternity6666 on 2023/4/2.
//

import SwiftUI
import Alamofire

struct FundMainItemView: View {
    let fundSimpleData: FundSimpleData
    @State private var detailData: FundDetailData? = nil
    @State private var showDetail = false
    
    var body: some View {
        VStack {
            Text(fundSimpleData.name)
                .font(.title2)
                .foregroundColor(.primary)
            HStack {
                Text(fundSimpleData.code)
                    .font(.title3)
                Spacer()
                Text(fundSimpleData.type)
                    .font(.title3)
            }
            .foregroundColor(.secondary)
        }
        .fillMaxWidth()
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .foregroundColor(Color.systemBackground)
                .shadow(radius: 1)
        )
        .sheet(isPresented: $showDetail, content: {
            FundDetailView(fundDetailData: $detailData)
        })
        .onTapGesture {
            if (detailData == nil) {
                request()
            }
            self.showDetail.toggle()
        }
    }
    
    func request() {
        guard fundSimpleData.isValid() else {
            return
        }
        AF.request("https://api.doctorxiong.club/v1/fund/detail/list?code=\(fundSimpleData.code)")
            .responseDecodable(of: FundResponse<FundDetailData>.self) { response in
                switch response.result {
                case .success(let fundResponse):
                    debugPrint("\(fundSimpleData.code) 加载完成 \(fundResponse.data[safe: 0] != nil)")
                    detailData = fundResponse.data[safe: 0]
                case .failure(let error):
                    debugPrint("\(fundSimpleData.code) 加载失败")
                    debugPrint(error)
                }
            }
    }
}

struct FundMainItemView_Previews: PreviewProvider {
    static var previews: some View {
        FundMainItemView(
            fundSimpleData: FundSimpleData(
                dataList: [
                    "000001",
                    "HXCZHH",
                    "华夏成长混合",
                    "混合型-灵活",
                    "HUAXIACHENGZHANGHUNHE"
                ]
            )
        )
    }
}
