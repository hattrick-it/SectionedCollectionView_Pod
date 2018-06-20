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

    private let gradientStartColor = UIColor(red: 46/255, green: 132/255, blue: 250/255, alpha: 1)
    private let gradientEndColor = UIColor(red: 83/255, green: 99/255, blue: 236/255, alpha: 1)
    private var gradientBackgroundLayer: CAGradientLayer?

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupStyle()
    }

    override func configure(withValue value: Any?) {
        guard let data = value as? MyCustomData else { return }
        nameLabel.text = data.name
        nameLabel.textColor = data.selected ? .white : .black
        activeGradientBackground(selected: data.selected)
    }

    private func setupStyle() {
        backgroundColor = .white
        layer.cornerRadius = 20
        setupGradientBackground()
    }

    private func setupGradientBackground() {
        gradientBackgroundLayer = CAGradientLayer()
        gradientBackgroundLayer?.frame = self.bounds
        gradientBackgroundLayer?.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradientBackgroundLayer?.locations = [0, 1]
        gradientBackgroundLayer?.startPoint = CGPoint(x: 0, y: 0)
        gradientBackgroundLayer?.endPoint = CGPoint(x: 1, y: 1)
        layer.masksToBounds = true
    }

    private func activeGradientBackground(selected: Bool) {
        gradientBackgroundLayer?.frame = self.bounds
        gradientBackgroundLayer?.removeFromSuperlayer()
        if(selected){
            layer.insertSublayer(gradientBackgroundLayer!, at: 0)
        }
    }
    
}
