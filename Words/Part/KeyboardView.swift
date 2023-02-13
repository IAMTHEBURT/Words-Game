//
//  KeyboardView.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import SwiftUI

struct KeyboardView: View {
    // MARK: - PROPERTIES
    @StateObject var playViewModel: PlayViewModel
    let keyboardLineHeight: CGFloat = 40
    
    let columnSpacing: CGFloat = 4
    let rowSpacing: CGFloat = 4
    
    var gridLayout: [GridItem]{
        return Array(repeating: GridItem(.flexible(maximum: 25), spacing: rowSpacing, alignment: .trailing), count: 11)
    }
    
    var characters: [String]{
        let letters: String = "йцукенгшщзхфывапролджэячсмитьбю"
        let result: [String] =  letters.map { character in
            String(character).uppercased()
        }
        return result
    }
    
    let line1: [String] = "йцукенгшщзхъ".toArray()
    let line2: [String] = "фывапролджэ".toArray()
    let line3: [String] = "ячсмитьбю".toArray()
    
    var lines: [[String]] {
        return [
            line1,
            line2,
            line3,
        ]
    }
    
    
    // MARK: - BODY
    var body: some View {
        GeometryReader{ geo in
            VStack{
                Spacer()
                HStack(alignment: .center, spacing: 6){
                    ForEach(line1, id: \.self){ character in
                        KeyboardButton(playViewModel: playViewModel, character: character, sound: "Interface Click 1")
                            .frame(maxWidth: 25)
                    }
                }
                .padding(.horizontal, 10)
                .frame(height: keyboardLineHeight)
                
                HStack(spacing: 6){
                    Spacer(minLength: geo.size.width / CGFloat(line2.count) / 6)
                    ForEach(line2, id: \.self){ character in
                        KeyboardButton(playViewModel: playViewModel, character: character, sound: "Interface Click 2")
                            .frame(maxWidth: 25)
                    }
                    Spacer(minLength: geo.size.width / CGFloat(line2.count) / 6)
                }
                .padding(.horizontal, 10)
                .frame(height: keyboardLineHeight)
                
                HStack(spacing: 6){
//                    MarkKeyboardButton(playViewModel: playViewModel)
//                        .frame(width: 40)
                    ForEach(line3, id: \.self){ character in
                        KeyboardButton(playViewModel: playViewModel, character: character, sound: "Interface Click 3")
                            .frame(maxWidth: 25)
                    }
                    
                    RemoveKeyboardButton(playViewModel: playViewModel, sound: "Interface Click 4")
                        .frame(maxWidth: 25)
                }
                .padding(.horizontal, 10)
                .frame(height: keyboardLineHeight)
                
                LongMarkKeyboardButton(playViewModel: playViewModel)
                .frame(height: 40)
                .padding(.horizontal, 40)
                Spacer()
            }
            
            
            //.frame(maxHeight: geo.size.height / 2)
            
//            LazyVGrid(columns: gridLayout, spacing: columnSpacing){
//                ForEach(characters, id: \.self) { character in
//
//                    if character == "Я"{
//                        MarkKeyboardButton(playViewModel: playViewModel)
//                            .scaledToFit()
//                            .scaleEffect(1.3)
//                            .offset(x: -8)
//                    }
//
//                    RoundedRectangle(cornerRadius: 6)
//                        .stroke(playViewModel.getColorForTheKeyboardKey(character: character), lineWidth: 2)
//                        .overlay(
//                            Color.white
//                                //.opacity(isPressed ? 0.15 : 0)
//                                .cornerRadius(6)
//                        )
//                        .overlay(
//                            Text(character)
//                                .padding(4)
//                        )
//                        .padding(.vertical, 3)
//                        .fontWeight(.bold)
//                        .font(.system(size: 500))
//                        .minimumScaleFactor(0.01)
//                        .simultaneousGesture(
//                            DragGesture(minimumDistance: 0)
//                                .onChanged({ _ in
//                                    //isPressed = true
//                                })
//                                .onEnded({ _ in
//                                    //isPressed = false
//                                })
//                        )
//                        .onTapGesture {
//                            playViewModel.inputCharacter(character: character)
//                        }
//                        .scaledToFit()
//                        .foregroundColor(.black)
//
//                    if character == "Ю"{
//                        //RemoveKeyboardButton(playViewModel: playViewModel)
//                        RemoveKeyboardButton(playViewModel: playViewModel)
//                    }
//                }
//            }
//            .padding(.horizontal)
            
            
            
            
//            VStack(spacing: 20){
//                HStack(alignment: .center, spacing: (geo.size.width / 15 * 2) / 10 ){
//                    Spacer()
//                    ForEach(line1, id: \.self) { character in
//                        KeyboardButton(playViewModel: playViewModel, character: character)
//                            .frame(
//                                width: geo.size.width / 15,
//                                height: geo.size.width / 15 * 1.1
//                            )
//                    }
//                    Spacer()
//                }
//
//                HStack(alignment: .center, spacing: (geo.size.width / 15 * 2) / 10 ){
//                    Spacer()
//                    ForEach(line2, id: \.self) { character in
//                        KeyboardButton(playViewModel: playViewModel, character: character)
//                            .frame(
//                                width: geo.size.width / 15,
//                                height: geo.size.width / 15 * 1.1
//                            )
//                    }
//                    Spacer()
//                }
//
//
//                HStack(alignment: .center, spacing: (geo.size.width / 15 * 2) / 10 ){
//                    Spacer()
//                    MarkKeyboardButton(playViewModel: playViewModel)
//                    ForEach(line3, id: \.self) { character in
//                        KeyboardButton(playViewModel: playViewModel, character: character)
//                            .frame(
//                                width: geo.size.width / 15,
//                                height: geo.size.width / 15 * 1.1
//                            )
//                    }
//
//                    RemoveKeyboardButton(playViewModel: playViewModel)
//                    Spacer()
//                }
//
//                //            HStack {
//                //                MarkKeyboardButton(playViewModel: playViewModel)
//                //                ForEach(line3, id: \.self) { character in
//                //                    KeyboardButton(playViewModel: playViewModel, character: character)
//                //                }
//                //
//                //                RemoveKeyboardButton(playViewModel: playViewModel)
//                //            }
//
//            }
            
            //            HStack {
            //                ForEach(line2, id: \.self) { character in
            //                    KeyboardButton(playViewModel: playViewModel, character: character)
            //                }
            //            }
            //
            //            HStack {
            //                MarkKeyboardButton(playViewModel: playViewModel)
            //                ForEach(line3, id: \.self) { character in
            //                    KeyboardButton(playViewModel: playViewModel, character: character)
            //                }
            //
            //                RemoveKeyboardButton(playViewModel: playViewModel)
            //            }
            
            
        }
        
        //            HStack {
        //                ForEach(line2, id: \.self) { character in
        //                    RoundedRectangle(cornerRadius: 6)
        //                        .stroke(playViewModel.getColorForTheKeyboardKey(character: character), lineWidth: 2)
        //                        .overlay(Text(character))
        //                        .frame(width: 25, height: 40)
        //                        .onTapGesture{
        //                            playViewModel.inputCharacter(character: character)
        //                        }
        //                }
        //            }
        //
        //            HStack {
        //
        //                ForEach(line3, id: \.self) { character in
        //                    RoundedRectangle(cornerRadius: 6)
        //                        .stroke(playViewModel.getColorForTheKeyboardKey(character: character), lineWidth: 2)
        //                        .overlay(Text(character))
        //                        .frame(width: 25, height: 40)
        //                        .onTapGesture{
        //                            playViewModel.inputCharacter(character: character)
        //                        }
        //                }
        //
        //            }
        
        
        
        
        
        //            ForEach(characters, id: \.self) { character in
        //                Text(character)
        //            }
        //        }
        //
        //
        //        VStack{
        //
        //            LazyVGrid(columns: gridLayout, spacing: columnSpacing){
        //                ForEach(characters, id: \.self) { character in
        //                    RoundedRectangle(cornerRadius: 6)
        //                        .stroke(playViewModel.getColorForTheKeyboardKey(character: character), lineWidth: 2)
        //                        .overlay(Text(character))
        //                        .frame(width: 25, height: 40)
        //                        .onTapGesture{
        //                            playViewModel.inputCharacter(character: character)
        //                        }
        //                }
        //
        //                RoundedRectangle(cornerRadius: 6)
        //                    .stroke(Color.gray, lineWidth: 2)
        //                    .overlay(
        //                        Image(systemName: "delete.left.fill")
        //                    )
        //                    .onTapGesture{
        //                        playViewModel.removeCharacter()
        //                    }
        //            }
        //
        //
        //            Button(action: {
        //                playViewModel.checkTheLine()
        //            }) {
        //                RoundedRectangle(cornerRadius: 6)
        //                    .fill(playViewModel.checkButtonIsActive ? .yellow : .gray)
        //                    .frame(height: 40)
        //                    .overlay(
        //                        Text("Check the word".uppercased())
        //                    )
        //            }
        //            .disabled(!playViewModel.checkButtonIsActive)
        //
        //        }
        //        .padding()
        
    }
}




// MARK: - PREVIW
struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(playViewModel: PlayViewModel())
            .background(Color("BGColor"))
    }
}
