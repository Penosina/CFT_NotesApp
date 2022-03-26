import UIKit
import SnapKit

class NotesViewController: BaseViewController {
    // MARK: - Properties
    private let tableView = UITableView()
    private let createButton = CustomButton()
    private let viewModel: NotesViewModel
    
    // MARK: - Actions
    @objc private func createNewNote() {
        viewModel.createNewNote()
    }
    
    // MARK: - Init
    init(viewModel: NotesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
        title = Strings.title
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.start()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.addSubview(tableView)
        view.addSubview(createButton)
        
        setupTableView()
        setupCreateButton()
    }
    
    private func setupTableView() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(createButton.snp.top).offset(-Dimensions.standart)
        }
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(NoteCellView.self, forCellReuseIdentifier: Strings.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupCreateButton() {
        createButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.standart)
            make.height.equalTo(Dimensions.standartHeight)
        }
        
        createButton.configure(withTitle: Strings.createNote)
        createButton.addTarget(self, action: #selector(createNewNote), for: .touchUpInside)
    }
    
    private func bindToViewModel() {
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showError(error)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension NotesViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.reuseIdentifier,
                                                       for: indexPath) as? NoteCellView,
              indexPath.row < viewModel.countOfNotes else {
                  return UITableViewCell()
              }
        cell.configure(with: viewModel.getCellViewModel(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.countOfNotes else { return }
        
        viewModel.editNote(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < viewModel.countOfNotes else {
            return UISwipeActionsConfiguration()
        }
        
        let action = UIContextualAction(style: .normal,
                                        title: Strings.delete) { [weak self] action, view, completionHandler in
            self?.handleMoveToTrash(index: indexPath.row)
            completionHandler(true)
        }
        
        action.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    private func handleMoveToTrash(index: Int) {
        viewModel.deleteNote(index: index)
    }
}

// MARK: - Strings
private extension Strings {
    static let title = "Заметки"
    static let createNote = "Создать новую заметку"
    static let reuseIdentifier = "NoteCellView"
    static let delete = "Удалить"
}

// MARK: - Dimensions
private extension Dimensions {
    static let cellHeight = 180.0
}
