import UIKit

final class NotesCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator]
    var rootNavigationController: UINavigationController
    
    private let dependencies: Dependencies
    private let notesViewModel: NotesViewModel
    
    // MARK: - Init
    init(dependencies: Dependencies, rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
        childCoordinators = []
        self.dependencies = dependencies
        self.notesViewModel = NotesViewModel(dependencies: dependencies)
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
        let noteVC = NoteViewController(viewModel: noteViewModel)
        rootNavigationController.pushViewController(noteVC, animated: true)
    }
}
