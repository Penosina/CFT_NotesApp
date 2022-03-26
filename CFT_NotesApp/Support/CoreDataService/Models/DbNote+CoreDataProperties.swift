import Foundation
import CoreData

extension DbNote {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DbNote> {
        return NSFetchRequest<DbNote>(entityName: "DbNote")
    }

    @NSManaged public var id: Int32
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var img: Data?

}

extension DbNote : Identifiable { }
