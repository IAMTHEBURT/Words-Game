//
//  WordsScroll.swift
//  Words
//
//  Created by Ivan Lvov on 07.04.2023.
//

import SwiftUI

struct WordsScroll: View {
    @StateObject var vm: WordsScrollViewModel = WordsScrollViewModel()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vm.words.indices, id: \.self) {i in

                    WordsScrollElement(word: vm.words[i])

                    // Если не последний, показать точку
                    if i != vm.words.count - 1 {
                        Circle()
                            .fill(.white)
                            .frame(width: 4, height: 4)
                    }
                }
            }
            .padding(.leading, 16)
            .offset(x: CGFloat(vm.currentIndex) * -200)
            .animation(.easeInOut(duration: 1), value: vm.currentIndex)
        }
    }
}

struct WordsScroll_Previews: PreviewProvider {
    static var previews: some View {
        WordsScroll()
    }
}
