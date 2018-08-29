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
import ReSwift
import ReRxSwift
import ToolbeltUI

extension SignInViewController: Connectable {
    
    struct Props {
//        let username: String?
//        let password: String?
    }
    struct Actions {
        let updateUsername: (String) -> Void
        let updatePassword: (String) -> Void
    }
}

class SignInViewController: UIViewController {
    
    let connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("Enter Username", comment: "")
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = NSLocalizedString("Sign In", comment: "")
        
        setup()
        setupObservables()
    }
    
    private func setupObservables() {
        
        // connection.bind(\Props.username, to: usernameTextField.rx.text)
        // connection.bind(\Props.password, to: passwordTextField.rx.text)
        
        _ = usernameTextField.rx.text
            .orEmpty // Make it non-optional
            .skip(1)
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged()
            .takeUntil(self.rx.deallocated)
            .do(onNext: { [weak self] text in
                self?.actions.updateUsername(text)
            })
            .subscribe()
        
        _ = passwordTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .takeUntil(self.rx.deallocated)
            .do(onNext: { [weak self] text in
                self?.actions.updatePassword(text)
            })
            .subscribe()
        
    }
    
    private func setup() {
        
        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        container.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        container.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        connection.disconnect()
    }
}

private let mapStateToProps = { (appState: AppState) in
    return SignInViewController.Props(
//        username: appState.signInState.username,
//        password: appState.signInState.password
    )
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return SignInViewController.Actions(
        updateUsername: { username in dispatch(SignInActionUpdateUsername(text: username)) },
        updatePassword: { password in dispatch(SignInActionUpdatePassword(text: password)) }
    )
}

