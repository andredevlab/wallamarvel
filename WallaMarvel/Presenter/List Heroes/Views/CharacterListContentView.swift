import UIKit

protocol CharacterListContentViewDelegate: AnyObject {
    func didTapLoadMore()
}

final class CharacterListContentView: UIView {

    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterItemViewCell.self, forCellReuseIdentifier: "CharacterItemViewCell")
        tableView.register(ListStateViewCell.self, forCellReuseIdentifier: "ListStateViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var dataSource = makeDataSource()
    weak var delegate: CharacterListContentViewDelegate?
    
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
    }
    
    private func addSubviews() {
        addSubview(charactersTableView)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            charactersTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            charactersTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            charactersTableView.topAnchor.constraint(equalTo: topAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<CharacterListDataProvider.Section,
                                                                   CharacterListDataProvider.Item> {
        UITableViewDiffableDataSource(tableView: charactersTableView) { tableView, indexPath, item in
            // TODO: - Move cell configuration to another component (Visitor or Configurator pattern) - avoid breaking OCP
            switch item {
            case .listState(let listState):
                let cell = tableView.dequeueReusableCell(withIdentifier: "ListStateViewCell", 
                                                         for: indexPath) as! ListStateViewCell
                cell.apply(state: listState)
                
                return cell
            case .characterItem(let characterViewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterItemViewCell",
                                                               for: indexPath) as? CharacterItemViewCell else {
                    return UITableViewCell()
                }
                cell.configure(characterViewModel: characterViewModel)
                return cell
            }
        }
    }
    
    func update(state: CharacterListDataProvider.ListState, dataProvider: CharacterListDataProvider) {
        let snapshot = dataProvider.snapshot(with: state)
        dataSource.apply(snapshot)
    }
}

extension CharacterListContentView: UITableViewDelegate {
    // TODO: - Refact to use Visitor pattern on tap - avoid breaking OCP
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isLastItem = (indexPath.row + 1) == dataSource.snapshot().numberOfItems
        if isLastItem {
            delegate?.didTapLoadMore()
        }
    }
}
