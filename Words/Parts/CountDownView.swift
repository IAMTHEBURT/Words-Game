//
//  CountDownView.swift
//  Words
//
//  Created by Иван Львов on 13.12.2022.
//

import SwiftUI

struct CountDownView: View {
    // MARK: - PROPERTIES
    var till: Int

    @Binding var countDownTrigger: Bool

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var countDown: String = ""

    // MARK: - BODY
    var body: some View {
        Text(countDown)
            .onReceive(timer) { _ in
                let interval = Double(till) - Date.now.timeIntervalSince1970

                if interval <= 0 {
                    APIProvider.shared.getWordOfTheDay()
                    return
                }

                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.unitsStyle = .positional
                let formattedString = formatter.string(from: TimeInterval(interval))!
                countDown = formattedString
            }
    }
}

// MARK: - PREVIW
struct CountDownView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView(till: 1670976000, countDownTrigger: .constant(false))
    }
}
