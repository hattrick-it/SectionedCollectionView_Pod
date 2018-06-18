//
//  SectionedCollectionViewController.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/7/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation
import UIKit
import SectionedCollectionView

class SectionedCollectionViewController: UIViewController {
    
    @IBOutlet weak var sectionedCollectionView: SectionedCollectionView!
    
    // MARK: - Lifecycle methods
    
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionedCollectionView.settings.viewCells.itemCollectionViewCellNibName = CustomItemCollectionViewCell.nibName
        sectionedCollectionView.settings.viewCells.itemCollectionViewCellReuseIdentifier = CustomItemCollectionViewCell.cellReuseIdentifier
        sectionedCollectionView.settings.viewCells.headerViewCellNibName = HeaderViewCell.nibName
        sectionedCollectionView.settings.viewCells.headerViewCellReuseIdentifier = HeaderViewCell.cellReuseIdentifier
        sectionedCollectionView.settings.viewCells.footerViewCellNibName = FooterViewCell.nibName
        sectionedCollectionView.settings.viewCells.footerViewCellReuseIdentifier = FooterViewCell.cellReuseIdentifier
        sectionedCollectionView.settings.data.selectedLimit = 5
        sectionedCollectionView.setupView()
        
        let sections = [
            SectionOfCustomData(header: "Management", items: [CustomData(name: "FOH management", selected: false), CustomData(name: "Bar management", selected: false), CustomData(name: "Kitchen management", selected: false), CustomData(name: "Baking management", selected: false) ]),
            SectionOfCustomData(header: "Front of house", items: [CustomData(name: "Bartending", selected: false), CustomData(name: "Barista", selected: false), CustomData(name: "Serving", selected: false), CustomData(name: "Host/Hostess", selected: false), CustomData(name: "Sommelier", selected: false), CustomData(name: "Cashier", selected: false), CustomData(name: "Bar backing", selected: false), CustomData(name: "Bussing", selected: false), CustomData(name: "Bouncer or security", selected: false), CustomData(name: "Coat check", selected: false), CustomData(name: "Expo / Food runner", selected: false), CustomData(name: "Garde manger / salad", selected: false)]),
            SectionOfCustomData(header: "Back of house", items: [CustomData(name: "Prepping", selected: false), CustomData(name: "Hot line cook", selected: false), CustomData(name: "Pastry", selected: false), CustomData(name: "Baking", selected: false), CustomData(name: "Sushi", selected: false), CustomData(name: "Dishwashing", selected: false)])
        ]
        
        sectionedCollectionView.setDataSource(sections: sections)
        sectionedCollectionView.delegate = self
        
    }
    
}

extension SectionedCollectionViewController: SectionedCollectionViewDelegate {
    
    func selectedItems(selected: [CustomData]) {
        print(selected)
    }
    
    func limitReached() {
        print("Limit Reached")
    }
    
}
