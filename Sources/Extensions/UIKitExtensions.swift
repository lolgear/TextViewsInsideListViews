//
//  UIKitExtensions.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 25.12.2020.
//

import Foundation
import UIKit

extension UIView {
    private static func view(_ view: UIView?, embedIn other: UIView?) {
        guard let view = view, let other = other else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.leadingAnchor.constraint(equalTo: other.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: other.trailingAnchor),
            view.topAnchor.constraint(equalTo: other.topAnchor),
            view.bottomAnchor.constraint(equalTo: other.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    func embedInParent() {
        Self.view(self, embedIn: self.superview)
    }
}
