
import UIKit

final class ListStateViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private lazy var contentStackView: UIStackView = {
        let component = UIStackView()
        component.axis = .horizontal
        component.alignment = .center
        component.spacing = 8
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let component = UIActivityIndicatorView(style: .medium)
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var icon: UIImageView = {
        let component = UIImageView()
        component.contentMode = .scaleAspectFit
        component.tintColor = .systemRed
        component.preferredSymbolConfiguration = .init(pointSize: 16, weight: .semibold)
        component.image = UIImage(systemName: "exclamationmark.triangle.fill")
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var label: UILabel = {
        let component = UILabel()
        component.font = .preferredFont(forTextStyle: .body)
        component.textColor = .secondaryLabel
        component.adjustsFontForContentSizeCategory = true
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var button: UIButton = {
        let component = UIButton(type: .system)
        component.setTitle("Load more", for: .normal)
        component.isUserInteractionEnabled = false
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    // MARK: - Private Properties
    
    private var state: CharacterListDataProvider.ListState = .empty
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentStackView.addArrangedSubview(spinner)
        contentStackView.addArrangedSubview(icon)
        contentStackView.addArrangedSubview(label)
        contentStackView.addArrangedSubview(button)
        
        contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        icon.setContentHuggingPriority(.required, for: .horizontal)
        spinner.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        spinner.stopAnimating()
    }
    
    // MARK: - Internal Methods
    
    func apply(state: CharacterListDataProvider.ListState) {
        self.state = state
        spinner.stopAnimating()
        icon.isHidden = true
        label.isHidden = false
        button.isHidden = true
        
        switch state {
        case .loadMore:
            button.isHidden = false
            label.isHidden = true
            
        case .loading:
            spinner.startAnimating()
            label.text = "Loading"
            
        case .error:
            icon.isHidden = false
            label.text = "Error. Tap to retry."
            
        case .reachEnd:
            icon.isHidden = false
            label.text = "No more data available"
            
        case .empty:
            icon.isHidden = false
            label.text = "No available data"
        }
    }
}
