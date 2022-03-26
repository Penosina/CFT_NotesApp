final class NoteViewModel {
    // MARK: - Properties    
    var didUpdateData: (() -> Void)?
    
    var title: String
    var text: String
    
    private let dependencies: Dependencies
    private var note: Note = Note(id: 0, title: "", text: "")
    
    // MARK: - Init
    init(dependencies: Dependencies, note: Note? = nil, id: Int? = nil) {
        self.dependencies = dependencies
        
        if let id = id {
            self.note = Note(id: id, title: "", text: "")
        } else if let note = note {
            self.note = note
        }
        
        title = self.note.title
        text = self.note.text
    }
    
    // MARK: - Public Methods
    func start() {
        didUpdateData?()
    }
    
    func addOrUpdateNote(title: String, description: String) {
        guard !title.isEmpty || !description.isEmpty else { return }
        
        note = Note(id: note.id, title: title, text: description)
        dependencies.coreDataSevice.addOrUpdateNote(note: note)
    }
}
