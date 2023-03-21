//
//  RulesContentView.swift
//  Words
//
//  Created by Ivan Lvov on 14.02.2023.
//

import SwiftUI

struct RulesContentView: View {
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Group{
                Text("Правила игры")
                    .modifier( MyFont(font: "Inter", weight: "Bold", size: 34) )
                Spacer()
                    .frame(height: 1)
                
                Text("Угадайте загаданное слово с шести попыток")
                
                Text("После каждой попытки цвет букв будет меняться, чтобы показать какие буквы есть в загаданном слове.\nНапример, загадано слово ГОСТЬ")
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
        }
    }
}

// MARK: - PREVIW
struct RulesContentView_Previews: PreviewProvider {
    static var previews: some View {
        RulesContentView()
    }
}
