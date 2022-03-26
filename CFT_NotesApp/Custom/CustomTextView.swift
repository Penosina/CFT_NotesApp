import UIKit

class CustomTextView: UITextView {
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        textContainerInset = UIEdgeInsets(top: 18, left: 24, bottom: 18, right: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
