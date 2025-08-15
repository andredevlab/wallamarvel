import UIKit
import Combine

final class CharacterListViewController: UIViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Characters by Name"
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CharacterItemViewCell.self, forCellReuseIdentifier: "CharacterItemViewCell")
        tableView.register(ListStateViewCell.self, forCellReuseIdentifier: "ListStateViewCell")
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let presenter: CharacterListPresenter
    private let characterListDataProvider: CharacterListDataProvider
    private lazy var dataSource = makeDataSource()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(presenter: CharacterListPresenter, characterListDataProvider: CharacterListDataProvider) {
        self.presenter = presenter
        self.characterListDataProvider = characterListDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addContraints()
        setupUI()
        
        title = presenter.screenTitle()
        
        setupSubscribers()
        presenter.loadCharacters()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(charactersTableView)
    }
    
    private func addContraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            charactersTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            charactersTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            charactersTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            charactersTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupSubscribers() {
        presenter.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                
                let snapshot = characterListDataProvider.snapshot(with: state)
                dataSource.apply(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<CharacterListDataProvider.Section, CharacterListDataProvider.Item> {
        UITableViewDiffableDataSource(tableView: charactersTableView) { [weak self] tableView, indexPath, item in
            guard let self,
                  let visitableItem = characterListDataProvider.visitableItem(for: indexPath)
            else { return UITableViewCell() }
            
            let visitor = CharacterListConfigureCellVisitor(tableView: tableView, indexPath: indexPath)
            visitableItem.accept(visitor)
            return visitor.cell
        }
    }
}

// MARK: - UITableViewDelegate

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let visitableItem = characterListDataProvider.visitableItem(for: indexPath) else { return }
        
        let visitor = CharacterListDidSelectCellVisitor(presenter: presenter)
        visitableItem.accept(visitor)
    }
}

// MARK: - UISearchBarDelegate

extension CharacterListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        presenter.loadCharacters(with: text.isEmpty ? .none : .name(text))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
