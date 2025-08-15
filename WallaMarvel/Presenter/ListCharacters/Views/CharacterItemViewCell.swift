import SwiftUI
import Kingfisher

final class CharacterItemViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private lazy var roundedContentView: UIView = {
        let component = UIView()
        component.backgroundColor = .systemFill.withAlphaComponent(0.2)
        component.layer.cornerRadius = 8
        component.layer.masksToBounds = true
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var contentStackView: UIStackView = {
        let component = UIStackView()
        component.alignment = .center
        component.spacing = 12
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleStatusSpacer: UIView = {
        return UIView()
    }()
    
    private lazy var heroeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let speciesTagHostingController = UIHostingController(rootView: Tag(text: ""))
    private let statusHostingController = UIHostingController(rootView: StatusBadge(status: ""))
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroeImageView.kf.cancelDownloadTask()
        heroeImageView.image = nil
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
       
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        
        addSubviews()
        addContraints()
    }
    
    private func addSubviews() {
        speciesTagHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        speciesTagHostingController.view.backgroundColor = .clear
        
        statusHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        statusHostingController.view.backgroundColor = .clear
        
        titleStackView.addArrangedSubview(heroeName)
        titleStackView.addArrangedSubview(titleStatusSpacer)
        titleStackView.addArrangedSubview(speciesTagHostingController.view)
        titleStackView.addArrangedSubview(statusHostingController.view)
        
        labelsStackView.addArrangedSubview(titleStackView)
        labelsStackView.addArrangedSubview(locationLabel)
        
        contentStackView.addArrangedSubview(heroeImageView)
        contentStackView.addArrangedSubview(labelsStackView)
        
        roundedContentView.addSubview(contentStackView)
        contentView.addSubview(roundedContentView)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            roundedContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            roundedContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            roundedContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            roundedContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            contentStackView.leadingAnchor.constraint(equalTo: roundedContentView.leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: roundedContentView.trailingAnchor, constant: -12),
            contentStackView.topAnchor.constraint(equalTo: roundedContentView.topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: roundedContentView.bottomAnchor, constant: -12),
            
            heroeImageView.heightAnchor.constraint(equalToConstant: 80),
            heroeImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        heroeName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        statusHostingController.view.setContentHuggingPriority(.required, for: .horizontal)
        statusHostingController.view.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        speciesTagHostingController.view.setContentHuggingPriority(.required, for: .horizontal)
        speciesTagHostingController.view.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: - Internal Methods
    
    func configure(viewModel: CharacterListItemViewModel) {
        heroeName.text = viewModel.name
        locationLabel.text = viewModel.location
        speciesTagHostingController.rootView = Tag(text: viewModel.species)
        statusHostingController.rootView = StatusBadge(status: viewModel.status, hasDescription: false)
        
        heroeImageView.kf.setImage(with: viewModel.imageURL)
        
        heroeImageView.kf.indicatorType = .activity
        
        let size = CGSize(width: 160, height: 160)
        let processor = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
        
        heroeImageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .backgroundDecode
            ])
    }
}
