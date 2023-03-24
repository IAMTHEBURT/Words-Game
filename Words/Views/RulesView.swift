//
//  Rules.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct RulesView: View {
    // MARK: - PROPERTIES
    
    @StateObject var mainVM: MainViewModel
    @AppStorage("isOnboardingFinished") private var isOnboardingFinished: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bottomMenuVM: BottomMenuViewModel
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 20){
                    
                    RulesContentView()
                    
                    //Если это первое включени, покажем кнопку запускающую первую игру
                   
                    Spacer()
                        .frame(height: 10)
                    
                    if isOnboardingFinished == false{
                        HStack{
                            Spacer()
                            Text("Попробуйте отгадать громкое слово приветствия, которое мы загадли")
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                mainVM.startAnyWordGame(word: "салют", title: "Приветственное слово")
                                bottomMenuVM.isOnboardingPagePresented = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    isOnboardingFinished = true
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "#E99C5D"))
                                    .frame(width: 177, height: 42, alignment: .center)
                                    .overlay {
                                        Text("Попробуем")
                                            .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                            .foregroundColor(Color(hex: "#242627"))
                                    }
                            }
                            Spacer()
                        }
                        
                        Spacer()
                    } else{
                        HStack{
                            Spacer()
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "#E99C5D"))
                                    .frame(width: 177, height: 42, alignment: .center)
                                    .overlay {
                                        Text("Продолжить")
                                            .modifier(MyFont(font: "Inter", weight: "medium", size: 14))
                                            .foregroundColor(Color(hex: "#242627"))
                                    }
                            }
                            Spacer()
                        }
                        
                        Spacer()
                        
                    }
                }
                .padding()
                .font(.callout)
            }
        }
        .modifier(MyFont(font: "Inter", weight: "Regular", size: 18))
        .lineSpacing(6)
        
    }
}

// MARK: - PREVIW
struct Rules_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            RulesView(mainVM: MainViewModel())
        }
    }
}
