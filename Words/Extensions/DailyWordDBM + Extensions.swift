import Foundation
import CoreData

extension DailyWordDBM: BaseDBModel {
    static var all: NSFetchRequest<DailyWordDBM> {
        let request = DailyWordDBM.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    static var actual: NSFetchRequest<DailyWordDBM> {
        let request = DailyWordDBM.fetchRequest()
        let currentTimestamp = Int(Date.now.timeIntervalSince1970)
        let predicate = NSPredicate(format: "active_at <= \(currentTimestamp) AND next_at > \(currentTimestamp)")
        request.sortDescriptors = []
        request.predicate = predicate
        request.fetchLimit = 1
        return request
    }
    
    
    
    
    
}
