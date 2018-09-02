//
//  SignInReactor.swift
//  redeux2
//
//  Created by Andrew Wells on 9/1/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import ReactorKit
import RxSwift

final class SignInReactor: Reactor {
    
    enum Action {
        case updateEmail(String?)
        case updatePassword(String?)
        case signIn
    }
    
    enum Mutation {
        case setEmail(String?)
        case setPassword(String?)
        case didSignIn
    }
    
    struct State {
        let email: String?
        let password: String?

        func email(_ email: String?) -> State {
            return State(email: email, password: password)
        }
        
        func password(_ password: String?) -> State {
            return State(email: email, password: password)
        }
    }
    
    let initialState = State(email: nil, password: nil)
    
    func mutate(action: SignInReactor.Action) -> Observable<SignInReactor.Mutation> {
        switch action {
        case .updateEmail(let email):
            return .just(.setEmail(email))
        case .updatePassword(let password):
            return .just(.setPassword(password))
        case .signIn:
            return Observable<Int>
                .timer(3, scheduler: MainScheduler.instance)
                .map { _ in .didSignIn }
        }
    }
    
    func reduce(state: SignInReactor.State, mutation: SignInReactor.Mutation) -> SignInReactor.State {
        switch mutation {
        case .setEmail(let email):
            return state.email(email)
        case .setPassword(let password):
            return state.password(password)
        default:
            return state
        }
    }
}
