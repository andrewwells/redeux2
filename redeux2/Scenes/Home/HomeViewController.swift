//
//  HomeViewController.swift
//  redeux2
//
//  Created by Andrew Wells on 9/2/18.
//  Copyright © 2018 Andrew Wells. All rights reserved.
//


final class HomeViewController: ReactiveViewController<HomeReactor> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Home"
    }
    
}
