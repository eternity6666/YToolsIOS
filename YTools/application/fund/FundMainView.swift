//
//  FundMainView.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/31.
//

import SwiftUI
import Alamofire

struct FundMainView: View {
    @State private var inputText = ""
    @State private var result = ""
    var body: some View {
        VStack {
            Text("请输入")
            HStack {
                TextField("请输入", text: $inputText)
                Button {
                    request()
                } label: {
                    Text("查询")
                }
            }
            if (!result.isEmpty) {
                Text(result)
            }
        }
    }
    
    func request() {
        if (!inputText.isEmpty) {
            AF.request("https://api.doctorxiong.club/v1/fund/detail/list?code=\(inputText)").response { response in
                result = response.description
            }
        }
    }
}

struct FundMainView_Previews: PreviewProvider {
    static var previews: some View {
        FundMainView()
    }
}
