import Foundation
import CoreData

final class CoreDataService {
    // MARK: - Properties
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private var persistentContainer: NSPersistentContainer
    
    // MARK: - Init
    init() {
        persistentContainer = NSPersistentContainer(name: Strings.coreDataModelName)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
    }
    
    // MARK: - Public Methods
    func addOrUpdateNote(note: Note) {
        _ = DbNote.from(transient: note, inContext: viewContext)
        try? viewContext.save()
    }
    
    func getNotes() -> [Note] {
        var notes: [Note] = []
        
        let request: NSFetchRequest = DbNote.fetchRequest()
        let dataBaseNotes = (try? viewContext.fetch(request)) ?? []
        
        dataBaseNotes.forEach { note in
            try? notes.append(note.transient())
        }
        
        return notes
    }
    
    func deleteNote(note: Note) {
        let dbNote = DbNote.from(transient: note, inContext: viewContext)
        viewContext.delete(dbNote)
        
        try? viewContext.save()
    }
    
    func deleteAllData() {
        let storeContainer = persistentContainer.persistentStoreCoordinator
        
        for store in storeContainer.persistentStores {
            try? storeContainer.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
        }

        persistentContainer = NSPersistentContainer(name: Strings.coreDataModelName)
        persistentContainer.loadPersistentStores { _, error in
            print(String(describing: error))
        }
    }
}

// MARK: - Strings
private extension Strings {
    static let coreDataModelName = "Model"
}
