import Foundation


public protocol PresenterProtocol: class, VIPComponent {
    var _view: UserInterfaceProtocol! { get set }
}
