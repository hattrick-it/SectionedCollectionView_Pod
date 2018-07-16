//
//  SectionedCollectionView.swift
//  SectionedCollectionView
//
//  Created by Esteban Arrua on 6/11/18.
//  Copyright © 2018 Hattrick. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol SectionedCollectionViewDelegate {
    @objc optional func selectedItems(selected: [Selectable])
    @objc optional func limitReached()
}

public struct SectionedCollectionViewSettings {
    
    public struct ViewCells {
        public var itemCollectionViewCellNibName: String = ItemCollectionViewCell.nibName
        public var itemCollectionViewCellReuseIdentifier: String = ItemCollectionViewCell.cellReuseIdentifier
        public var headerViewCellNibName: String = ItemCollectionViewCell.nibName
        public var headerViewCellReuseIdentifier: String = ItemCollectionViewCell.cellReuseIdentifier
        public var footerViewCellNibName: String = ItemCollectionViewCell.nibName
        public var footerViewCellReuseIdentifier: String = ItemCollectionViewCell.cellReuseIdentifier
    }
    
    public struct Style {
        public var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 2, left: 12, bottom: 10, right: 12)
        public var backgroundColor: UIColor = UIColor(red: 239/255, green: 241/255, blue: 247/255, alpha: 1)
        public var scrollEnabled: Bool = true
    }
    
    public struct Data {
        public var selectedLimit: Int?
    }
    
    public struct HeaderStyle {
        public var headerReferenceHeight: CGFloat = 40
    }
    
    public struct FooterStyle {
        public var footerReferenceHeight: CGFloat = 2
    }
    
    public struct ItemsSetup {
        public var itemsForRows: Int = 3
        public var heightRatio: CGFloat = 0.9
        public var minimumLineSpacing: CGFloat = 8
        public var minimumInteritemSpacing: CGFloat = 8
    }
    
    public var viewCells = ViewCells()
    public var style = Style()
    public var data = Data()
    public var headerStyle = HeaderStyle()
    public var footerStyle = FooterStyle()
    public var itemsSetup = ItemsSetup()
    
}

public class SectionedCollectionView: UIView {
 
    public var settings = SectionedCollectionViewSettings()
    
    var collectionView: UICollectionView!
    var heightConstraint: NSLayoutConstraint?
    public var delegate: SectionedCollectionViewDelegate?
    
    // MARK: - DataSource
    fileprivate var sections: [SectionOfCustomData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
       
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
        self.setupView()
        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize") {
            if(!settings.style.scrollEnabled) {
                guard let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                    return
                }
                heightConstraint?.constant = collectionViewFlowLayout.collectionViewContentSize.height
                superview?.layoutIfNeeded()
            }
        }
    }
    
    public func setupView() {
        backgroundColor = settings.style.backgroundColor
        self.createHeightConstraint()
        self.setupCollectionViewLayout()
        self.registerHeaderCell()
        self.registerFooterCell()
        self.registerCollectionViewCell()
    }
    
    public func setDataSource(sections: [SectionOfCustomData]) {
        self.sections = sections
        self.collectionView.reloadData()
    }
    
    public func selectItem(_ indexPath: IndexPath) {
        self.didSelectItems([indexPath])
    }
    
    public func selectItems(_ indexPaths: [IndexPath]) {
        self.didSelectItems(indexPaths)
    }
    
    public func deselectItem(_ indexPath: IndexPath) {
        self.didDeselectItems([indexPath])
    }
    
    public func deselectItems(_ indexPaths: [IndexPath]) {
        self.didDeselectItems(indexPaths)
    }
    
    public func deselectAllItems() {
        let items = self.sections.map({ section -> [Selectable] in
            return section.selectedItems()
        }).flatMap({ $0 })
        
        for item in items {
            item.selected = false
        }
        
        self.delegate?.selectedItems?(selected: [])
        collectionView.reloadData()
    }
    
    fileprivate func setupCollectionView(){
        self.addCollectionView()
        self.setupDataSource()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func addCollectionView() {
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: self.collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: self.collectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: self.collectionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: self.collectionView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
        
        self.addConstraints(constraints)
    }
    
    fileprivate func createHeightConstraint() {
        if(!settings.style.scrollEnabled) {
            heightConstraint = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 10)
            self.addConstraint(heightConstraint!)
        }
    }
    
    fileprivate func setupCollectionViewLayout() {
        let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Setup Header & Footer Size
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: settings.headerStyle.headerReferenceHeight)
        collectionViewFlowLayout.footerReferenceSize = CGSize(width: collectionView.frame.width, height: settings.footerStyle.footerReferenceHeight)
        
        // Setup Cell Size
        let width = (collectionView.frame.width - (settings.style.sectionInset.left + settings.style.sectionInset.right + (CGFloat(settings.itemsSetup.itemsForRows - 1) * settings.itemsSetup.minimumInteritemSpacing))) / CGFloat(settings.itemsSetup.itemsForRows)
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: width * settings.itemsSetup.heightRatio)
        
        // Setup Minimun Spaces
        collectionViewFlowLayout.minimumLineSpacing = settings.itemsSetup.minimumLineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = settings.itemsSetup.minimumInteritemSpacing
        
        // Setup Edges
        collectionViewFlowLayout.sectionInset = settings.style.sectionInset
        collectionView.isScrollEnabled = settings.style.scrollEnabled
    }
    
    fileprivate func registerHeaderCell() {
        let nib = self.getNib(forClassName: self.settings.viewCells.headerViewCellNibName)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.settings.viewCells.headerViewCellReuseIdentifier)
    }
    
    fileprivate func registerFooterCell() {
        let nib = self.getNib(forClassName: self.settings.viewCells.footerViewCellNibName)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.settings.viewCells.footerViewCellReuseIdentifier)
    }
    
    fileprivate func registerCollectionViewCell() {
        let nib = getNib(forClassName: self.settings.viewCells.itemCollectionViewCellNibName)
        collectionView.register(nib, forCellWithReuseIdentifier: self.settings.viewCells.itemCollectionViewCellReuseIdentifier)
    }
    
    fileprivate func getNib(forClassName className: String) -> UINib {
        var bundle = Bundle.main
        if bundle.path(forResource: className, ofType: "nib") == nil {
            bundle = Bundle(for: self.classForCoder)
        }
        return UINib(nibName: className, bundle: bundle)
    }
    
    fileprivate func setupDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func didSelectItems(_ indexPaths: [IndexPath]) {
        var selectedItemsCount = self.sections.compactMap({ sections -> [Selectable] in
            return sections.selectedItems()
        }).flatMap({ $0 }).count
        
        let items = indexPaths.map { sections[$0.section].items[$0.row] }
        let itemsToSelect = items.filter { !$0.selected }.count
        
        selectedItemsCount += itemsToSelect
        
        if (self.settings.data.selectedLimit == nil || selectedItemsCount <= self.settings.data.selectedLimit!) {
            for index in indexPaths {
                self.sections[index.section].items[index.row].selected = true
            }
            
            self.delegate?.selectedItems?(selected: self.sections.map({ section -> [Selectable] in
                return section.selectedItems()
            }).flatMap({ $0 }))
            
            collectionView.reloadItems(at: indexPaths)
        } else {
            self.delegate?.limitReached?()
        }
    }
    
    fileprivate func didDeselectItems(_ indexPaths: [IndexPath]) {
        let items = indexPaths.map { sections[$0.section].items[$0.row] }
        for item in items {
            item.selected = false
        }
        
        self.delegate?.selectedItems?(selected: self.sections.map({ section -> [Selectable] in
            return section.selectedItems()
        }).flatMap({ $0 }))
        
        collectionView.reloadItems(at: indexPaths)
    }
    
}

extension SectionedCollectionView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(sections[indexPath.section].items[indexPath.row].selected) {
            self.didDeselectItems([indexPath])
        } else {
            self.didSelectItems([indexPath])
        }
    }

}

extension SectionedCollectionView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.settings.viewCells.itemCollectionViewCellReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        cell.configure(withValue: self.sections[indexPath.section].items[indexPath.row])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.settings.viewCells.headerViewCellReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
            header.configure(withValue: self.sections[indexPath.section].header)
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.settings.viewCells.footerViewCellReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
            footer.configure(withValue: self.sections[indexPath.section].footer)
            return footer
        }
    }

}
