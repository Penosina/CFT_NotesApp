import UIKit

final class NotesCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator]
    var rootNavigationController: UINavigationController
    
    private let dependencies: Dependencies
    private let notesViewModel: NotesViewModel
    private var noteViewModel: NoteViewModel?
    private var complition: ((UIImage) -> Void)?
    
    // MARK: - Init
    init(dependencies: Dependencies, rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
        self.dependencies = dependencies
        childCoordinators = []
        notesViewModel = NotesViewModel(dependencies: dependencies)
    }
    
    // MARK: - Public Methods
    func start() {
        notesViewModel.delegate = self
        let notesVC = NotesViewController(viewModel: notesViewModel)
        
        rootNavigationController.setViewControllers([ notesVC ], animated: true)
    }
}

// MARK: - NotesViewModelDelegate
extension NotesCoordinator: NotesViewModelDelegate {
    func showEditingNoteScene(note: Note?, id: Int?) {
        let noteViewModel = NoteViewModel(dependencies: dependencies, note: note, id: id)
        noteViewModel.delegate = self
        self.noteViewModel = noteViewModel
        let noteVC = NoteViewController(viewModel: noteViewModel)
        rootNavigationController.pushViewController(noteVC, animated: true)
        setupNavigationBarButton(sender: self.noteViewModel)
    }
    
    private func setupNavigationBarButton(sender: NoteViewModel?) {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage.init(systemName: Images.addPhotoImage)
        barButtonItem.tintColor = .systemIndigo
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.init(systemName: Images.addPhotoImage),
                                              style: .plain,
                                              target: self,
                                              action: #selector(showImagePickerAction))
        
        rootNavigationController.topViewController?.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc private func showImagePickerAction() {
        noteViewModel?.showImagePicker()
    }
}

// MARK: - NoteViewModelDelegate
extension NotesCoordinator: NoteViewModelDelegate {
    func showImagePicker(complition: @escaping (UIImage) -> Void) {
        self.complition = complition
        
        let imagePickerCoordinator = ImagePickerCoordinator(rootNavigationController: rootNavigationController)
        imagePickerCoordinator.delegate = self
        childCoordinators.append(imagePickerCoordinator)
        imagePickerCoordinator.start()
    }
}

// MARK: - ImagePickerCoordinatorDelegate
extension NotesCoordinator: ImagePickerCoordinatorDelegate {
    func didFinishPicking(coordinator: ImagePickerCoordinator, _ image: UIImage) {
        removeAllChildCoordinatorsWithType(type(of: coordinator))
        complition?(image)
    }
}

// MARK: - Images
private extension Images {
    static let addPhotoImage = "plus"
}
