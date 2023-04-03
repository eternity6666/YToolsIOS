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
    @State private var filterItemsList: [String: [FundSimpleData]] = [:]
    
    @State private var showSearchBtn = false
    @State private var showFilterItemsList = false
    
    private let columns = [GridItem(.adaptive(minimum: 200.0))]
    
    var body: some View {
        VStack {
            if (allFundDataList.isEmpty) {
                Text("加载中...")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(currentShowFundDataList.indices, id: \.self) { index in
                            let fundSimpleData = currentShowFundDataList[index]
                            FundMainItemView(fundSimpleData: fundSimpleData)
                        }
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0))
        .sheet(isPresented: $showFilterItemsList, onDismiss: {
            
        }, content: {
            ScrollView {
                LazyVStack {
                    ForEach(filterItemsList.sorted { $0.key < $1.key}.indices, id: \.self) { index in
                        Text("\((filterItemsList.sorted { $0.key < $1.key})[index].key)")
                    }
                }
            }
        })
        .toolbar {
            if (!allFundDataList.isEmpty) {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showFilterItemsList.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSearchBtn.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
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
                    filterItemsList = Dictionary(grouping: allFundDataList, by: { simpleFundData in
                        simpleFundData.type
                    })
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
