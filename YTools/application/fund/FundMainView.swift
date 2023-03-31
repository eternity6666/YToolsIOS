//
//  FundMainView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/31.
//

import SwiftUI
import Alamofire

struct FundMainView: View {
    @State private var inputText = "000001"
    @State private var fundDataList: [FundData] = []
    
    var body: some View {
        HStack {
            TextField("请输入", text: $inputText)
                .padding()
                .border(.secondary)
            Button {
                request()
            } label: {
                Text("查询")
            }
        }
        .padding()
        ScrollView {
            LazyVStack {
                ForEach(fundDataList.indices, id: \.self) { index in
                    let fundData = fundDataList[index]
                    FundItemView(fundData: fundData)
                }
            }
        }
    }
    
    func request() {
        if (!inputText.isEmpty) {
            AF.request("https://api.doctorxiong.club/v1/fund/detail/list?code=\(inputText)")
                .responseDecodable(of: FundResponse<FundData>.self) { response in
                    switch response.result {
                        case .success(let fundResponse):
                            fundDataList = fundResponse.data
                            debugPrint(fundDataList)
                        case .failure(let error):
                            debugPrint(error)
                    }
                }
        }
    }
}

struct FundItemView: View {
    let fundData: FundData
    
    var body: some View {
        VStack {
            Text("编号: \(fundData.code)")
            Text("名称: \(fundData.name)")
        }
        .padding()
        .fillMaxWidth()
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(randomColor()))
    }
}

struct FundItemView_Previews: PreviewProvider {
    static var previews: some View {
        FundItemView(fundData: FundData.init())
    }
}

struct FundMainView_Previews: PreviewProvider {
    static var previews: some View {
        FundMainView()
    }
}
