//
//  HeaderViewCell.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/8/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation
import UIKit
import SectionedCollectionView

class HeaderViewCell: ItemCollectionViewCell {
    
    override class var nibName: String {
        return "HeaderViewCell"
    }
    override class var cellReuseIdentifier: String {
        return "HeaderViewCell"
    }
    
    private let textColor: UIColor = UIColor(red: 151/255, green: 164/255, blue: 180/255, alpha: 1)
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStyle()
    }
    
    override func configure(withValue value: Any?) {
        guard let header = value as? String else { return }
        nameLabel.text = header
    }
    
    private func setupStyle() {
        nameLabel.textColor = textColor
    }
    
}
