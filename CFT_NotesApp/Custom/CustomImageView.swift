import UIKit

class CustomImageView: UIImageView {
    // MARK: - Properties
    var currentImage: UIImage? {
        get {
            return self.image
        }
        set(value) {
            self.image = value
            clearButton.isHidden = value == nil
        }
    }
    
    private let clearButton = UIButton()
    
    // MARK: - Actions
    @objc private func clearImageView() {
        currentImage = nil
    }
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = Dimensions.standart
        layer.masksToBounds = true
    }
    
    // MARK: - Private Methods
    private func setup() {
        tintColor = .systemIndigo
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        
        addSubview(clearButton)
        setupClearButton()
    }
    
    private func setupClearButton() {
        clearButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Dimensions.small)
            make.size.equalTo(Dimensions.medium)
        }
        
        
        let buttonImage: UIImage? = .init(systemName: Images.clear)
        clearButton.setImage(buttonImage,
                             for: .normal)
        clearButton.addTarget(self, action: #selector(clearImageView), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Images
private extension Images {
    static let clear = "clear.fill"
}
