//
//  CommentsViewModel.swift
//  Words
//
//  Created by Ivan Lvov on 12.03.2023.
//

import Foundation
import SwiftUI

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isCommentSaved: Bool?

    @Published var input: String = ""
    @Published var buttonState: ButtonState = .active
    @Published var errorMessage: String = ""

    func saveCommentAsync(word: String, input: String) async {
        do {
            let data = try await APIProvider.shared.saveComment(word: word, text: input)
            isCommentSaved = data.0

            self.input = ""
            withAnimation {
                self.buttonState = .sent
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.buttonState = .active
                }
            }

            await self.updateComments(word: word)
        } catch {
            print(error)
            withAnimation {
                self.errorMessage = "Проблема с соединением, повторите позже"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.buttonState = .active
                    self.errorMessage = ""
                }
            }
        }
    }

    func updateComments(word: String) async {
        do {
            comments = try await APIProvider.shared.getComments(word: word)
        } catch {
            print(error)
        }
    }
}
