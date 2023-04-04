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
    @State private var filterItemsList: [String: Bool] = [:]
    
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
                    .padding()
                }
            }
        }
        .sheet(
            isPresented: $showFilterItemsList,
            onDismiss: onFilterItemPageDismiss,
            content: createFilterItemPage
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilterItemsList.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                }.disabled(allFundDataList.isEmpty)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearchBtn.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }.disabled(allFundDataList.isEmpty)
            }
        }
        .onAppear {
            requestAllFund()
        }
    }
    
    private func createFilterItemPage() -> some View {
        let keyList = filterItemsList.map { $0.key }
        return VStack {
            let isAllSelected = filterItemsList.allSatisfy { $1 }
            let isAllUnSelected = filterItemsList.allSatisfy { !$1}
            ZStack {
                HStack {
                    Text("基金类型")
                        .font(.title2)
                }
                HStack {
                    Spacer()
                    Button {
                        keyList.forEach { key in
                            filterItemsList[key] = !isAllSelected
                        }
                    } label: {
                        Image(
                            systemName: isAllSelected ? "checklist.checked" : (isAllUnSelected ? "checklist.unchecked" : "checklist")
                        )
                    }
                }
            }
            .padding([.horizontal, .top], 16)
            ScrollView {
                LazyVStack {
                    ForEach(keyList.indices, id: \.self) { index in
                        let key = keyList[index]
                        HStack {
                            Image(systemName: filterItemsList[key] == true ? "checkmark.circle" : "circle")
                            Text(key)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                                .foregroundColor(Color(uiColor: .systemBackground))
                                .shadow(radius: 1)
                        )
                        .onTapGesture {
                            filterItemsList[key]?.toggle()
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func onFilterItemPageDismiss() {
        var tmpList: [FundSimpleData] = []
        allFundDataList.forEach { data in
            if (filterItemsList[data.type] == true) {
                tmpList.append(data)
            }
        }
        currentShowFundDataList = tmpList
    }
    
    private func requestAllFund() {
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
                        filterItemsList = [:]
                        allFundDataList.forEach { data in
                            filterItemsList[data.type] = true
                        }
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
