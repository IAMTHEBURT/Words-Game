import Foundation
import CoreData

class CoreDataProvider {
    // MARK: - PROPERTIES

    static let shared = CoreDataProvider()

    let persistentContainer: NSPersistentContainer
    
    
    //Контекст для главной очереди
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Создание нового контекста для фоновой очереди
    var backgroundContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = viewContext
        return context
    }
    

    // MARK: - FUNCTIONS
    init() {
        persistentContainer = NSPersistentContainer(name: "DB")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to initiialize CoreData \(error)")
            }
        }
    }
    
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        backgroundContext.perform {
            block(self.backgroundContext)
            do {
                try self.backgroundContext.save()
            } catch {
                print("Error saving background context: \(error)")
            }
        }
    }
    
}
