import UIKit
import SnapKit

class NoteCellView: UITableViewCell {
    // MARK: - Properties
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let attachmentImageView = UIImageView()
    private var viewModel: NoteCellViewModel?
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    // MARK: - Public Methods
    func configure(with viewModel: NoteCellViewModel) {
        setup()
        
        self.viewModel = viewModel
        bindToViewModel()
        self.viewModel?.start()
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        horizontalStackView.addArrangedSubview(attachmentImageView)
        
        setupHorizontalStackView()
        setupVerticalStackView()
        setupTitleLabel()
        setupDescriptionLabelLabel()
        setupAttachmentImageView()
    }
    
    private func setupHorizontalStackView() {
        horizontalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Dimensions.standart)
            make.top.bottom.equalToSuperview().inset(Dimensions.small)
        }
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = Dimensions.small
    }
    
    private func setupVerticalStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Dimensions.small
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: Dimensions.standart)
    }
    
    private func setupDescriptionLabelLabel() {
        descriptionLabel.numberOfLines = 3
        descriptionLabel.font = .systemFont(ofSize: Dimensions.small)
    }
    
    private func setupAttachmentImageView() {
        attachmentImageView.contentMode = .scaleAspectFill
        attachmentImageView.layer.cornerRadius = Dimensions.small
        attachmentImageView.layer.masksToBounds = true
    }
    
    private func updateAttachmentWidth() {
        let dimension = attachmentImageView.image == nil ? 0.0 : Dimensions.standartHeight
        
        attachmentImageView.snp.removeConstraints()
        attachmentImageView.snp.makeConstraints { make in
            make.width.equalTo(dimension)
        }
    }
    
    private func bindToViewModel() {
        viewModel?.didUpdateData = { [weak self] in
            self?.titleLabel.text = self?.viewModel?.title
            self?.descriptionLabel.text = self?.viewModel?.text
            self?.attachmentImageView.image = self?.viewModel?.image
            self?.updateAttachmentWidth()
        }
    }
}

// MARK: - Dimensions
private extension Dimensions {
    static let imageViewSize = 100.0
}
