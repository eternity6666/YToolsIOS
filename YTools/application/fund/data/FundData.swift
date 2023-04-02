//
//  FundResponse.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/31.
//

import Foundation

struct FundResponse<DATA>: Codable where DATA: Codable {
    let code: Int
    let message: String
    let data: [DATA]
}

/**
 * 基金信息
 */
struct FundSimpleData: Codable {
    let code: String
    // 拼音首字母缩写
    let pinyinNameInitials: String
    let name: String
    let pinyinName: String
    let type: String
    
    init(dataList: [String]) {
        self.code = dataList[safe: 0] ?? ""
        self.pinyinNameInitials = dataList[safe: 1] ?? ""
        self.name = dataList[safe: 2] ?? ""
        self.type = dataList[safe: 3] ?? ""
        self.pinyinName = dataList[safe: 4] ?? ""
    }
    
    func isValid() -> Bool {
        return !self.code.isEmpty && !self.name.isEmpty
    }
}

/**
 * 基金明细
 */
struct FundDetailData: Codable {
    let code: String
    let name: String
    let type: String
    let netWorth: Double
    let expectWorth: Double
    let totalWorth: Double
    let expectGrowth: String
    let dayGrowth: String
    let lastWeekGrowth: String
    let lastMonthGrowth: String
    let lastThreeMonthsGrowth: String
    let lastSixMonthsGrowth: String
    let lastYearGrowth: String
    let buyMin: String
    let buySourceRate: String
    let buyRate: String
    let manager: String
    let fundScale: String
    let netWorthDate: String
    let expectWorthDate: String
    let netWorthData: [[String?]]
    let totalNetWorthData: [[String?]]
    
    init(
        code: String = "",
        name: String = "",
        type: String = "",
        netWorth: Double = 0.0,
        expectWorth: Double = 0.0,
        totalWorth: Double = 0.0,
        expectGrowth: String = "",
        dayGrowth: String = "",
        lastWeekGrowth: String = "",
        lastMonthGrowth: String = "",
        lastThreeMonthsGrowth: String = "",
        lastSixMonthsGrowth: String = "",
        lastYearGrowth: String = "",
        buyMin: String = "",
        buySourceRate: String = "",
        buyRate: String = "",
        manager: String = "",
        fundScale: String = "",
        netWorthDate: String = "",
        expectWorthDate: String = "",
        netWorthData: [[String]] = [[]],
        totalNetWorthData: [[String]] = [[]]
    ) {
        self.code = code
        self.name = name
        self.type = type
        self.netWorth = netWorth
        self.expectWorth = expectWorth
        self.totalWorth = totalWorth
        self.expectGrowth = expectGrowth
        self.dayGrowth = dayGrowth
        self.lastWeekGrowth = lastWeekGrowth
        self.lastMonthGrowth = lastMonthGrowth
        self.lastThreeMonthsGrowth = lastThreeMonthsGrowth
        self.lastSixMonthsGrowth = lastSixMonthsGrowth
        self.lastYearGrowth = lastYearGrowth
        self.buyMin = buyMin
        self.buySourceRate = buySourceRate
        self.buyRate = buyRate
        self.manager = manager
        self.fundScale = fundScale
        self.netWorthDate = netWorthDate
        self.expectWorthDate = expectWorthDate
        self.netWorthData = netWorthData
        self.totalNetWorthData = totalNetWorthData
    }
}