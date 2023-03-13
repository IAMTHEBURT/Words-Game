//
//  SendMessageToDevelopers.swift
//  TestLanguageApp
//
//  Created by Иван Львов on 22.07.2022.
//

import SwiftUI

struct SendMessageToDevelopers: View {
    // MARK: - PROPERTIES
    
    @StateObject var apiController = APIProvider.shared
    @State var reviewText: String = ""
    @State var emailAddress: String = ""
    @State var sendAttempts: Int = 0
    @Binding var isPartialSheetPresented: Bool
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Text("Отмена").foregroundColor(Color(hex: "#C6CAD3"))
                    .modifier(MyFont(font: "Inter", weight: "Medium", size: 16))
                .onTapGesture {
                    isPartialSheetPresented = false
                }
                Spacer()
                Text("Отправить")
                    .foregroundColor(Color(hex: "#1CB1F5"))
                    .modifier(MyFont(font: "Inter", weight: "Medium", size: 16))
                .onTapGesture {
                    if emailAddress == "" || reviewText == ""{
                        //Выход анимации
                        withAnimation(.default) {
                            self.sendAttempts = self.sendAttempts + 1
                        }
                        return
                    }
                    let text = "WORDS. New message from user with address ||\(emailAddress)|| his message ||\(reviewText)||"
                    
                    Task{
                        do {
                            try await apiController.sendMessage(message: text)
                        } catch {
                            print(error)
                        }
                    }
                    
                    isPartialSheetPresented = false
                }
            }
            Spacer().frame(height: 10)
            Text("Что бы Вы хотели улучшить в нашем приложении?")
                .foregroundColor(Color(hex: "#CECECE")).padding(10)
                .modifier(MyFont(font: "Inter", weight: "Regular", size: 16))
            
            ZStack(alignment: .leading) {
                if emailAddress.isEmpty {
                    VStack(alignment: .leading){
                        Text("Ваш E-Mail для ответа")
                        Spacer()
                    }
                    .padding(.leading, 15)
                    .padding(.top, 18)
                }
                TextEditor(text: $emailAddress)
                    .foregroundColor(Color(hex: "#CECECE")).padding(10)
            }
            .opacity(emailAddress.isEmpty ? 0.25 : 1)
            .frame(height: 50)
            .modifier(MyFont(font: "Inter", weight: "Regular", size: 16))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "#EFEFEF"), lineWidth: 2))
            .modifier(Shake(animatableData: CGFloat(sendAttempts)))
            
            
            ZStack(alignment: .leading) {
                if reviewText.isEmpty {
                    VStack(alignment: .leading){
                        Text("Что Вам не понравилось...")
                        Spacer()
                    }
                    .padding(.leading, 15)
                    .padding(.top, 18)
                }
                TextEditor(text: $reviewText).foregroundColor(Color(hex: "#CECECE")).padding(10)
            }
            .opacity(reviewText.isEmpty ? 0.25 : 1)
            .frame(height: 100)
            .font(Font.custom("Nunito-Regular", size: 14))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "#EFEFEF"), lineWidth: 2))
            .modifier(Shake(animatableData: CGFloat(sendAttempts)))
            
        }.padding([.leading, .trailing], 20)
    }
}

// MARK: - PREVIW

struct SendMessageToDevelopers_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageToDevelopers(isPartialSheetPresented: .constant(true))
    }
}
