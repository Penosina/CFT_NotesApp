import UIKit

class CustomTextView: UITextView {
    // MARK: - Properties
    var placeholder: String {
        get {
            placeholderLabel.text ?? ""
        }
        set(value) {
            placeholderLabel.text = value
        }
    }
    
    var placeholderIsHidden: Bool {
        get {
            placeholderLabel.isHidden
        }
        set(value) {
            placeholderLabel.isHidden = value
        }
    }
    
    private let placeholderLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    // MARK: - Public Methods
    func configure() {
        placeholderLabel.font = font
    }
    
    // MARK: - Private Methods
    private func setup() {
        textContainerInset = UIEdgeInsets(top: Dimensions.standart,
                                          left: Dimensions.standart,
                                          bottom: Dimensions.standart,
                                          right: Dimensions.standart)
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(Dimensions.placeholderInset)
        }
        
        placeholderLabel.textAlignment = .left
        placeholderLabel.textColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Dimensions
private extension Dimensions {
    static let placeholderInset = 18.0
}
