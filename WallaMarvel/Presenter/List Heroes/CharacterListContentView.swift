import UIKit

final class CharacterListContentView: UIView {
    enum State {
        case loading
        case content
        case empty
        case error(message: String)
    }

    private lazy var heroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListHeroesTableViewCell.self, forCellReuseIdentifier: "ListHeroesTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var retryButton: UIButton = {
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
    
    private lazy var dataSource = makeDataSource()
    
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
    
    func update(state: ListHeroesState) {
        heroesTableView.isHidden = true
        errorStackView.isHidden = true
        emptyLabel.isHidden = true
        
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .loaded(let dataProvider):
            activityIndicator.stopAnimating()
            heroesTableView.isHidden = false
            let snapshot = dataProvider.snapshot()
            dataSource.apply(snapshot)
        case .empty:
            activityIndicator.stopAnimating()
            emptyLabel.isHidden = false
        case .error(let error):
            activityIndicator.stopAnimating()
            errorStackView.isHidden = false
            errorLabel.text = error.localizedDescription
        case .idle:
            break
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<CharacterListDataProvider.Section,
                                                                   CharacterListDataProvider.Item> {
        UITableViewDiffableDataSource(tableView: heroesTableView) { tableView, indexPath, item in
            // TODO: - Move cell configuration to another component (Visitor or Configurator pattern)
            switch item {
            case .characterItem(let characterViewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeroesTableViewCell",
                                                               for: indexPath) as? ListHeroesTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(characterViewModel: characterViewModel)
                return cell
            }
        }
    }
}
