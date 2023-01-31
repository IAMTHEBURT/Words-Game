//
//  Rules.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import SwiftUI

struct RulesView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 20){
                    Group{
                        Text("Угадайте загаданное слов с шести попыток")
                        
                        Text("После каждой попытки цвет букв будет меняться, чтобы показать какие буквы есть в загаданном слове. \n Например, загадано слово ГОСТЬ")
                    }
                    
                    Divider()
                    
                    Group{
                        Text("Первым мы ввели слово РЕБУС. Буква С есть в загаданном слове, но стоит в другом месте")
                        HStack{
                            Spacer()
                            Text("Р")
                                .modifier(SquareLetterModifier(.unanswered))
                            Text("Е")
                                .modifier(SquareLetterModifier(.unanswered))
                            Text("Б")
                                .modifier(SquareLetterModifier(.unanswered))
                            Text("У")
                                .modifier(SquareLetterModifier(.unanswered))
                            Text("С")
                                .modifier(SquareLetterModifier(.rightLetterWrongPlace))
                            Spacer()
                        }
                    }
                    
                    Divider()
                    
                    Group{
                        Text("Затем ввели слово СОСНА. Буквы С и О есть в загаданном слове и стоят на правильных местах.")
                        
                        HStack{
                            Spacer()
                            
                            Text("С")
                                .modifier(SquareLetterModifier(.unanswered))
                            Text("О")
                                .modifier(SquareLetterModifier(.rightLetterRightPlace))
                            Text("С")
                                .modifier(SquareLetterModifier(.rightLetterRightPlace))
                            Text("Н")
                                .modifier(SquareLetterModifier(.unanswered))
                            Text("А")
                                .modifier(SquareLetterModifier(.unanswered))
                            Spacer()
                        }
                        
                        Text("Обратите внимание, что если во введенном слове две одинаковых буквы, а в загаданном слове только одна такая буква, то выделяется только одна буква.")
                    }
                    
                    Divider()
                    
                    Group{
                        Text("Если слово угадано правильно, то все буквы будут выделены.")
                        
                        HStack{
                            Spacer()
                            Text("Г")
                                .modifier(SquareLetterModifier(.rightLetterRightPlace))
                            Text("О")
                                .modifier(SquareLetterModifier(.rightLetterRightPlace))
                            Text("С")
                                .modifier(SquareLetterModifier(.rightLetterRightPlace))
                            Text("Т")
                                .modifier(SquareLetterModifier(.rightLetterRightPlace))
                            Text("Ь")
                                .modifier(SquareLetterModifier(.rightLetterRightPlace))
                            Spacer()
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button(action: {
                        print("Got tap")
                    }) {
                        HStack{
                            Spacer()
                            Text("Играть")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.blue)
                        )
                        
                    }
                    
                    Spacer()
                }
                .padding()
                .font(.callout)
            }
            .navigationTitle("Правила игры")
        }
        .foregroundColor(.black)
        
    }
}

// MARK: - PREVIW
struct Rules_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            RulesView()
        }
    }
}
