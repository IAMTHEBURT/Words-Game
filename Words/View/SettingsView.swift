//
//  SettingsView.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI
import StoreKit
import PartialSheet

struct SettingsView: View {
    // MARK: - PROPERTIES
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    @State var isReviewLoadingOn: Bool = false
    
    @AppStorage("UID") private var UID: String = ""
    @AppStorage("isSoundOn") private var isSoundOn: Bool = true
    @AppStorage("areCommentsOn") private var areCommentsOn: Bool = true
    @AppStorage("areAdultWordsOn") private var areAdultWordsOn: Bool = false
    
    @State var isPartialSheetPresented: Bool = false
    
    // MARK: - BODY
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            
            CustomProgressView()
                .opacity(settingsVM.showLoading ? 1 : 0)
                .animation(.default, value: settingsVM.showLoading)
                
            VStack(alignment: .leading, spacing: 0){
                // MARK: - PAGE HEADER
                PageHeaderView(title: "Настройки")
                    .padding(.horizontal, 16)
                    .offset(y: 2)
                Form{
                    Section( header: Text("") ){
                        EmptyView()
                    }
                    .opacity(0.1)
                    
                    Section( header: Text("Игра") )
                    {
                        Toggle(isOn: $isSoundOn) {
                            Text("Звук")
                        }
                        
                        Toggle(isOn: $areCommentsOn) {
                            Text("Показывать комментарии")
                        }
                    }
                    .tint(.orange)
                    
                    
                    Section( header: Text("Прогресс") )
                    {
                        Button(action: {
                            settingsVM.showingResetProgressAlert = true
                        }) {
                            Text("Сбросить прогресс")
                        }
                    }
                    
                    Section( header: Text("Другое") )
                    {
                        Button(action: {
                            isReviewLoadingOn = true
                            if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
                        }) {
                            
                            HStack{
                                Text("Оценить игру")
                                Spacer()
                                ProgressView()
                                    .opacity(isReviewLoadingOn ? 1 : 0)
                                
                            }
                        }
                        
                        Button(action: {
                            settingsVM.showingShareSheet = true
                        }) {
                            Text("Поделиться приложением")
                        }
                        
                        Button(action: {
                            isPartialSheetPresented = true
                        }) {
                            Text("Написать разработчику")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.clear)
                .background(Color("BGColor"))
                
                .onAppear(perform: {
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableViewCell.appearance().backgroundColor = UIColor.clear
                })
                

            }
            //.padding(.horizontal, 16)
            //.fontWeight(.bold)
    
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
                headline: "Угадай слово дня в развивающей игре \(appName)")
        }
        .onChange(of: isReviewLoadingOn) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isReviewLoadingOn = false
                }
            }
        }
        .partialSheet(isPresented: $isPartialSheetPresented) {
            SendMessageToDevelopers(isPartialSheetPresented: $isPartialSheetPresented)
                .padding(.bottom, 150)
        }
        .attachPartialSheetToRoot()
    }
    
}


// MARK: - PREVIW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
