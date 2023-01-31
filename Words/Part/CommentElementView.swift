//
//  CommentElementView.swift
//  Words
//
//  Created by Ivan Lvov on 27.01.2023.
//

import SwiftUI

struct CommentElementView: View {
    // MARK: - PROPERTIES
    
    let name: String
    let date: String
    let comment: String
    
    @State var likes: Int
    @State var dislikes: Int
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            // MARK: - NAME DATE
            VStack(alignment: .leading, spacing: 4){
                Text(name)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 20))
                Text(date)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
            }
            .foregroundColor(Color(hex: "##BDC0C7"))
            
            // MARK: - COMMENT
            Text(comment)
                .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                .foregroundColor(.white)
            
            // MARK: - REACTIONS
            HStack(spacing: 20){
                // MARK: - LIKE
                HStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 22, height: 19)
                    Text("\(likes)")
                }
                
                // MARK: - DISLIKE
                HStack{
                    Image(systemName: "hand.thumbsdown")
                        .resizable()
                        .frame(width: 22, height: 19)
                    Text("\(dislikes)")
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
        CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
    }
}
