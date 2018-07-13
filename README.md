# SectionedCollectionView

[![Version](https://img.shields.io/cocoapods/v/SectionedCollectionView.svg?style=flat)](https://cocoapods.org/pods/SectionedCollectionView)
[![License](https://img.shields.io/cocoapods/l/SectionedCollectionView.svg?style=flat)](https://cocoapods.org/pods/SectionedCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/SectionedCollectionView.svg?style=flat)](https://cocoapods.org/pods/SectionedCollectionView)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0.x-orange.svg)

## Usage

This library helps you implement a sectioned collection view with multiple items selection, and get the selected items with a delegate. 

The library consists of a `UIView` that contains a `UICollectionView`. 

Include this `UIView` where you want use it, and configure the following items. 

### Custom Data

You must create a class that inherits from the  `SectionOfCustomData` class.

```swift

import Foundation
import SectionedCollectionView

open class MySectionOfCustomData: SectionOfCustomData {
    public typealias Item = MyCustomData
    public typealias Header = String
    public typealias Footer = Any
}

```
Also you must create a class that inherits from the `Selectable` class. 

```swift

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

```
You can implement your own class for the Header and the Footer. If you do so, you must change the `typealias Header` and `typealias Footer` in your `SectionOfCustomData`.

### Custom Views

The `SectionedCollectionView` needs three `ViewCells`, one for the items, one for the header and another one for the footer. All of this `ViewsCells` must inherit from `ItemCollectionViewCell`, and implement the `configure` method. 

```swift

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

    @IBOutlet weak var nameLabel: UILabel!

    override func configure(withValue value: Any?) {
        guard let data = value as? MyCustomData else { return } 
        nameLabel.text = data.name
        nameLabel.textColor = data.selected ? .white : .black
    }
}
```
You don't need to implement all the `ViewCell` items, for instance, if your `SectionCollectionData` doesn't need a footer, you don't need to implement a `ViewCell` for the footer. 
In the next section there is an explanation on how to associate the custom `ViewCells` with the `SectionCollectionView`. 

### Settings

There are several settings to change. 

#### ViewCells

You can change the `nibName` and the `cellReuseIdentifier`

```swift

sectionedCollectionView.settings.viewCells.itemCollectionViewCellNibName = CustomItemCollectionViewCell.nibName
sectionedCollectionView.settings.viewCells.itemCollectionViewCellReuseIdentifier = CustomItemCollectionViewCell.cellReuseIdentifier
sectionedCollectionView.settings.viewCells.headerViewCellNibName = HeaderViewCell.nibName
sectionedCollectionView.settings.viewCells.headerViewCellReuseIdentifier = HeaderViewCell.cellReuseIdentifier
sectionedCollectionView.settings.viewCells.footerViewCellNibName = FooterViewCell.nibName
sectionedCollectionView.settings.viewCells.footerViewCellReuseIdentifier = FooterViewCell.cellReuseIdentifier

```

#### Style

You can change the style of the `UICollectionView`. 

```swift

sectionedCollectionView.settings.style.sectionInset = UIEdgeInsets(top: 2, left: 12, bottom: 10, right: 12)
sectionedCollectionView.settings.style.backgroundColor = .white

```

#### Data

You can choose a limit of selected items. 

```swift

sectionedCollectionView.settings.data.selectedLimit = 5

```

#### Header and Footer Style

You can setup the following values for the header and footer style. 

```swift

sectionedCollectionView.settings.headerStyle.headerReferenceHeight = 40
sectionedCollectionView.settings.footerStyle.footerReferenceHeight = 2

```

If you don't want a footer view, set the value `settings.footerStyle.footerReferenceHeight` to 0. 

#### Item Setup

You have some settings to setup about the ItemCellView

```swift

sectionedCollectionView.settings.itemsSetup.itemsForRows = 3
sectionedCollectionView.settings.heightRatio = 0.9
sectionedCollectionView.settings.minimumLineSpacing = 8
sectionedCollectionView.settings.minimumInteritemSpacing = 8

```

##### After configuring all the settings it necessary to call the function `sectionedCollectionView.setupView()` 

### Data Source 

```swift

let sections = [
    MySectionOfCustomData(header: "Management", items: [MyCustomData(name: "FOH management", selected: false), MyCustomData(name: "Bar management", selected: false), MyCustomData(name: "Kitchen management", selected: false), MyCustomData(name: "Baking management", selected: false) ]),
    MySectionOfCustomData(header: "Front of house", items: [MyCustomData(name: "Bartending", selected: false), MyCustomData(name: "Barista", selected: false), MyCustomData(name: "Serving", selected: false), MyCustomData(name: "Host/Hostess", selected: false), MyCustomData(name: "Sommelier", selected: false), MyCustomData(name: "Cashier", selected: false), MyCustomData(name: "Bar backing", selected: false), MyCustomData(name: "Bussing", selected: false), MyCustomData(name: "Bouncer or security", selected: false), MyCustomData(name: "Coat check", selected: false), MyCustomData(name: "Expo / Food runner", selected: false), MyCustomData(name: "Garde manger / salad", selected: false)]),
    MySectionOfCustomData(header: "Back of house", items: [MyCustomData(name: "Prepping", selected: false), MyCustomData(name: "Hot line cook", selected: false), MyCustomData(name: "Pastry", selected: false), MyCustomData(name: "Baking", selected: false), MyCustomData(name: "Sushi", selected: false), MyCustomData(name: "Dishwashing", selected: false)])
]

sectionedCollectionView.setDataSource(sections: sections)

```

### Delegate 

To get the selected items you must implement the `SectionedCollectionViewDelegate`. 

```swift

extension SectionedCollectionViewController: SectionedCollectionViewDelegate {

    func selectedItems(selected: [Selectable]) {
        //TODO: Implement that you want with the selected items.  
    }

    func limitReached() {
        //TODO: Implement that you want when the limit is reached. 
    }
        
}

```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

`SectionedCollectionView` is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SectionedCollectionView'
```

## Author

estebanarrua, esteban.arrua@hattrick-it.com

## License

`SectionedCollectionView` is available under the MIT license. See the LICENSE file for more info.
