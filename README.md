# SideTown

SideTown is the simplest way to create a side menu for iOS devices.

<img src='https://i.hizliresim.com/c8ygctl.gif' alt='side town' width='50'/>
<img src='https://i.hizliresim.com/byljwxf.gif' alt='side town' width='50'/>

## Table of Contents
1. [Installation](https://github.com/sametkoyuncu/SideTown/edit/main/README.md#installation)
2. [Usage](https://github.com/sametkoyuncu/SideTown/edit/main/README.md#usage)
3. [Configuration](https://github.com/sametkoyuncu/SideTown/edit/main/README.md#configuration)

## Installation
`File` > `Add Packages..` > paste to search area this `https://github.com/sametkoyuncu/SideTown.git` > click `Add Package` button

## Usage
- Create a new UIViewController class named BaseViewController
```swift
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}  
```

- Create menu design like you want
```swift
let menuView = UIView(frame: CGRect(x: 0,
                                    y: 0,
                                    width: 280,
                                    height: UIScreen.main.bounds.height))
menuView.backgroundColor = .red
```

- Implement SideTown to BaseViewController
```swift
import UIKit
import SideTown

class BaseViewController: UIViewController {
    private var sideMenu: SideMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // custom menu view inside side menu
        let menuView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 280,
                                              height: UIScreen.main.bounds.height))
        menuView.backgroundColor = .red
                        
        // side menu
        let config: MenuConfig = .init(vc: self, customView: menuView)
        sideMenu = SideMenu(config)
    }
    
    func openMenu() {
        sideMenu.openMenu()
    }
    
    func closeMenu() {
        sideMenu.closeMenu()
    }
    
    func toggleMenu() {
        sideMenu.toggleMenu()
    }
 }
```

- Create another ViewController subclass of BaseViewController. And add a new button for open menu.
```swift
import UIKit
class ViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        super.openMenu()
    }
}
```
- Run project
- For more information check out sample project 👉

## Configuration

| Property        | Type             | Description                                                         | isRequired |
|-----------------|------------------|---------------------------------------------------------------------|------------|
| vc              | UIViewController | It's necessary for swipe gesture and navigation bar actions.        | ✅          |
| customView      | UIView           | Your design, showing inside the side menu.                          | ✅          |
| position        | MenuPosition     | Side menu position. `.left` or `.right`. The default value is `.left`. | ❌          |
| backgroundColor | UIColor          | Side menu background color. Default value is `.clear`.                 | ❌          |
