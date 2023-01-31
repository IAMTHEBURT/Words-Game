import Foundation
import CoreData

class CoreDataProvider {
    // MARK: - PROPERTIES
    
    let persistentContainer: NSPersistentContainer
    
    static let shared = CoreDataProvider()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - FUNCTIONS
    init() {
        persistentContainer = NSPersistentContainer(name: "DB")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to initiialize CoreData \(error)")
            }
        }
    }
}
