//
//  CustomData.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/8/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation

public struct CustomData{
    
    public var name: String
    public var selected: Bool
    
    public init(name: String, selected: Bool) {
        self.name = name
        self.selected = selected
    }
    
}
