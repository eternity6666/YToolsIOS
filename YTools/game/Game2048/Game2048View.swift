//
//  Game2048.swift
//  YTools
//
//  Created by eternity6666 on 2023/3/9.
//

import SwiftUI

struct Game2048View: View {
    @State private var data = Self.initData()
    @State private var score = 0
    @State private var isDead = false
    @State private var newX = -1
    @State private var newY = -1
    @GestureState private var dragOffset = CGSize.zero
    private let valueToColor = [
        0: 0.2,
        2: 0.3,
        4: 0.3,
        8: 0.4,
        16: 0.4,
        32: 0.5,
        64: 0.5,
        128: 0.6,
        256: 0.6,
        512: 0.7,
        1024: 0.7,
        2048: 0.8,
        4096: 0.8,
        8192: 0.9
    ]
    
    init() {
        print("初始化了")
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("分数: \(score)\(isDead ? "(游戏结束)" : "")")
                    .foregroundColor(Color.blue.opacity(0.8))
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            buildChessBoard()
            HStack {
                if (isDead) {
                    Button("重置") {
                        resetData()
                    }
                }
            }
            .frame(height: 50)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .gesture(isDead == false ? buildDragGesture() : nil)
    }
    
    private func buildDragGesture() -> some Gesture {
        return DragGesture()
            .onEnded { value in
                let x = value.translation.width
                let y = value.translation.height
                let isX = abs(x) >= abs(y)
                let isDown = isX ? x < 0 : y < 0
                let directionType = DirectionType.match(isX: isX, isDown: isDown)
                let changed = updateChessBoard(directionType: directionType)
                if (!changed) {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                }
                checkForDeath()
                if (isDead) {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }
    }
    
    private func buildChessBoard() -> some View {
        return VStack {
            ForEach(data.indices, id:\.self) { i in
                HStack {
                    ForEach($data[i].indices, id: \.self) { j in
                        buildChess(i: i, j: j)
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 15.0)
                .foregroundColor(Color.blue.opacity(0.1))
        )
    }
    
    private func buildChess(i: Int, j: Int) -> some View {
        let itemValue = data[i][j]
        let itemUIConfig = getItemUIConfig(itemValue: itemValue)
        return Text(itemUIConfig.title)
            .frame(width: 80, height: 80)
            .foregroundColor(Color.white)
            .font(.title)
            .background(
                RoundedRectangle(cornerRadius: 15.0)
                    .foregroundColor(
                        (i == newX && j == newY) ? Color.red : itemUIConfig.backgroundColor
                    )
            )
    }
    
    private func getItemUIConfig(itemValue: Int) -> ItemUIConfig {
        let backgroundColorOpacity = valueToColor[itemValue] ?? 1
        return ItemUIConfig(
            title: itemValue == 0 ? "" : "\(itemValue)",
            backgroundColor: Color.blue.opacity(backgroundColorOpacity)
        )
    }
    
    private func checkForDeath() {
        var notDead = false
        for i in data.indices {
            for j in data[i].indices {
                if (data[i][j] == 0) {
                    notDead = true
                    break
                }
                if (i + 1 < data.endIndex && data[i][j] == data[i + 1][j]) {
                    notDead = true
                    break
                }
                if (j + 1 < data[i].endIndex && data[i][j] == data[i][j + 1]) {
                    notDead = true
                    break
                }
            }
            if (notDead) {
                break
            }
        }
        if (!notDead) {
            isDead = true
        }
    }
    
    private func updateChessBoard(directionType: DirectionType) -> Bool{
        var hasChanged = false
        switch (directionType) {
            case .RightToLeft:
                hasChanged = updateChessBoardByRightToLeft()
                break
            case .LeftToRight:
                hasChanged =  updateChessBoardByLeftToRight()
                break
            case .TopToBottom:
                hasChanged =  updateChessBoardByTopToBottom()
                break
            default:
                hasChanged =  updateChessBoardByBottomToTop()
                break
        }
        if (hasChanged) {
            addChess(count: 1)
        }
        return hasChanged
    }
    
    private func updateChessBoardByRightToLeft() -> Bool {
        var hasChanged = false
        for i in data.indices {
            for j in data[i].indices {
                for next in (j + 1) ..< data[i].endIndex {
                    if (data[i][j] == 0) {
                        if (data[i][next] != 0) {
                            data[i][j] = data[i][next]
                            data[i][next] = 0
                            hasChanged = true
                        }
                    } else {
                        if (data[i][j] == data[i][next]) {
                            data[i][j] = data[i][j] + data[i][next]
                            data[i][next] = 0
                            score = score + data[i][j]
                            hasChanged = true
                            break
                        } else if (data[i][next] != 0) {
                            break
                        }
                    }
                }
            }
        }
        return hasChanged
    }
    
    private func updateChessBoardByLeftToRight() -> Bool {
        var hasChanged = false
        for i in data.indices {
            let count = data[i].endIndex
            for jtmp in 0 ..< count {
                let j = count - 1 - jtmp
                for tmp in 0 ..< j {
                    let next = j - 1 - tmp
                    if (data[i][j] == 0) {
                        if (data[i][next] != 0) {
                            data[i][j] = data[i][next]
                            data[i][next] = 0
                            hasChanged = true
                        }
                    } else {
                        if (data[i][j] == data[i][next]) {
                            data[i][j] = data[i][j] + data[i][next]
                            data[i][next] = 0
                            score = score + data[i][j]
                            hasChanged = true
                            break
                        } else if (data[i][next] != 0) {
                            break
                        }
                    }
                }
            }
        }
        return hasChanged
    }
    
    private func updateChessBoardByBottomToTop() -> Bool {
        var hasChanged = false
        for i in data.indices {
            for j in data[i].indices {
                for next in (i + 1) ..< data.endIndex {
                    if (data[i][j] == 0) {
                        if (data[next][j] != 0) {
                            data[i][j] = data[next][j]
                            data[next][j] = 0
                            hasChanged = true
                        }
                    } else {
                        if (data[i][j] == data[next][j]) {
                            data[i][j] = data[i][j] + data[next][j]
                            data[next][j] = 0
                            score = score + data[i][j]
                            hasChanged = true
                            break
                        } else if (data[next][j] != 0) {
                            break
                        }
                    }
                }
            }
        }
        return hasChanged
    }
    
    private func updateChessBoardByTopToBottom() -> Bool {
        var hasChanged = false
        let count = data.endIndex
        for itmp in 0 ..< count {
            let i = count - 1 - itmp
            for j in data[i].indices {
                for tmp in 0 ..< i {
                    let next = i - 1 - tmp
                    if (data[i][j] == 0) {
                        if (data[next][j] != 0) {
                            data[i][j] = data[next][j]
                            data[next][j] = 0
                            hasChanged = true
                        }
                    } else {
                        if (data[i][j] == data[next][j]) {
                            data[i][j] = data[i][j] + data[next][j]
                            data[next][j] = 0
                            score = score + data[i][j]
                            hasChanged = true
                            break
                        } else if (data[next][j] != 0) {
                            break
                        }
                    }
                }
            }
        }
        return hasChanged
    }
    
    private func addChess(count: Int) {
        var enableAdd = 0
        for i in data.indices {
            for j in data[i].indices {
                if (data[i][j] == 0) {
                    enableAdd += 1
                }
            }
        }
        if (enableAdd >= count) {
            for _ in 0 ..< count {
                while(true) {
                    let i = Int(arc4random()) % data.endIndex
                    let j = Int(arc4random()) % data[0].endIndex
                    if (self.data[i][j] == 0) {
                        if (enableAdd > 1 && newX == i && newY == j) {
                            continue
                        }
                        newX = i
                        newY = j
                        self.data[i][j] = Int((arc4random() % 2 + 1) * 2)
                        break
                    }
                }
                enableAdd -= 1
            }
        }
    }
    
    private func resetData() {
        isDead = false
        score = 0
        newX = -1
        newY = -1
        for i in data.indices {
            for j in data[i].indices {
                self.data[i][j] = 0
            }
        }
        addChess(count: 2)
    }
    
    private static func initData() -> [[Int]] {
        var data = [[Int]]()
        let size = 4
        for _ in 1...size {
            var row = [Int]()
            for _ in 1...size {
                row.append(0)
            }
            data.append(row)
        }
        for _ in 0...1 {
            while(true) {
                let i = Int(arc4random()) % data.endIndex
                let j = Int(arc4random()) % data[0].endIndex
                if (data[i][j] == 0) {
                    data[i][j] = Int((arc4random() % 2 + 1) * 2)
                    break
                }
            }
        }
        return data
    }
    
    private enum DirectionType {
        case LeftToRight
        case RightToLeft
        case TopToBottom
        case BottomToTop
        
        static func match(isX: Bool, isDown: Bool) -> DirectionType {
            if (isX) {
                return isDown ? RightToLeft : LeftToRight
            } else {
                return isDown ? BottomToTop : TopToBottom
            }
        }
    }
    
    private struct ItemUIConfig {
        let title: String
        let backgroundColor: Color
    }
}

struct Game2048View_Previews: PreviewProvider {
    static var previews: some View {
        Game2048View()
    }
}

extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
    func toCollection(_ reversed: Bool) -> any RandomAccessCollection {
        if reversed {
            return ClosedRange(self).reversed()
        } else {
            return ClosedRange(self)
        }
    }
}
