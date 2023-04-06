//
//  NotificationView.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import SwiftUI

struct NotificationView: View {
    // MARK: - PROPERTIES

    @StateObject var playViewModel: PlayViewModel
    @State var isAnimated: Bool = false

    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
            .speed(4)
    }

    // MARK: - BODY

    var body: some View {
        VStack {
            VStack(spacing: 2) {
                if playViewModel.notifyHeadline != ""{
                    Text(playViewModel.notifyHeadline)
                        .fontWeight(.bold)
                        .font(.headline)
                }
                Text(playViewModel.notifyText)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .fill(Color.gray)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .offset(y: isAnimated ? 0 : -550)
            .onChange(of: playViewModel.showNotifyView) { newValue in
                if newValue != true { return }
                withAnimation(slideInAnimation) {
                    self.isAnimated = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(slideInAnimation) {
                        self.isAnimated = false
                        self.playViewModel.showNotifyView = false
                    }
                }
            }

            Spacer()

        } //: MAIN VSTACK
    }
}

// MARK: - PREVIW

struct NotificationView_Previews: PreviewProvider {
    static var playVM: PlayViewModel {
        let playVM = PlayViewModel()
        playVM.notifyHeadline = "\"Л\""
        playVM.notifyText = LetterState.wrongLetter.description
        playVM.showNotifyView = true
        return playVM
    }

    static var previews: some View {

        NotificationView(playViewModel: self.playVM)
            .padding()
    }
}
