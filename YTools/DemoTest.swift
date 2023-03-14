//
//  DemoTest.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/10.
//

import Foundation

protocol Fly {
    associatedtype T
    var name:T {get set}
    var name2: String {get set}
    func fly()
    func add(a:T, b:T)
    func addB(a: String)
}


class Bird : Fly {
    typealias T = String
    var name = "Bird"
    
    var name2: String = "123"
    func fly() {
        print(name + "Fly")
    }
    func add(a: String, b: String) {
        
    }
    func addB(a: String) {
        
    }
}

func test(f: some Fly) {
    f.fly()
    // 这里会报错 因为any Fly类型在运行时无法确定成某个具体的类型
//    f.add(a: f.name, b: f.name)
    f.addB(a: f.name2)
}

func main() {
    test(f: Bird())
}
