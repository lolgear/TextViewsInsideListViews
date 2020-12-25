//
//  RootViewController.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 25.12.2020.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    private var viewModel: ViewModel
    private var tabBarViewController: UITabBarController = .init()
    
    init(_ model: ViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUIElements()
    }
}

extension RootViewController {
    func setupUIElements() {
        self.configureTabBar()
        self.addLayout()
    }
    func configureTabBar() {
        self.addChild(self.tabBarViewController)
        self.view.addSubview(self.tabBarViewController.view)
        self.tabBarViewController.viewControllers = self.viewModel.viewModels.map(ViewController.init)
        self.tabBarViewController.didMove(toParent: self)
    }
    func addLayout() {
        self.tabBarViewController.view.embedInParent()
    }
}
