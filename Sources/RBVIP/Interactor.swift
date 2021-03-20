import Foundation

public protocol InteractorProtocol: VIPComponent {
    var _presenter: PresenterProtocol! { get set }
}

open class Interactor: InteractorProtocol {
    public weak var _presenter: PresenterProtocol!
    
    required public init() { }
}
