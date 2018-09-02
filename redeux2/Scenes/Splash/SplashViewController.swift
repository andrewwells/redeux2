//
//  SplashViewController.swift
//  redeux
//
//  Created by Andrew Wells on 8/26/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SplashViewController: ReactiveViewController<SplashReactor> {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.text = NSLocalizedString("Redeux2", comment: "")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setup()
    }
    
    private func setup() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func bind(reactor: SplashReactor) {
        super.bind(reactor: reactor)
        
        _ = Observable.just(())
            .map { _ in SplashReactor.Action.validateSession }
            .bind(to: reactor.action)
        
        let delay = Observable<Int>.timer(1, scheduler: MainScheduler.instance).map { _ in () }
        let validateSession = reactor.state.filter { $0.sessionValidated != nil }
        
        Observable.combineLatest(validateSession, delay)
            .map { _ in SplashReactor.Action.complete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
