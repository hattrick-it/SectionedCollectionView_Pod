//
//  SectionOfCustomData.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/11/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation

open class Selectable: NSObject {
    public var selected: Bool = false
}

open class SectionOfCustomData {
    public typealias Item = Selectable
    public typealias Header = Any
    public typealias Footer = Any
    
    var items: [Item]
    var header: Header?
    var footer: Footer?
    
    public init(header: Header? = nil, items: [Item], footer: Footer? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}

extension SectionOfCustomData {
    public func selectedItems() -> [Item] {
        return self.items.filter{ $0.selected }
    }
}
