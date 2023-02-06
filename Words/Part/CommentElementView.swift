//
//  CommentElementView.swift
//  Words
//
//  Created by Ivan Lvov on 27.01.2023.
//

import SwiftUI

struct CommentElementView: View {
    // MARK: - PROPERTIES
    
    @State var comment: Comment
    @StateObject var apiProvider = APIProvider.shared
    
    
    
//    let name: String
//    let date: String
//    let comment: String
//
//    @State var likes: Int
//    @State var dislikes: Int
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            // MARK: - NAME DATE
            VStack(alignment: .leading, spacing: 4){
                Text(comment.name)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 20))
                Text(comment.created_at)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
            }
            .foregroundColor(Color(hex: "##BDC0C7"))
            
            // MARK: - COMMENT
            Text(comment.text)
                .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                .foregroundColor(.white)
            
            // MARK: - REACTIONS
            HStack(spacing: 20){
                // MARK: - LIKE
                HStack{
                    Image(systemName: comment.has_user_like ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 22, height: 19)
                    
                    
                    Text("\(comment.likes)")
                }
                .onTapGesture {
                    apiProvider.addReaction(type: .like, comment_id: comment.id)
                }
                
                // MARK: - DISLIKE
                HStack{
                    Image(systemName: comment.has_user_dislike ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .resizable()
                        .frame(width: 22, height: 19)
                    Text("\(comment.dislikes)")
                }
                .onTapGesture {
                    apiProvider.addReaction(type: .dislike, comment_id: comment.id)
                }
                
                Spacer()
            }
            .foregroundColor(Color(hex: "#BDC0C7"))
            .modifier(MyFont(font: "Inter", weight: "Bold", size: 14))
        }
        .onChange(of: apiProvider.updatedComment) { newValue in
            guard let updatedComment = newValue else { return }
            self.comment = updatedComment
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
        CommentElementView(comment: Comment.emptyInit())
    }
}
