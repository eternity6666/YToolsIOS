//
//  FundMainView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/31.
//

import SwiftUI
import Alamofire

struct FundMainView: View {
    @State private var allFundDataList: [FundSimpleData] = []
    @State private var currentShowFundDataList: [FundSimpleData] = []
    
    @State private var showSearchBtn = false
    
    var body: some View {
        VStack {
            if (allFundDataList.isEmpty) {
                Text("加载中...")
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(currentShowFundDataList.indices, id: \.self) { index in
                            let fundSimpleData = currentShowFundDataList[index]
                            FundMainItemView(fundSimpleData: fundSimpleData)
                        }
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0))
        .toolbar(content: {
            if (!allFundDataList.isEmpty) {
                ToolbarItem {
                    Button {
                        showSearchBtn.toggle()
                    } label: {
                        Image(systemName: "search")
                    }
                }
            }
        })
        .onAppear {
            requestAllFund()
        }
    }
    
    func requestAllFund() {
        AF.request("https://api.doctorxiong.club/v1/fund/all")
            .responseDecodable(of: FundResponse<[String]>.self) { response in
                switch response.result {
                    case .success(let fundResponse):
                        allFundDataList = fundResponse.data.map({ dataList in
                            FundSimpleData(dataList: dataList)
                        }).filter({ fundSimpleData in
                            fundSimpleData.isValid()
                        })
                        currentShowFundDataList = allFundDataList
                    case .failure(let error):
                        debugPrint(error)
                }
            }
    }
}

struct FundMainItemView: View {
    let fundSimpleData: FundSimpleData
    @State private var detailData: FundDetailData? = nil
    @State private var showDetail = false
    
    var body: some View {
        VStack {
            Text(fundSimpleData.name)
                .font(.title)
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
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(randomColor()))
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
                        detailData = fundResponse.data[safe: 0]
                    case .failure(let error):
                        debugPrint(error)
                }
            }
    }
}

struct FundMainView_Previews: PreviewProvider {
    static var previews: some View {
        FundMainView()
    }
}
