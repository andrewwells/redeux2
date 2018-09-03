//
//  SignInReactor.swift
//  redeux2
//
//  Created by Andrew Wells on 9/1/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import ReactorKit
import RxSwift

enum AuthError: Error {
    case unauthorized
}

protocol AuthProviderType {
    func signIn(email: String, password: String) -> Observable<Session>
}

class AuthProvider: AuthProviderType {
    func signIn(email: String, password: String) -> Observable<Session> {
        return Observable<Int>.timer(2, scheduler: MainScheduler.instance)
            .take(1)
            .map { _ in
                if email.lowercased() == "andrew@email.com"
                    && password.lowercased() == "123123" {
                    return Session(accessToken: "token")
                }
                throw AuthError.unauthorized
            }
    }
}

final class SignInReactor: Reactor {
    
    let authProvider: AuthProviderType
    
    init(authProvider: AuthProviderType) {
        self.authProvider = authProvider
    }
    
    enum Action {
        case updateEmail(String?)
        case updatePassword(String?)
        case signIn
        case complete
    }
    
    enum Mutation {
        case setEmail(String?)
        case setPassword(String?)
        case setSession(Session)
        case setError(AuthError?)
        case setComplete
    }
    
    struct State {
        let email: String?
        let password: String?
        let session: Session?
        let error: AuthError?
        let complete: Bool

        func email(_ email: String?) -> State {
            return State(email: email, password: password, session: session, error: nil, complete: complete)
        }
        
        func password(_ password: String?) -> State {
            return State(email: email, password: password, session: session, error: nil, complete: complete)
        }
        
        func error(_ error: AuthError?) -> State {
            return State(email: email, password: password, session: session, error: error, complete: complete)
        }
        
        func session(_ session: Session?) -> State {
            return State(email: email, password: password, session: session, error: nil, complete: complete)
        }
        
        func complete(_ complete: Bool) -> State {
            return State(email: email, password: password, session: session, error: nil, complete: complete)
        }
    }
    
    let initialState = State(email: nil, password: nil, session: nil, error: nil, complete: false)
    
    func mutate(action: SignInReactor.Action) -> Observable<SignInReactor.Mutation> {
        switch action {
        case .updateEmail(let email):
            return .just(.setEmail(email))
        case .updatePassword(let password):
            return .just(.setPassword(password))
        case .signIn:
            guard let email = currentState.email,
                let password = currentState.password else { return .just(.setError(.unauthorized)) }
            return authProvider.signIn(email: email, password:password)
                .map { .setSession($0) }
                .catchError { .just(Mutation.setError($0 as? AuthError)) }
        case .complete:
            return .just(Mutation.setComplete)
        }
    }
    
    func reduce(state: SignInReactor.State, mutation: SignInReactor.Mutation) -> SignInReactor.State {
        switch mutation {
        case .setEmail(let email):
            return state.email(email)
        case .setPassword(let password):
            return state.password(password)
        case .setSession(let session):
            return state.session(session)
        case .setError(let error):
            return state.error(error)
        case .setComplete:
            return state.complete(true)
        }
    }
}
