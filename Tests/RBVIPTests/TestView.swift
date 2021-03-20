//
//  File.swift
//  
//
//  Created by Rezuan Bidzhiev on 20.03.2021.
//

import UIKit
import RBVIP

class TestView: UIViewController, UserInterfaceProtocol {
  var _interactor: InteractorProtocol!
  
}


enum AppModules: String, VIPModule {
  case test
  
  var viewType: VIPViewType {
    return .code
  }
}
