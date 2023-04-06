//
//  GameHistoryViewModel.swift
//  Words
//
//  Created by Иван Львов on 14.12.2022.
//

import Foundation
import CoreData

class GameHistoryViewModel: NSObject, ObservableObject {
    private let fetchedResultsController: NSFetchedResultsController<GameDBM>
    private (set) var context: NSManagedObjectContext

    @Published var games: [GameHistoryModel] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        let fetchRequest = GameDBM.all
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        super.init()
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            guard let gamesDBM = fetchedResultsController.fetchedObjects else {
                return
            }
            self.games = gamesDBM.map(GameHistoryModel.init)
        } catch {
            print(error)
        }
    }

}

extension GameHistoryViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let gamesDBM = controller.fetchedObjects as? [GameDBM] else {
            return
        }
        self.games = gamesDBM.map(GameHistoryModel.init)
    }
}
