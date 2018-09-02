//
//  AppDelegate.swift
//  redeux2
//
//  Created by Andrew Wells on 8/28/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Toolbelt

// Temp
import RxSwift
import ReactorKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: Router?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let splashReactor = SplashReactor()
        let splashViewController = SplashViewController(reactor: splashReactor)
        
        let routerReactor = RouterReactor()
        router = Router(reactor: routerReactor, rootViewController: splashViewController)
        
        _ = splashReactor
            .action
            .filter { $0 == SplashReactor.Action.complete }
            .flatMap { _ in splashReactor.state }
            .map { state in
                
                let vc: UIViewController
                
                if state.sessionValidated! {
                    vc = UIViewController()
                    vc.view.backgroundColor = .white
                } else {
                    vc = SignInViewController(reactor: SignInReactor())
                }
                
                return RouterReactor.Action.set([vc])
            }
            .takeUntil(splashViewController.rx.deallocated)
            .bind(to: routerReactor.action)
        
        
        // Setup Keyboard Manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        window = UIWindow()
        window!.makeKeyAndVisible()
        
        window?.rootViewController = router?.nav
        
        return true
    }
}

