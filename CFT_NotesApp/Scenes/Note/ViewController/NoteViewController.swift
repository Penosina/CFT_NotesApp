import UIKit
import SnapKit

class NoteViewController: BaseViewController {
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let titleTextView = CustomTextView()
    private let separatorView = UIView()
    private let descriptionTextView = CustomTextView()
    private let attachmentImageView = CustomImageView()
    private let viewModel: NoteViewModel
    
    // MARK: - Actions
    @objc private func deleteImage() {
        viewModel.deleteImage()
    }
    
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
                                  description: descriptionTextView.text,
                                  image: attachmentImageView.image)
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleTextView)
        scrollView.addSubview(separatorView)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(attachmentImageView)
        
        setupScrollView()
        setupTitleTextView()
        setupSeparatorView()
        setupDescriptionTextView()
        setupAttachmentImageView()
    }
    
    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupTitleTextView() {
        titleTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.width.equalToSuperview()
        }
        
        titleTextView.placeholder = Strings.enterTheTitle
        titleTextView.font = .systemFont(ofSize: Dimensions.large)
        titleTextView.configure()
        titleTextView.isScrollEnabled = false
        titleTextView.delegate = self
        textViewDidChange(titleTextView)
    }
    
    private func setupSeparatorView() {
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Dimensions.small)
            make.top.equalTo(titleTextView.snp.bottom).offset(Dimensions.small)
            make.height.equalTo(1)
        }
        
        separatorView.backgroundColor = .systemGray
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).offset(Dimensions.small)
        }
        
        descriptionTextView.placeholder = Strings.enterTheText
        descriptionTextView.font = .systemFont(ofSize: Dimensions.medium)
        descriptionTextView.configure()
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.delegate = self
        textViewDidChange(descriptionTextView)
    }
    
    private func setupAttachmentImageView() {
        attachmentImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Dimensions.standart)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(Dimensions.small)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
            make.height.lessThanOrEqualTo(Dimensions.attachmentHeight)
        }
    }
    
    private func bindToViewModel() {
        viewModel.didUpdateData = { [weak self] in
            self?.titleTextView.text = self?.viewModel.title
            self?.descriptionTextView.text = self?.viewModel.text
            self?.attachmentImageView.currentImage = self?.viewModel.image
        }
        
        viewModel.didSetImage = { [weak self] image in
            self?.attachmentImageView.currentImage = image
        }
        
        viewModel.didDeleteImage = { [weak self] in
            self?.attachmentImageView.currentImage = nil
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
        
        guard let textView = textView as? CustomTextView else { return }
        
        textView.placeholderIsHidden = !textView.text.isEmpty
    }
}

// MARK: - Strings
private extension Strings {
    static let enterTheTitle = "Введите название"
    static let enterTheText = "Введите текст"
}

// MARK: - Dimensions
private extension Dimensions {
    static let attachmentHeight = 250.0
}

// MARK: - Images
private extension Images {
    static let deleteImage = "clear"
}
