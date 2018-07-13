//
//  CustomItemCollectionViewCell.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/14/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation
import UIKit
import SectionedCollectionView

class CustomItemCollectionViewCell: ItemCollectionViewCell {
    
    override class var nibName: String {
        return "CustomItemCollectionViewCell"
    }
    override class var cellReuseIdentifier: String {
        return "CustomItemCollectionViewCell"
    }

    private let selectedBackgroundColor: UIColor = UIColor(red: 3/255, green: 155/255, blue: 229/255, alpha: 1)
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupStyle()
    }

    override func configure(withValue value: Any?) {
        guard let data = value as? MyCustomData else { return }
        nameLabel.text = data.name
        nameLabel.textColor = data.selected ? .white : .black
        backgroundColor = data.selected ? selectedBackgroundColor : .white
    }

    private func setupStyle() {
        nameLabel.font = UIFont.systemFont(ofSize: 20.0)
        layer.cornerRadius = 20
    }
    
}
