//
//  SettingsView.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    // MARK: - PROPERTIES
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        ZStack(alignment: .leading){
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            
            CustomProgressView()
                .opacity(settingsVM.showLoading ? 1 : 0)
                .animation(.default, value: settingsVM.showLoading)
                
            VStack(alignment: .leading, spacing: 40){
                // MARK: - PAGE HEADER
                PageHeaderView(title: "Настройки")
                    
                Text("Оценить игру")
                    .onTapGesture {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
                        
                    }
                Text("Сбросить прогресс")
                    .onTapGesture {
                        settingsVM.showingResetProgressAlert = true
                    }
                
                
                Text("Поделиться приложением")
                    .onTapGesture {
                        settingsVM.showingShareSheet = true
                    }
                
                Spacer()
                
            }
            .padding(.horizontal, 16)
            .fontWeight(.bold)
            
            VStack{
                Spacer()
                BottomMenu()
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
            }
    
        }
        .navigationTitle("Настройки")
        .foregroundColor(.white)
        
        .alert("Вы действительно хотите сбросить ВЕСЬ прогресс и начать все сначала?", isPresented: $settingsVM.showingResetProgressAlert) {
            Button("Отмена") { settingsVM.showingResetProgressAlert = false }
            Button("Сброс") {
                settingsVM.resetTraning()
            }
        }
        
        .alert("Прогресс успешно сброшен.", isPresented: $settingsVM.resetSuccessfullyAlert) {
            Button("ок") { settingsVM.resetSuccessfullyAlert = false }
        }
        
        .sheet(isPresented: $settingsVM.showingShareSheet) {
            ShareSheetView(
                headline: "Угадай слово дня в развивающей игре Вордл")
        }
        
    }
    
}


// MARK: - PREVIW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
