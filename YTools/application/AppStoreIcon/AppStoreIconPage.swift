//
//  AppStoreIconPage.swift
//  YTools
//
//  Created by eternity6666 on 2024/1/5.
//

import SwiftUI
import Combine

struct AppStoreItem: Codable {
    var screenshotUrls: [String] = []
    var price: Double = 0.0
    var description: String = ""
}
struct AppStoreData: Codable {
    var resultCount: Int = 0
    var results: [AppStoreItem] = []
}

struct AppStoreIconPage: View {
    @State private var targetUrl = "https://itunes.apple.com/search?term=1293634699&country=us&entity=software"
    @State private var remoteImage: [UIImage] = []
    
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                HStack {
                    Text("输入")
                    TextField(text: $targetUrl) {
                    }
                    .textFieldStyle(.roundedBorder)
                }
                Button {
                    fetchUrl()
                } label: {
                    Text("查找")
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.automatic)
                showImage()
            } else {
                // Fallback on earlier versions
                Text("升级系统体验")
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func showImage() -> some View {
        if (!remoteImage.isEmpty) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(remoteImage.indices, id: \.self) { index in
                        Image(uiImage: remoteImage[index])
                            .resizable()
                            .frame(maxHeight: .infinity)
                            .contentShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    }
                }
            }
        }
    }
    
    private func fetchUrl() {
        if let url = URL(string: targetUrl) {
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                do {
                    if let targetData = data {
                        let decoder = JSONDecoder()
                        let data2 = try decoder.decode(AppStoreData.self, from: targetData)
                        print(data2)
                        if let item = data2.results.first {
                            fetchImage(item)
                        }
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
    
    private func fetchImage(_ item: AppStoreItem) {
        item.screenshotUrls.forEach { imageUrl in
            if let url = URL(string: imageUrl) {
                print(url)
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let dataData = data, let image = UIImage(data: dataData) {
                        remoteImage.append(image)
                    }
                }.resume()
            }
        }
    }
}

#Preview {
    AppStoreIconPage()
}
