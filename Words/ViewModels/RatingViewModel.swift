//
//  RatingViewModel.swift
//  Words
//
//  Created by Ivan Lvov on 12.03.2023.
//

import Foundation

@MainActor
class RatingViewModel: ObservableObject {
    @Published var topList: [TopElement] = []
    
    func getTopList() async throws {
        do {
            topList = try await APIProvider.shared.getTopList()
        } catch {
            print(error)
        }
    }
}
