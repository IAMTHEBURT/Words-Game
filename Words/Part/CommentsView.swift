//
//  CommentsView.swift
//  Words
//
//  Created by Ivan Lvov on 27.01.2023.
//

import SwiftUI


enum ButtonState: String{
    case active, loading, sent
}

struct CommentsView: View {
    
    // MARK: - PROPERTIES
    
    @StateObject var playVM: PlayViewModel
    @StateObject var apiProvider = APIProvider.shared
    
    @State private var input: String = ""
    @State private var buttonState: ButtonState = .active
    @State private var errorMessage: String = ""
    
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
                        if buttonState != .active{
                            return
                        }
                        
                        if input.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                            return
                        }
                        
                        buttonState = .loading
                        apiProvider.saveComment(word: playVM.finalWord, text: input)
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .frame(width: 163, height: 42)
                            .overlay(
                                ZStack{
                                    if buttonState == .loading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                                        
                                    } else if buttonState == .active{
                                        Text("Отправить")
                                            .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                            .foregroundColor(Color(hex: "#242627"))
                                        
                                    } else if buttonState == .sent{
                                        Text("Отправлено")
                                            .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                            .foregroundColor(Color(hex: "#242627"))
                                    }
                                }
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
            
            Text(errorMessage)
                .modifier(MyFont(font: "Inter", weight: "Bold", size: 12))
                .foregroundColor(.red)
            
            // MARK: - COMMENT BLOCK
            
            ZStack{
                //ProgressView()
                VStack{
                    ForEach(apiProvider.comments, id: \.id) { comment in
                        
                        CommentElementView(comment: comment)
                    }
                }
            }
        }
        .onAppear{
            apiProvider.getComments(word: playVM.finalWord)
        }
        
        .onChange(of: apiProvider.isCommentSaved) { newValue in
            guard let isCommentSaved = newValue else { return }
            
            if isCommentSaved {
                input = ""
                withAnimation {
                    buttonState = .sent
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        buttonState = .active
                    }
                }
            } else{
                withAnimation {
                    errorMessage = "Проблема с соединением, повторите позже"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        buttonState = .active
                        errorMessage = ""
                    }
                }
            }
        }
        
    }
}

// MARK: - PREVIW
struct CommentsView_Previews: PreviewProvider {
    static var playVM: PlayViewModel {
        let vm = PlayViewModel()
        vm.finalWord = "ТОПКА"
        return vm
    }
    
    static var previews: some View {
        ScrollView{
            CommentsView(playVM: playVM)
        }
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
