import Foundation
import CoreData

@objc(DbNote)
public class DbNote: NSManagedObject {
    func transient() throws -> Note {
        guard let title = title else {
            throw Errors.titleNotFound
        }
        return Note(id: Int(id),
                    title: title,
                    text: text ?? "",
                    attachment: img)
    }
    
    static func from(transient: Note, inContext context: NSManagedObjectContext) -> DbNote {
        var note: DbNote
        
        let request: NSFetchRequest = DbNote.fetchRequest()
        let dataBaseNotes = (try? context.fetch(request)) ?? []
        
        if let dbNote = dataBaseNotes.first(where: { $0.id == Int32(transient.id) }) {
            note = dbNote
            note.title = transient.title
            note.text = transient.text
            note.img = transient.attachment
        } else {
            note = DbNote(context: context)
            note.id = Int32(transient.id)
            note.title = transient.title
            note.text = transient.text
            note.img = transient.attachment
        }
        
        return note
    }
}
