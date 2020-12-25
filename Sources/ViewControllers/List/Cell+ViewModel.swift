//
//  Cell+ViewModel.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 04.12.2020.
//

import Foundation
import Combine

extension Cell {
    class ViewModel {
        private var sizeDidChangeSubject: PassthroughSubject<Void, Never> = .init()
        func sizeDidChange() {
            self.sizeDidChangeSubject.send()
        }
    }
}

extension Cell.ViewModel {
    func configured(sizeDidChangeSubject: PassthroughSubject<Void, Never>) {
        self.sizeDidChangeSubject = sizeDidChangeSubject
    }
}

protocol CellViewModelProtocol {
    var sizeDidChangeSubject: PassthroughSubject<Void, Never> {get set}
}

extension CellViewModelProtocol {
    func sizeDidChange() {
        self.sizeDidChangeSubject.send()
    }
    mutating func configured(sizeDidChangeSubject: PassthroughSubject<Void, Never>) {
        self.sizeDidChangeSubject = sizeDidChangeSubject
    }
}
