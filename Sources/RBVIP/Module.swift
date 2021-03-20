//
//  Module.swift
//  Viperit
//
//  Created by Ferran on 11/09/2016.
//  Copyright © 2016 Ferran Abelló. All rights reserved.
//

import Foundation
import UIKit

private let kTabletSuffix = "Pad"

public protocol ViperitComponent {
    init()
}

//MARK: - Module
public struct Module {
    public private(set) var view: UserInterfaceProtocol
    public private(set) var interactor: InteractorProtocol
    public private(set) var presenter: PresenterProtocol
    public private(set) var router: RouterProtocol
    
    static func build<T: RawRepresentable & VIPModule>(_ module: T, bundle: Bundle = Bundle.main, deviceType: UIUserInterfaceIdiom? = nil) -> Module where T.RawValue == String {
        //Get class types
        let interactorClass = module.classForViperComponent(.interactor, bundle: bundle) as! InteractorProtocol.Type
        let presenterClass = module.classForViperComponent(.presenter, bundle: bundle) as! PresenterProtocol.Type
        let routerClass = module.classForViperComponent(.router, bundle: bundle) as! RouterProtocol.Type
   

        //Allocate VIPER components
        let V = loadView(forModule: module, bundle: bundle, deviceType: deviceType)
        let I = interactorClass.init()
        let P = presenterClass.init()
        let R = routerClass.init()
        
        return build(view: V, interactor: I, presenter: P, router: R)
    }
}

//MARK: - Helper Methods
extension Module {
    
    static func loadView<T: RawRepresentable & VIPModule>(forModule module: T, bundle: Bundle, deviceType: UIUserInterfaceIdiom? = nil) -> UserInterfaceProtocol where T.RawValue == String {

        let viewClass = module.classForViperComponent(.view, bundle: bundle, deviceType: deviceType) as! UIViewController.Type
        let viewIdentifier = safeString(NSStringFromClass(viewClass).components(separatedBy: ".").last)
        let viewName = module.viewName.uppercasedFirst
        
        switch module.viewType {
        case .nib:
            return viewClass.init(nibName: viewName, bundle: bundle) as! UserInterfaceProtocol
        case .code:
            return viewClass.init() as! UserInterfaceProtocol
        default:
            let sb = UIStoryboard(name: viewName, bundle: bundle)
            return sb.instantiateViewController(withIdentifier: viewIdentifier) as! UserInterfaceProtocol
        }
    }
    
    static func build(view: UserInterfaceProtocol,
                      interactor: InteractorProtocol,
                      presenter: PresenterProtocol,
                      router: RouterProtocol) -> Module {
        //View connections
        view._interactor = interactor
        
        //Interactor connections
        var interactor = interactor
        interactor._presenter = presenter
        //Presenter connections
        presenter._view = view
        
        //Router connections
        var router = router
//      router = presenter
        
        return Module(view: view,
                      interactor: interactor,
                      presenter: presenter,
                      router: router)
    }
}


//MARK: - Private Extension for Application Module generic enum
extension RawRepresentable where RawValue == String {

    func classForViperComponent(_ component: ViperComponent, bundle: Bundle, deviceType: UIUserInterfaceIdiom? = nil) -> Swift.AnyClass? {
        let className = rawValue.uppercasedFirst + component.rawValue.uppercasedFirst
        let bundleName = safeString(bundle.infoDictionary?["CFBundleName"])
        let classInBundle = (bundleName + "." + className).replacingOccurrences(of: "[ -]", with: "_", options: .regularExpression)
        
        if component == .view {
            let deviceType = deviceType ?? UIScreen.main.traitCollection.userInterfaceIdiom
            let isPad = deviceType == .pad
            if isPad, let tabletView = NSClassFromString(classInBundle + kTabletSuffix) {
                return tabletView
            }
        }
        
        return NSClassFromString(classInBundle)
    }
}
