//
//  Cell+ContentConfiguration.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 04.12.2020.
//

import Foundation
import UIKit

extension Cell {
    enum ContentConfiguration {}
}

extension Cell.ContentConfiguration {
    struct ContentConfiguration: UIContentConfiguration, Equatable {
        typealias Row = ViewController.ViewModel.Row
        var information: Row
        init(_ row: Row) {
            self.information = row
        }
        func makeContentView() -> UIView & UIContentView {
            ContentView(configuration: self)
        }
        
        func updated(for state: UIConfigurationState) -> ContentConfiguration { self }
    }
    
    class ContentView: UIView, UIContentView {
        struct Layout {
            let insets: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        }
        
        /// Views
        var contentView: UIView = .init()
        var topView: TextViewHolder = .init()
        
        /// Variables
        private var lastKnownSize: CGSize = .zero
        private var layout: Layout = .init()

        /// Setup
        private func setup() {
            self.setupUIElements()
            self.addLayout()
        }
        
        private func setupUIElements() {
            /// Top most ContentView should have .translatesAutoresizingMaskIntoConstraints = true
            self.translatesAutoresizingMaskIntoConstraints = true

            [self.contentView, self.topView].forEach { (value) in
                value.translatesAutoresizingMaskIntoConstraints = false
            }
            
            self.topView.textView.delegate = self
            
            /// View hierarchy
            self.contentView.addSubview(self.topView)
            self.addSubview(self.contentView)
            
            self.contentView.backgroundColor = .systemGray6
        }
        
        private func addLayout() {
            if let superview = self.contentView.superview {
                let view = self.contentView
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: self.layout.insets.left),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -self.layout.insets.right),
                    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: self.layout.insets.top),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -self.layout.insets.bottom),
                ])
            }
            
            if let superview = self.topView.superview {
                let view = self.topView
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                    view.topAnchor.constraint(equalTo: superview.topAnchor),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                ])
            }
        }

        /// ContentView
        var currentConfiguration: ContentConfiguration!
        var configuration: UIContentConfiguration {
            get { self.currentConfiguration }
            set {
                /// apply configuration
                guard let configuration = newValue as? ContentConfiguration else { return }
                self.apply(configuration: configuration)
            }
        }

        /// Initialization
        init(configuration: ContentConfiguration) {
            super.init(frame: .zero)
            self.setup()
            self.apply(configuration: configuration)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// Apply
        private func apply(configuration: ContentConfiguration) {
            guard self.currentConfiguration != configuration else { return }
            
            self.currentConfiguration = configuration
            self.invalidateIntrinsicContentSize()
            
            self.applyNewConfiguration()
        }
        
        private func applyNewConfiguration() {
            let information = self.currentConfiguration.information
            let title = information.item.title
            
            /// Since we compare our configuration by title, we could do it.
            /// But we must assure ourselves, that everything would be fine.
            if self.topView.textView.textStorage.string != title {
                self.topView.textView.textStorage.setAttributedString(.init(string: title))
            }
        }
    }
}

extension Cell.ContentConfiguration.ContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.intrinsicContentSize
        if self.lastKnownSize != size {
            self.lastKnownSize = size            
            self.currentConfiguration.information.sizeDidChange()
        }
    }
}

extension Cell.ContentConfiguration.ContentView {
    class TextViewHolder: UIView {
        private(set) var textView: UITextView = .init()
//        private var builder: TextView.UIKitTextView.Builder = .init()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// Setup
        private func setup() {
            self.textView.isScrollEnabled = false
            self.textView.backgroundColor = .clear
            self.setupUIElements()
            self.addLayout()
        }

        private func setupUIElements() {
            self.translatesAutoresizingMaskIntoConstraints = false

            [self.textView].forEach { (value) in
                value.translatesAutoresizingMaskIntoConstraints = false
            }
            
            self.addSubview(self.textView)
        }
        
        private func addLayout() {
            if let superview = self.textView.superview {
                let view = self.textView
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                    view.topAnchor.constraint(equalTo: superview.topAnchor),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                ])
            }
        }
        
        override var intrinsicContentSize: CGSize { .zero }
    }
}
