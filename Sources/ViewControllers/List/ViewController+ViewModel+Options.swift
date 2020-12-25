//
//  ViewController+ViewModel+Options.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 25.12.2020.
//

import Foundation

fileprivate typealias Namespace = ViewController.ViewModel
fileprivate typealias FileNamespace = ViewController.ViewModel.Options


extension Namespace {
    struct Options {
        private(set) var shouldUseCollectionView: Bool
        private(set) var shouldEmbedController: Bool
        
        struct Printer: CustomStringConvertible {
            var description: String {
                let first = self.options.shouldUseCollectionView ? "Collection" : "Table"
                let second = self.options.shouldEmbedController ? "VC" : "View"
                return first + second
            }
            var options: Options
        }
    }
}

extension FileNamespace {
    static func `default`() -> Self { self.tableView }
    static var tableView: Self = .init(shouldUseCollectionView: false, shouldEmbedController: false)
    static var tableViewController: Self = .init(shouldUseCollectionView: false, shouldEmbedController: true)
    static var collectionView: Self = .init(shouldUseCollectionView: true, shouldEmbedController: false)
    static var collectionViewController: Self = .init(shouldUseCollectionView: true, shouldEmbedController: true)
}

extension FileNamespace: CustomStringConvertible {
    var description: String {
        Printer(options: self).description
    }
}
