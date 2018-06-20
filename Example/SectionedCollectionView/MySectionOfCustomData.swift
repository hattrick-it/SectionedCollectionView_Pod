//
//  MySectionOfCustomData.swift
//  SectionedCollectionView_Example
//
//  Created by Esteban Arrua on 6/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SectionedCollectionView

open class MySectionOfCustomData: SectionOfCustomData {
    public typealias Item = MyCustomData
    public typealias Header = String
    public typealias Footer = Any
}
