//
//  CommentsView.swift
//  Words
//
//  Created by Ivan Lvov on 27.01.2023.
//

import SwiftUI

struct CommentsView: View {
    
    // MARK: - PROPERTIES
    

    @StateObject var playVM: PlayViewModel
    @State private var input: String = ""
        
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 24){
            // MARK: -  WRITE COMMENT TEXTAREA
            VStack(spacing: 24){
                TextField("", text: $input, axis: .vertical)
                    .placeholder(when: input.isEmpty) {
                            Text("Написать комментарий")
                            .foregroundColor(.white.opacity(0.9))
                            .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                    }
                    .foregroundColor(.white)
                    .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
                
                HStack{
                    Spacer()
                    Button(action: {
                        print("Got tap")
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .frame(width: 163, height: 42)
                            .overlay(
                                Text("Отправить")
                                    .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                    .foregroundColor(Color(hex: "#242627"))
                            )
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, x: 0, y: 4)
                    }
                }
            } //: END OF WRITE COMMENT TEXTAREA
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#4D525B"))
            )
            
            
            
            // MARK: - COMMENT BLOCK
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            
            CommentElementView(name: "QuizStar777", date: "14 января", comment: "Кто-нибудь смогу угадать это слово", likes: 7, dislikes: 2)
            
            
            
            
        }
        
    }
}

// MARK: - PREVIW
struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(playVM: PlayViewModel())
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
