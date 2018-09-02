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
        
        let delay = Observable<Int>.timer(2, scheduler: MainScheduler.instance).take(1).map { _ in () }
        let validateSession = reactor.state.filter { $0.sessionValidated != nil }.map { _ in () }
        
        Observable.combineLatest(delay, validateSession)
            .map { _ in SplashReactor.Action.complete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.sessionValidated == nil }
            .map { _ in SplashReactor.Action.validateSession }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
