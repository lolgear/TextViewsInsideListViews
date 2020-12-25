//
//  RootViewController+ViewModel.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 25.12.2020.
//

import Foundation

fileprivate typealias Namespace = RootViewController

extension Namespace {
    class ViewModel {
        typealias ChildViewModel = ViewController.ViewModel
        static func allViewModels() -> [ChildViewModel] {
            let options: [ChildViewModel.Options] = [
                .tableView,
                .tableViewController,
                .collectionView,
                .collectionViewController
            ]
            return options.map({ ChildViewModel.init().configured($0) })
        }
        
        var viewModels: [ChildViewModel] = ViewModel.allViewModels()
    }
}
