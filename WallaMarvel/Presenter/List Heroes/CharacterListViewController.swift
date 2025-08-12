import UIKit
import Combine

final class CharacterListViewController: UIViewController {
    private lazy var contentView: CharacterListContentView = {
        let component = CharacterListContentView()
        component.translatesAutoresizingMaskIntoConstraints = false
        component.delegate = self
        return component
    }()
    
    private let presenter: CharacterListPresenter
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
        view.addSubview(contentView)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func bind() {
        presenter.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state, dataProvider) in
                guard let self else { return }
                contentView.update(state: state, dataProvider: dataProvider)
            }
            .store(in: &cancellables)
    }
}

extension CharacterListViewController: CharacterListContentViewDelegate {
    func didTapLoadMore() {
        presenter.loadCharacters()
    }
}
