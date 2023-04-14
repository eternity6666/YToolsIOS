//
//  FundDetailView.swift
//  YTools
//
//  Created by eternity6666 on 2023/4/2.
//

import SwiftUI
import SwiftUICharts

struct FundDetailView: View {
    @Binding var fundDetailData: FundDetailData?
    
    var body: some View {
        if (fundDetailData == nil) {
            Text("加载中...")
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(fundDetailData!.name)
                            .font(.title)
                        Spacer()
                    }
                    buildDasicMessage(data: fundDetailData!)
                    buildTransactionMessage(data: fundDetailData!)
                    AnyView(buildNetWorthData(data: fundDetailData!))
                }
                .fillMaxWidth()
                .padding()
            }
        }
    }
    
    private var splitLine: some View {
        Spacer()
            .fillMaxWidth()
            .frame(height: 1)
            .background(Color.secondary)
    }
    
    private func buildNetWorthData(
        data: FundDetailData
    ) -> any View {
        var dataList: [Double] = []
        for netWorthDataItem in data.netWorthData {
            guard let priceStr = netWorthDataItem[safe: 1] else {
                continue
            }
            guard let price = Double(priceStr) else {
                continue
            }
            dataList.append(price)
        }
        guard let last = dataList.last, let first = dataList.first else {
            return Spacer().frame(width: 0, height: 0)
        }
        guard first != 0 else {
            return Spacer().frame(width: 0, height: 0)
        }
        let rateValue = Int((last - first) / first * 100)
        return LineChartView(
            data: dataList,
            title: "净值信息",
            form: ChartForm.extraLarge,
            rateValue: rateValue,
            dropShadow: false,
            valueSpecifier: "%.2f"
        )
    }
    
    private func buildTransactionMessage(
        data: FundDetailData
    ) -> some View {
        let detailMessageList = [
            Pair("基金净值", "\(String(format: "%.4f", data.netWorth))元"),
            Pair("基金净值估算", "\(String(format: "%.4f", data.expectWorth))元"),
            Pair("累计净值", "\(String(format: "%.4f", data.totalWorth))元"),
            Pair("起购额度", "\(data.buyMin)元"),
            Pair("当前买入费率", "\(data.buyRate)元"),
            Pair("原始买入费率", "\(data.buySourceRate)元")
        ].filter { pair in
            !pair.second.isEmpty
        }
        return buildMessageCard(list: detailMessageList, label: "交易须知")
    }
    
    private func buildDasicMessage(
        data: FundDetailData
    ) -> some View {
        let detailMessageList = [
            Pair("基金编码", data.code),
            Pair("基金类型", data.type),
            Pair("基金经理", data.manager),
            Pair("基金规模", "\(data.fundScale)元")
        ].filter { pair in
            !pair.second.isEmpty
        }
        return buildMessageCard(list: detailMessageList, label: "基础信息")
    }
    
    private func buildMessageCard(list: [Pair<String, String>], label: String) -> some View {
        return GroupBox {
            VStack(spacing: 4) {
                ForEach(list) { pair in
                    HStack {
                        Text(pair.first)
                        Spacer()
                        Text(pair.second)
                    }
                }
            }
        } label: {
            Text(label)
                .padding(.bottom, 4)
        }
    }
}

struct FundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FundDetailView(
            fundDetailData: .constant(FundDetailData.testData)
        )
    }
}
