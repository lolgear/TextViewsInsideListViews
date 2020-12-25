//
//  ViewController+ViewModel.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 03.12.2020.
//

import Foundation
import Combine

fileprivate typealias Namespace = ViewController
fileprivate typealias FileNamespace = ViewController.ViewModel

extension Namespace {
    class ViewModel {
        var title: String { self.options.description }
        private(set) var options: Options = .default()
        private(set) var model: Model.ItemList {
            didSet {
                self.syncModel()
            }
        }
        private(set) var sections: [Section] = [.default]
        private(set) var rows: [Row] = []
        private func syncModel() {
            self.rows = self.model.list.compactMap(Row.init)
            self.rows.forEach { (value) in
                var value = value
                value.configured(sizeDidChangeSubject: self.sizeDidChangeSubject)
            }
        }
        init() {
            self.model = .shared
            self.sizeDidChangePublisher = self.sizeDidChangeSubject.eraseToAnyPublisher()
            self.syncModel()
        }
        private var sizeDidChangeSubject: PassthroughSubject<Void, Never> = .init()
        private(set) var sizeDidChangePublisher: AnyPublisher<Void, Never>
    }
}

extension FileNamespace {
    func configured(_ options: Options) -> Self {
        self.options = options
        return self
    }
}

extension FileNamespace {
    enum Section: Hashable {
        case first
        static var `default`: Self = .first
    }
    class Row: Hashable {
        static func == (lhs: Row, rhs: Row) -> Bool {
            lhs.item == rhs.item
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.item)
        }
        
        private(set) var item: Model.Item
//        private(set) var viewModel: Cell.ViewModel?
        var sizeDidChangeSubject: PassthroughSubject<Void, Never> = .init()
        init(_ item: Model.Item) {
            self.item = item
        }
    }
}

extension FileNamespace.Row: CellViewModelProtocol {}
