//
//  SignInViewController.swift
//  redeux
//
//  Created by Andrew Wells on 8/26/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ToolbeltUI
import Toolbelt

class SignInViewController: ReactiveViewController<SignInReactor> {
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("Enter Email", comment: "")
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("Enter Password", comment: "")
        return tf
    }()
    
    private lazy var signInButton: BaseButton = {
        let button = BaseButton()
        button.textLabel.text = NSLocalizedString("Sign In", comment: "")
        button.cornerRadius = 4.0
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = NSLocalizedString("Sign In", comment: "")
        
        setup()
    }
    
    // MARK: - Reactive
    override func bind(reactor: SignInReactor) {
        
        // MARK: - Actions
        signInButton.rx.controlEvent(.touchUpInside)
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.doShowProgress(for: self.view)
            })
            .map { _ in Reactor.Action.signIn }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: -  State
        reactor.state.map { $0.validEmailAndPassword }
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.error}
            .filter { $0 != nil }
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] err in
                Log.e("\(err!)")
                guard let `self` = self else { return }
                self.doShowMessage("Something Went Wrong!", for: self.view)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.session }
            .filter { $0 != nil }
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] session in
                guard let `self` = self else { return }
                self.doShowMessage("Successfully Signed In!", for: self.view)
            })
            .delay(1, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.complete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        
        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        container.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        container.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(container)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
}

extension SignInReactor.State {
    
    var validEmailAndPassword: Bool {
       return validEmail && validPassword
    }
    
    var validEmail: Bool {
        guard let email = email else { return false }
        return !email.isEmpty
    }
    
    var validPassword: Bool {
        guard let password = password else { return false }
        return !password.isEmpty
    }
}
