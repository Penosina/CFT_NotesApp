import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator]
    var rootNavigationController: UINavigationController

    private let window: UIWindow?
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(window: UIWindow?) {
        self.window = window
        childCoordinators = []
        rootNavigationController = UINavigationController()
        dependencies = Dependencies(coreDataSevice: CoreDataService())
        rootNavigationController.navigationBar.tintColor = .systemIndigo
    }
    
    // MARK: - Public Methods
    func start() {
        guard let window = window else { return }
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        if !UserDefaults.standard.bool(forKey: Strings.firstStart) {
            addTestNote()
        }
        
        let startCoordinator = NotesCoordinator(dependencies: dependencies,
                                                rootNavigationController: rootNavigationController)
        childCoordinators.append(startCoordinator)
        startCoordinator.start()
    }
    
    // MARK: - Private Methods
    private func addTestNote() {
        let note = Note(id: 0, title: "Заголовок", text: "Описание")
        dependencies.coreDataSevice.addOrUpdateNote(note: note)
        UserDefaults.standard.set(true, forKey: Strings.firstStart)
    }
}

// MARK: - Strings
private extension Strings {
    static let firstStart = "firstStart"
}
