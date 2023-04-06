//
//  CommentElementViewModel.swift
//  Words
//
//  Created by Ivan Lvov on 13.03.2023.
//

import SwiftUI

@MainActor
class CommentElementViewModel: ObservableObject {
    @Published var comment: Comment

    init(comment: Comment) {
        self.comment = comment
    }

    func addReaction(type: ReactionType) async throws {
        do {
            guard let comment = try await APIProvider.shared.addReaction(type: type, commentId: comment.id) else { return }
            self.comment = comment
        } catch {
            print(error)
        }
    }
}
