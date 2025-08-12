import Foundation
import UIKit
import Kingfisher

final class ListHeroesTableViewCell: UITableViewCell {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configure(characterViewModel: CharacterViewModel) {
        heroeName.text = characterViewModel.name
        
        if let thumbnailPath = characterViewModel.thumbnailPath,
            let thumbnailExtension = characterViewModel.thumbnailExtension{
            let urlString = thumbnailPath + "/portrait_small." + thumbnailExtension
            heroeImageView.kf.setImage(with: URL(string: urlString))
        }
    }
}
