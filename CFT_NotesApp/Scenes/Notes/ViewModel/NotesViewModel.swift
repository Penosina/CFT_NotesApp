
// MARK: - NotesViewModelDelegate
protocol NotesViewModelDelegate: AnyObject {
    func showEditingNoteScene(note: Note?, id: Int?)
}

final class NotesViewModel {
    // MARK: - Properties
    var didUpdateData: (() -> Void)?
    var didReceiveError: ((Error) -> Void)?
    
    weak var delegate: NotesViewModelDelegate?
    
    var countOfNotes: Int {
        cellViewModels.count
    }
    
    private let dependencies: Dependencies
    private var cellViewModels: [NoteCellViewModel] = []
    private var notes: [Note] = []
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func start() {
        getNotesFromDb()
        didUpdateData?()
    }
    
    func createNewNote() {
        delegate?.showEditingNoteScene(note: nil, id: countOfNotes)
    }
    
    func editNote(index: Int) {
        delegate?.showEditingNoteScene(note: notes[index], id: nil)
    }
    
    func getCellViewModel(index: Int) -> NoteCellViewModel {
        cellViewModels[index]
    }
    
    func deleteNote(index: Int) {
        dependencies.coreDataSevice.deleteNote(note: notes[index])
        notes.remove(at: index)
        setViewModels()
        didUpdateData?()
    }
    
    // MARK: - Private Methods
    private func getNotesFromDb() {
        notes = dependencies.coreDataSevice.getNotes()
        setViewModels()
    }
    
    private func setViewModels() {
        cellViewModels = []
        notes.forEach { note in
            cellViewModels.append(NoteCellViewModel(note: note))
        }
    }
}
