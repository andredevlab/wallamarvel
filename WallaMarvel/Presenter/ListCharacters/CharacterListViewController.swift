import UIKit
import Combine

final class CharacterListViewController: UIViewController {
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        tableView.register(CharacterItemViewCell.self, forCellReuseIdentifier: "CharacterItemViewCell")
        tableView.register(ListStateViewCell.self, forCellReuseIdentifier: "ListStateViewCell")
        return tableView
    }()
    
    private let presenter: CharacterListPresenter
    private var dataProvider: CharacterListDataProvider?
    private lazy var dataSource = makeDataSource()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(presenter: CharacterListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addContraints()
        
        title = presenter.screenTitle()
        
        bind()
        presenter.loadCharacters()
    }
    
    private func addSubviews() {
        view.addSubview(charactersTableView)
    }
    
    private func addContraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            charactersTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            charactersTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            charactersTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func bind() {
        presenter.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state, dataProvider) in
                guard let self else { return }
                self.dataProvider = dataProvider
                
                let snapshot = dataProvider.snapshot(with: state)
                dataSource.apply(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<CharacterListDataProvider.Section, CharacterListDataProvider.Item> {
        UITableViewDiffableDataSource(tableView: charactersTableView) { [weak self] tableView, indexPath, item in
            guard let self,
                  let visitableItem = dataProvider?.visitableItem(for: indexPath)
            else { return UITableViewCell() }
            
            let visitor = CharacterListConfigureCellVisitor(tableView: tableView, indexPath: indexPath)
            visitableItem.accept(visitor)
            return visitor.cell
        }
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let visitableItem = dataProvider?.visitableItem(for: indexPath) else { return }
        let visitor = CharacterListDidSelectCellVisitor(presenter: presenter)
        visitableItem.accept(visitor)
    }
}
