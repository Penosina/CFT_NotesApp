import UIKit

class NoteCellView: UITableViewCell {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var viewModel: NoteCellViewModel?
    
    // MARK: - Public Methods
    func configure(with viewModel: NoteCellViewModel) {
        setup()
        
        self.viewModel = viewModel
        bindToViewModel()
        self.viewModel?.start()
    }
    
    // MARK: - Private Methods
    private func setup() {        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        setupTitleLabel()
        setupDescriptionLabelLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Dimensions.standart)
            make.top.equalToSuperview().inset(Dimensions.small)
        }
        
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: Dimensions.standart)
    }
    
    private func setupDescriptionLabelLabel() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Dimensions.standart)
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimensions.small)
            make.bottom.equalToSuperview().inset(Dimensions.small)
        }
        
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: Dimensions.small)
    }
    
    private func bindToViewModel() {
        viewModel?.didUpdateData = { [weak self] in
            self?.titleLabel.text = self?.viewModel?.title
            self?.descriptionLabel.text = self?.viewModel?.text
        }
    }
}
