//
//  RatingView.swift
//  Words
//
//  Created by Ivan Lvov on 29.01.2023.
//

import SwiftUI

struct RatingView: View {
    // MARK: - PROPERTIES
    
    @StateObject var ratingVM: RatingViewModel = RatingViewModel()
    
    // MARK: - FUNCTIONS
    
    private func getBackgroundForPosition(index: Int, isPlayer: Bool) -> some View{
        //Если первая строка
        if index + 1 == 1 {
            return RoundedCorners(color: Color(hex: "#DD6B4E"), tl: 8, tr: 8, bl: 0, br: 0)
        //Если последняя строка
        } else if index + 1 == ratingVM.topList.count{
            if isPlayer{
                return RoundedCorners(color: Color(hex: "#4D525B"), tl: 0, tr: 0, bl: 8, br: 8)
            }else{
                return RoundedCorners(color: Color(.clear), tl: 0, tr: 0, bl: 8, br: 8)
            }
        //Любой другой
        } else {
            if isPlayer{
                return RoundedCorners(color: Color(hex: "#4D525B"))
            }else{
                return RoundedCorners(color: .clear)
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        ZStack{
            Color("BGColor")
                .edgesIgnoringSafeArea(.all)
            
            if ratingVM.topList.isEmpty{
                VStack {
                    Spacer()
                    ProgressView()
                    //Text("Упс.. Тут никого нет.\nПроверьте интернет подключение.")
                    Spacer()
                }
                .multilineTextAlignment(.center)
                .modifier(MyFont(font: "Inter", weight: "bold", size: 25))
            }

            
            ScrollView{
                VStack {
                    Spacer()
                        .frame(height: 17)
                    PageHeaderView(blockRatingButton: true, title: "Рейтинг", hideHomeIcon: false, hideRulesIcon: true)
                        .padding(.horizontal, 17)
                    Spacer()
                        .frame(height: 48)
                    
                    VStack(spacing: 0){
                        ForEachWithIndex(ratingVM.topList, id: \.nickname) { index, topElement in
                            VStack{
                                HStack(spacing: 0){
                                    
                                    HStack(spacing: 20){
                                        Text("\(topElement.position)")
                                        
                                        HStack(spacing: 5){
                                            if index == 0 {
                                                Image(systemName: "crown")
                                            }
                                            
                                            Text(topElement.nickname)
                                                .accessibilityLabel("nickname")
                                        }
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                    Text("\(topElement.points)")
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                
                                
//                                if topElement.isPlayer{
//                                    HStack(spacing: 24){
//                                        Spacer()
//                                        RatingIcon(bgColor: Color(hex: "#DE6B4E"), iconName: "rating_icon_grow")
//                                        RatingIcon(bgColor: Color(hex: "#E99C5D"), iconName: "rating_icon_share")
//                                        RatingIcon(bgColor: Color(hex: "#289788"), iconName: "rating_icon_edit")
//                                        Spacer()
//                                    }
//                                    .padding(.vertical, 10)
//                                }
                                
                            }
                            .background(
                                getBackgroundForPosition(index: index, isPlayer: topElement.isPlayer)
                            )
                            
                        }
                    }
                    .background(
                        Color(hex: "#2D2F38")
                    )
                    .padding(.horizontal, 17)
                    .accessibilityIdentifier("ratingCollection")
                    Spacer()
                    
                }
            }
        }
        .modifier(MyFont(font: "Inter", weight: "bold", size: 14))
        .task {
            try! await ratingVM.getTopList()
        }
    }
    
}

// MARK: - PREVIW
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}

struct RatingIcon: View {
    let bgColor: Color
    let iconName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(bgColor)
            .frame(width: 48, height: 48)
            .overlay(
                Image(iconName)
            )
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}



public struct ForEachWithIndex<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    public var data: Data
    public var content: (_ index: Data.Index, _ element: Data.Element) -> Content
    var id: KeyPath<Data.Element, ID>

    public init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }

    public var body: some View {
        ForEach(
            zip(self.data.indices, self.data).map { index, element in
                IndexInfo(
                    index: index,
                    id: self.id,
                    element: element
                )
            },
            id: \.elementID
        ) { indexInfo in
            self.content(indexInfo.index, indexInfo.element)
        }
    }
}

extension ForEachWithIndex where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

extension ForEachWithIndex: DynamicViewContent where Content: View {
}

private struct IndexInfo<Index, Element, ID: Hashable>: Hashable {
    let index: Index
    let id: KeyPath<Element, ID>
    let element: Element

    var elementID: ID {
        self.element[keyPath: self.id]
    }

    static func == (_ lhs: IndexInfo, _ rhs: IndexInfo) -> Bool {
        lhs.elementID == rhs.elementID
    }

    func hash(into hasher: inout Hasher) {
        self.elementID.hash(into: &hasher)
    }
}

