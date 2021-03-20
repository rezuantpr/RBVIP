import UIKit

public protocol UserInterfaceProtocol: class, VIPComponent {
    var _interactor: InteractorProtocol! { get set }
}

public extension UserInterfaceProtocol {
    var viewController: UIViewController {
        return self as! UIViewController
    }
}
