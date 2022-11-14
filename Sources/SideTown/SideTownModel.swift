//
//  SideTownModel.swift
//  SideTown
//
//  Created by Samet Koyuncu on 14.11.2022.
//
import UIKit

public enum MenuState {
    case opened
    case closed
}

public enum MenuPosition {
    case left
    case right
}

public enum NavBarStatus {
    case show
    case hide
}

public struct MenuConfig {
    var vc: UIViewController
    var customView: UIView
    var position: MenuPosition
    var backgroundColor: UIColor
    
    public init(vc: UIViewController, customView: UIView, position: MenuPosition = .left, backgroundColor: UIColor = .darkGray.withAlphaComponent(0.7)) {
        self.vc = vc
        self.customView = customView
        self.position = position
        self.backgroundColor = backgroundColor
    }
}
