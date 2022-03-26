import UIKit
import SnapKit

class NoteViewController: BaseViewController {
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let titleTextView = CustomTextView()
    private let descriptionTextView = CustomTextView()
    private let viewModel: NoteViewModel
    
    // MARK: - Init
    init(viewModel: NoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        viewModel.start()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.addOrUpdateNote(title: titleTextView.text,
                                  description: descriptionTextView.text)
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleTextView)
        scrollView.addSubview(descriptionTextView)
        
        setupScrollView()
        setupTitleTextView()
        setupDescriptionTextView()
    }
    
    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
    }
    
    private func setupTitleTextView() {
        titleTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.width.equalToSuperview()
        }
        
        titleTextView.font = .systemFont(ofSize: Dimensions.large)
        titleTextView.isScrollEnabled = false
        titleTextView.delegate = self
        textViewDidChange(descriptionTextView)
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleTextView.snp.bottom).offset(Dimensions.standart)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalToSuperview()
        }
        
        descriptionTextView.font = .systemFont(ofSize: Dimensions.medium)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.delegate = self
        textViewDidChange(descriptionTextView)
    }
    
    private func bindToViewModel() {
        viewModel.didUpdateData = { [weak self] in
            self?.titleTextView.text = self?.viewModel.title
            self?.descriptionTextView.text = self?.viewModel.text
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

