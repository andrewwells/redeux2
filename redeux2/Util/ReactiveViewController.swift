//
//  ReactiveViewController.swift
//  redeux2
//
//  Created by Andrew Wells on 9/1/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import Toolbelt

class ReactiveViewController<T: Reactor>: UIViewController, View {
    
    typealias Reactor = T
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let viewDidLoadSubj = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSubj.onNext(())
    }
    
    convenience init(reactor: T) {
        self.init()
        self.reactor = reactor
    }
    
    func bind(reactor: T) {
    }
    
    deinit {
        Log.d("----DEINIT-----")
    }
}

