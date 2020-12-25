//
//  Cell.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 04.12.2020.
//

import Foundation
import UIKit

enum Cell {}

extension Cell.ContentConfiguration {
    enum Cell {
        class Table: UITableViewCell {
            override func updateConfiguration(using state: UICellConfigurationState) {
                super.updateConfiguration(using: state)
                self.setNeedsUpdateConstraints()
                self.setNeedsLayout()
            }
        }
        class Collection: UICollectionViewCell {
            override func updateConfiguration(using state: UICellConfigurationState) {
                super.updateConfiguration(using: state)
                self.setNeedsUpdateConstraints()
                self.setNeedsLayout()
            }
        }
    }
}

extension UITableViewCell {
    class func cellReuseIdentifier() -> String { NSStringFromClass(self) }
}

extension UICollectionViewCell {
    class func cellReuseIdentifier() -> String { NSStringFromClass(self) }
}
