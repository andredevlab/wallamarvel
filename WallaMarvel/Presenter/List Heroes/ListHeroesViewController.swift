import UIKit
import Combine

final class ListHeroesViewController: UIViewController {
    private lazy var contentView: CharacterListContentView = {
        let component = CharacterListContentView()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private let presenter: ListHeroesPresenter
    private var cancellables = Set<AnyCancellable>()
    
    init(presenter: ListHeroesPresenter) {
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
        
        bind()
        presenter.getHeroes()
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
            .sink { [weak self] state in
                guard let self else { return }
                contentView.update(state: state)
            }
            .store(in: &cancellables)
    }
}
