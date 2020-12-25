//
//  ViewController+ListDataSource.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 25.12.2020.
//

import Foundation
import UIKit

fileprivate typealias Namespace = ViewController

protocol ListDataSource {
    associatedtype SectionIdentifierType: Hashable
    associatedtype ItemIdentifierType: Hashable
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool, completion: (() -> Void)?)
    func snapshot() -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
}

extension UICollectionViewDiffableDataSource: ListDataSource {}
extension UITableViewDiffableDataSource: ListDataSource {}
extension Namespace {
    struct AnyListDataSource<SectionIdentifierType, ItemIdentifierType>: ListDataSource where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
        private var applyFunction: (NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, Bool, (() -> Void)?) -> ()
        private var snapshotFunction: () -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
        init<T: ListDataSource>(_ value: T) where T.SectionIdentifierType == SectionIdentifierType, T.ItemIdentifierType == ItemIdentifierType {
            self.applyFunction = value.apply
            self.snapshotFunction = value.snapshot
        }
        /// ListDataSource
        func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool, completion: (() -> Void)?) {
            self.applyFunction(snapshot, animatingDifferences, completion)
        }
        func snapshot() -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
            self.snapshotFunction()
        }
    }
}
