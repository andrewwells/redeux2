//
//  Router.swift
//  redeux2
//
//  Created by Andrew Wells on 8/28/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class Router: View {
    
    var disposeBag = DisposeBag()
    
    let nav = UINavigationController()
    
    convenience init(reactor: RouterReactor, rootViewController: UIViewController? = nil) {
        self.init()
        self.reactor = reactor
        if let rootViewController = rootViewController {
            self.nav.viewControllers = [rootViewController]
        }
    }
    
    init() {
    }
    
    func bind(reactor: RouterReactor) {
        
        reactor.action
            .debug()
            .observeOn(MainScheduler.instance)
            .do(onNext: { action in
                switch action {
                case .push(let view):
                    self.nav.pushViewController(view, animated: true)
                case .set(let views):
                    return self.nav.viewControllers = views
                default: break
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
    }
}
