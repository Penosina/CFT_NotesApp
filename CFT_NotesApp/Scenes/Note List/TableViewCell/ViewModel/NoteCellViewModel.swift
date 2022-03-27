import UIKit

final class NoteCellViewModel {
    // MARK: - Properties
    let title: String
    let text: String
    let image: UIImage?
    
    var didUpdateData: (() -> Void)?
    
    // MARK: - Init
    init(note: Note) {
        title = note.title
        text = note.text
        if let attachment = note.attachment {
            image = UIImage(data: attachment)
        } else {
            image = nil
        }
    }
    
    // MARK: - Public Methods
    func start() {
        didUpdateData?()
    }
}
