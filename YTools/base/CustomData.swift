//
//  CustomData.swift
//  YTools
//
//  Created by eternity6666 on 2023/4/5.
//

import Foundation

struct Pair<T1,T2>: Identifiable {
    var id = UUID()
    
    let first: T1
    let second: T2
    
    init(_ first: T1, _ second: T2) {
        self.first = first
        self.second = second
    }
}
