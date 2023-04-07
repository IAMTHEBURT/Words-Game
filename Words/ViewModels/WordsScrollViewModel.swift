//
//  WordsScrollViewModel.swift
//  Words
//
//  Created by Ivan Lvov on 07.04.2023.
//

import Foundation
import Combine

class WordsScrollViewModel: ObservableObject {
    @Published var currentIndex: Int = 0

    private var timer: AnyCancellable?

    init() {
        timer = Timer.publish(every: 4, on: .main, in: .common)
            .autoconnect()
            .sink { _ in self.updateIndex() }
    }

    let words: [String] = {
        var words: [String] = Bundle.main.decode("scroll-words-ru.json")
        words.shuffle()
        return Array(words[0...20])
    }()

    func updateIndex() {
        let nextIndex = currentIndex + 1 >= 5 ? 0 : currentIndex + 1
        self.currentIndex = nextIndex
    }

}
