import Foundation

protocol CharacterListItemVisitor {
    func visit(_ viewModel: CharacterListItemViewModel)
    func visit(_ viewModel: CharacterListStateViewModel)
}
