//
//  CollectionViewCell.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/8/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation
import UIKit

open class ItemCollectionViewCell: UICollectionViewCell {
    
    open class var nibName: String {
        return "ItemCollectionViewCell"
    }
    open class var cellReuseIdentifier: String {
        return "ItemCollectionViewCell"
    }
    
    open func configure(withValue value: Any?) { }
    
}
