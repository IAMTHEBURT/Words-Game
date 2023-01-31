//
//  CategoryView.swift
//  Words
//
//  Created by Иван Львов on 09.12.2022.
//

import SwiftUI

struct CategoryView: View{
    // MARK: - PROPERTIES
    var name: String
    var isOpened: Bool
    
    var easyProgressFinished: Int
    var easyProgressOutOf: Int
    
    var difficultProgressFinished: Int
    var difficultProgressOutOf: Int
    
    // MARK: - FUNCTIONS
    func getEasyIcon() -> Image{
        if easyProgressFinished == easyProgressOutOf && easyProgressFinished != 0{
            return Image(systemName: "checkmark.circle.fill")
        }
        
        if isOpened{
            return Image(systemName: "lock.open.fill")
        }else{
            return Image(systemName: "lock.fill")
        }
    }
    
    func getDifficultIcon() -> Image{
        if difficultProgressFinished == difficultProgressOutOf && difficultProgressFinished != 0{
            return Image(systemName: "checkmark.circle.fill")
        }
        
        if isOpened{
            return Image(systemName: "lock.open.fill")
        }else{
            return Image(systemName: "lock.fill")
        }
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: -24) {
            VStack {
                Text("\(name)")
                    .foregroundColor(.white)
                    .font(.footnote)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
            )
            .zIndex(1)
            
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Обычная сложность")
                        Text("\(easyProgressFinished)/\(easyProgressOutOf)")
                            .font(.footnote)
                    }
                    .zIndex(2)
                    Spacer()
                    getEasyIcon()
                }
                Divider()
                    .overlay(Color.white)
                HStack{
                    VStack(alignment: .leading){
                        Text("Высокая сложность")
                        Text("\(difficultProgressFinished)/\(difficultProgressOutOf)")
                            .font(.footnote)
                    }
                    Spacer()
                    getDifficultIcon()
                }
            }
            .foregroundColor(.white)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
            )
        }
    }
}

// MARK: - PREVIEW
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(name: "5 слов",
                     isOpened: false,
                     easyProgressFinished: 0,
                     easyProgressOutOf: 1828,
                     difficultProgressFinished: 0,
                     difficultProgressOutOf: 1244)

    }
}
