import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif


//MARK: - Module View Types
public enum VIPViewType {
    case storyboard
    case nib
    case code
}

//MARK: - Viperit Module Protocol
public protocol VIPModule {
    var viewType: VIPViewType { get }
    var viewName: String { get }
    func build(bundle: Bundle, deviceType: UIUserInterfaceIdiom?) -> Module
}

public extension VIPModule where Self: RawRepresentable, Self.RawValue == String {
    var viewType: VIPViewType {
        return .storyboard
    }
    
    var viewName: String {
        return rawValue
    }
    
    func build(bundle: Bundle = Bundle.main, deviceType: UIUserInterfaceIdiom? = nil) -> Module {
        return Module.build(self, bundle: bundle, deviceType: deviceType)
    }
}
