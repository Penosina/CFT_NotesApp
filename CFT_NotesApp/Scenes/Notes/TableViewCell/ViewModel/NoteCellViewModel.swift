final class NoteCellViewModel {
    // MARK: - Properties
    let title: String
    let text: String
    
    var didUpdateData: (() -> Void)?
    
    // MARK: - Init
    init(note: Note) {
        title = note.title
        text = note.text
    }
    
    // MARK: - Public Methods
    func start() {
        didUpdateData?()
    }
}
