//
//  SettingsViewModel.swift
//  Words
//
//  Created by Ivan Lvov on 28.12.2022.
//

import Foundation
import CoreData

class SettingsViewModel: ObservableObject {
    @Published var showingResetProgressAlert: Bool = false
    @Published var showLoading: Bool = false
    @Published var resetSuccessfullyAlert: Bool = false
    @Published var showingShareSheet: Bool = false

    func resetTraning() {
        showingResetProgressAlert = false
        showLoading = true

        do {
            let allTasks = try CoreDataProvider.shared.viewContext.fetch(TaskDBM.all)

            allTasks.forEach { task in
                task.result = Int16(GameResult.loose.rawValue)
                task.game = nil
            }
        } catch {
            print(error.localizedDescription)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showLoading = false
            self.resetSuccessfullyAlert = true
        }
    }

}
