//
//  MyCustomData.swift
//  SectionedCollectionView_Example
//
//  Created by Esteban Arrua on 6/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SectionedCollectionView

public class MyCustomData: Selectable {
    
    public var name: String
    
    public init(name: String, selected: Bool) {
        self.name = name
        
        super.init()
        self.selected = selected
    }
    
}
