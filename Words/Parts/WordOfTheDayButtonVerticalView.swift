//
//  WordOfTheDayButtonVertical.swift
//  Words
//
//  Created by Ivan Lvov on 07.04.2023.
//

import SwiftUI

struct WordOfTheDayButtonVerticalView: View {
    // MARK: - PROPERTIES
    @StateObject var mainVM: MainViewModel
    @AppStorage("isDailyWordNotificationSet") private var isDailyWordNotificationSet: Bool = false

    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.25)
            .speed(2)
            .delay(0.25)
    }

    // MARK: - BODY

    var body: some View {

        VStack(spacing: 12) {
            ZStack {
                Text("Слово дня")
                    .modifier(MyFont(font: "Inter", weight: "Bold", size: 20))
                    .fontWeight(.bold)
            }
            .frame(minHeight: 72)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color(hex: "#DD6B4E"))

            VStack(spacing: 12) {
                Group {
                    if mainVM.isDailyWordCompleted() {
                        VStack(alignment: .center, spacing: 10) {
                            Text("Сегодня Вы играли ")
                            Text("Следущее общее слово через:")
                            Text(mainVM.countDown)
                        }
                    } else {
                        Text("Общее слово для\nвсех игроков")
                    }
                }
                Spacer()
            }
            .frame(height: 112)
            .modifier(MyFont(font: "Inter", weight: "Medium", size: 14))
        }
        .multilineTextAlignment(.center)
        .background(Color(hex: "#2C2F38"))
        .cornerRadius(8)
        .overlay(
            Image(systemName: isDailyWordNotificationSet ? "bell.fill" : "bell")
                .offset(x: -25, y: -25)
                .onTapGesture {
                    NotificationProvider().toggleNotifications()
                }
            ,
            alignment: .bottomTrailing
        )
        .offset( y: mainVM.isDailyWordAnimating ? 0 : -600 )
        .animation(slideInAnimation, value: mainVM.isDailyWordAnimating)
        .onTapGesture {
            if mainVM.getDailyWordGameHistory() != nil {
                mainVM.showingDailyWordIsFinishedAlert.toggle()
            } else {
                mainVM.startDailyWordGame()
            }
        }
    }

    // MARK: - PREVIW

    struct WordOfTheDayButtonVertical_Previews: PreviewProvider {
        static var previews: some View {
            WordOfTheDayButtonVerticalView(mainVM: MainViewModel())
                .previewLayout(.fixed(width: 200, height: 400))
        }
    }

}
