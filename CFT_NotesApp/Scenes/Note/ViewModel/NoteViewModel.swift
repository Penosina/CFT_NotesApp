import UIKit

// MARK: - NoteViewModelDelegate
protocol NoteViewModelDelegate: AnyObject {
    func showImagePicker(complition: @escaping (UIImage) -> Void)
}

final class NoteViewModel {
    // MARK: - Properties    
    var didUpdateData: (() -> Void)?
    var didSetImage: ((UIImage) -> Void)?
    var didDeleteImage: (() -> Void)?
    
    weak var delegate: NoteViewModelDelegate?
    
    var title: String
    var text: String
    var image: UIImage?
    
    private let dependencies: Dependencies
    private let note: Note
    
    // MARK: - Init
    init(dependencies: Dependencies, note: Note) {
        self.dependencies = dependencies
        self.note = note
        
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
    
    func deleteImage() {
        didDeleteImage?()
    }
}
