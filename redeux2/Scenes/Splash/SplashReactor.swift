//
//  SplashReactor.swift
//  redeux2
//
//  Created by Andrew Wells on 8/29/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import ReactorKit
import RxSwift

final class SplashReactor: Reactor {
    
    enum Action {
        case validateSession
        case complete
    }
    
    enum Mutation {
        case updateAuthorization(authorized: Bool)
        case none
    }
    
    struct State {
        let sessionValidated: Bool?
        
        func sessionValidated(_ sessionValidated: Bool?) -> State {
            return State(sessionValidated: sessionValidated)
        }
    }
    
    let initialState = State(sessionValidated: nil)
    
    func mutate(action: SplashReactor.Action) -> Observable<SplashReactor.Mutation> {
        switch action {
        case .validateSession:
            return Observable<Int>.timer(2, scheduler: MainScheduler.instance)
                .map { _ in .updateAuthorization(authorized:false) }
        case .complete:
            return .just(.none)
        }
    }
    
    func reduce(state: SplashReactor.State, mutation: SplashReactor.Mutation) -> SplashReactor.State {
        switch mutation {
        case .updateAuthorization(let authorized):
            return state.sessionValidated(authorized)
        default:
            return state
        }
    }
}
