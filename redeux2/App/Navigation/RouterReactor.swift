//
//  RouterReactor.swift
//  redeux2
//
//  Created by Andrew Wells on 8/28/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//

import ReactorKit
import RxSwift

import UIKit

final class RouterReactor: Reactor {
    
    enum Action {
        case push(UIViewController)
        case pop
        case set([UIViewController])
    }
    
    enum Mutation {
        case push(UIViewController)
        case set([UIViewController])
        case none
    }
    
    struct State {
        let views: [UIViewController]
    }
    
    let initialState = State(views: [])
}

extension RouterReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .push(let view):
            return .just(.push(view))
        case .set(let views):
            return .just(.set(views))
        default:
            return .just(.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .set(views):
            return State(views: views)
        case let .push(view):
            var views = state.views
            views.append(view)
            return State(views: views)
        case .none:
            return state
        }
    }
}

