import UIKit

// MARK: - NoteViewModelDelegate
protocol NoteViewModelDelegate: AnyObject {
    func showImagePicker(complition: @escaping (UIImage) -> Void)
}

final class NoteViewModel {
    // MARK: - Properties    
    var didUpdateData: (() -> Void)?
    var didSetImage: ((UIImage) -> Void)?
    
    weak var delegate: NoteViewModelDelegate?
    
    var title: String
    var text: String
    var image: UIImage?
    
    private let dependencies: Dependencies
    private let note: Note
    
    // MARK: - Init
    init(dependencies: Dependencies, note: Note? = nil, id: Int? = nil) {
        self.dependencies = dependencies
        
        if let id = id {
            self.note = Note(id: id, title: "", text: "", attachment: nil)
        } else if let note = note {
            self.note = note
        } else {
            self.note = Note(id: 0, title: "", text: "", attachment: nil)
        }
        
        title = self.note.title
        text = self.note.text
        
        if let attachment = self.note.attachment {
            image = UIImage(data: attachment)
        }
    }
    
    // MARK: - Public Methods
    func start() {
        didUpdateData?()
    }
    
    func addOrUpdateNote(title: String, description: String, image: UIImage?) {
        guard !title.isEmpty || !description.isEmpty || image != nil else {
            dependencies.coreDataSevice.deleteNote(note: note)
            return
        }
        
        let note = Note(id: note.id,
                        title: title,
                        text: description,
                        attachment: image?.jpegData(compressionQuality: 0.25))
        dependencies.coreDataSevice.addOrUpdateNote(note: note)
    }
    
    func showImagePicker() {
        delegate?.showImagePicker() { [weak self] image in
            self?.didSetImage?(image)
        }
    }
}
