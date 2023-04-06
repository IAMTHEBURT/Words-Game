//
//  CommentElementView.swift
//  Words
//
//  Created by Ivan Lvov on 27.01.2023.
//

import SwiftUI

struct CommentElementView: View {
    // MARK: - PROPERTIES
    @StateObject var commentElementVM: CommentElementViewModel

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - NAME DATE
            VStack(alignment: .leading, spacing: 4) {
                Text(commentElementVM.comment.name)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 20))
                Text(commentElementVM.comment.created_at)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
            }
            .foregroundColor(Color(hex: "##BDC0C7"))

            // MARK: - COMMENT
            Text(commentElementVM.comment.text)
                .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                .foregroundColor(.white)

            // MARK: - REACTIONS
            HStack(spacing: 20) {
                // MARK: - LIKE
                HStack {
                    Image(systemName: commentElementVM.comment.has_user_like ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 22, height: 19)

                    Text("\(commentElementVM.comment.likes)")
                }
                .onTapGesture {
                    Task {
                        try await commentElementVM.addReaction(type: .like)
                    }
                }

                // MARK: - DISLIKE
                HStack {
                    Image(systemName: commentElementVM.comment.has_user_dislike ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .resizable()
                        .frame(width: 22, height: 19)
                    Text("\(commentElementVM.comment.dislikes)")
                }
                .onTapGesture {
                    Task {
                        try await commentElementVM.addReaction(type: .dislike)
                    }
                }

                Spacer()
            }
            .foregroundColor(Color(hex: "#BDC0C7"))
            .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#2C2F38"))
        )

        //: END OF MAIN STACK
    }
}

// MARK: - PREVIW

struct CommentElementView_Previews: PreviewProvider {
    static var previews: some View {
        CommentElementView(commentElementVM: CommentElementViewModel(comment: Comment.emptyInit()))
    }
}
