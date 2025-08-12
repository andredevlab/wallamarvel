import UIKit
import Kingfisher

final class CharacterItemViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private lazy var contentStackView: UIStackView = {
        let component = UIStackView()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var heroeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        addSubviews()
        addContraints()
    }
    
    private func addSubviews() {
        contentStackView.spacing = 12
        contentStackView.axis = .horizontal
        
        contentStackView.addArrangedSubview(heroeImageView)
        contentStackView.addArrangedSubview(heroeName)
        addSubview(contentStackView)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            
            heroeImageView.heightAnchor.constraint(equalToConstant: 80),
            heroeImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    // MARK: - Internal Methods
    
    func configure(characterViewModel: CharacterViewModel) {
        heroeName.text = characterViewModel.name
        heroeImageView.kf.setImage(with: characterViewModel.imageURL)
        
        heroeImageView.kf.indicatorType = .activity
        
        let size = CGSize(width: 160, height: 160)
        let processor = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
        
        heroeImageView.kf.setImage(
            with: characterViewModel.imageURL,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .backgroundDecode
            ])
    }
}
