//
//  SectionOfCustomData.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/11/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation

public struct SectionOfCustomData {
    
    public init(header: String, items: [Item]){
        self.header = header
        self.items = items
    }
    
    public var header: String
    public var items: [Item]
}

extension SectionOfCustomData {
    public typealias Item = CustomData
    
    public func selectedItems() -> SectionOfCustomData {
        return SectionOfCustomData(header: self.header, items: self.items.filter({ item -> Bool in
            item.selected
        }))
    }
}
