internal enum ViperComponent: String {
    case view
    case interactor
    case presenter
    case router
}


public protocol VIPComponent {
  init()
}
