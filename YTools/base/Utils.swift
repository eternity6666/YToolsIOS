//
//  Utils.swift
//  YTools
//
//  Created by eternity6666 on 2022/12/12.
//

import Foundation
import SwiftUI

func randomColor() -> Color {
    let hue = Double(arc4random()) / Double(UInt32.max)
    return Color.init(hue: hue, saturation: 0.8, brightness: 0.8)
}

func saveAndShare(img: UIImage?) {
    if let img = img {
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let currentTime = "\(Date.now.formatted(date: .numeric, time: .standard))".filter({ $0.isCased || $0.isNumber })
        print(currentTime)
        let filePath = "\(rootPath)/colorDemo-\(currentTime).png"
        let imageData = img.pngData()
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        let url: URL = URL.init(fileURLWithPath: filePath)
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController!.present(av, animated: true, completion: nil)
    }
}
