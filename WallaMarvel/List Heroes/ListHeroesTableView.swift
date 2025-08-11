import Foundation
import UIKit

final class ListHeroesView: UIView {
    enum Constant {
        static let estimatedRowHeight: CGFloat = 120
    }
    
    enum State {
        case loading
        case content
        case empty
        case error(message: String)
    }

    lazy var heroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListHeroesTableViewCell.self, forCellReuseIdentifier: "ListHeroesTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRowHeight
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var errorStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "No heroes found"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        addContraints()
        update(state: .loading)
    }
    
    private func addSubviews() {
        addSubview(heroesTableView)
        addSubview(activityIndicator)
        addSubview(errorStackView)
        addSubview(emptyLabel)
        
        errorStackView.addArrangedSubview(errorLabel)
        errorStackView.addArrangedSubview(retryButton)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            heroesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroesTableView.topAnchor.constraint(equalTo: topAnchor),
            heroesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func update(state: State) {
        heroesTableView.isHidden = true
        errorStackView.isHidden = true
        emptyLabel.isHidden = true
        
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .content:
            activityIndicator.stopAnimating()
            heroesTableView.isHidden = false
        case .empty:
            activityIndicator.stopAnimating()
            emptyLabel.isHidden = false
        case .error(let message):
            activityIndicator.stopAnimating()
            errorStackView.isHidden = false
            errorLabel.text = message
        }
    }
}
