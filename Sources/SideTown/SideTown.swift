//
//  SideTown.swift
//  SideTown
//
//  Created by Samet Koyuncu on 14.11.2022.
//
#if canImport(UIKit)
import UIKit

final public class SideMenu: UIView {
    // for configurations
    // TODO: delegate may be use a protocol
    weak var delegate: UIViewController?

    // States
    private var menuState: MenuState = .closed
    private var menuPosition: MenuPosition = .right
    private var menuBackgroundColor: UIColor!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(_ menuConfig: MenuConfig) {
        // get view width and x position
        let width = menuConfig.customView.frame.width
        let x = menuConfig.position == .left ? -(width + 5) : menuConfig.vc.view.frame.width + 5
        // create frame using properties for our view
        let frame = CGRect(x: x,
                           y: 0,
                           width: menuConfig.vc.view.frame.width + 5,
                           height: menuConfig.vc.view.frame.height)
        super.init(frame: frame)
    
        let transparentView = createTransparentView(menuConfig)
        
        if menuConfig.position == .right {
            menuConfig.customView.frame.origin.x = transparentView.frame.width - 2
        }

        self.isHidden = true
        self.addSubview(menuConfig.customView)
        self.addSubview(transparentView)
        
        menuConfig.vc.view.addSubview(self)
        
        // set stored properties
        self.menuPosition = menuConfig.position
        self.menuBackgroundColor = menuConfig.backgroundColor
        self.delegate = menuConfig.vc
        
        // setup gestures
        setupDelegateGestures()
    }
}

public extension SideMenu {
    // MARK: - Open or close side menu. | You can call this methods from anywhere if you need.
    func toggleMenu() {
        switch menuState {
        case .opened:
            closeMenu()
        case .closed:
            openMenu()
        }
    }
    
    func openMenu() {
        changeNavBarStatus(to: .hide)
        updateMenuOriginX(for: .opened)
        menuState = .opened
        // bg
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) { [weak self] in
                
                self?.backgroundColor = self?.menuBackgroundColor
            }
        }
    }
    
    func closeMenu() {
        changeNavBarStatus(to: .show)
        updateMenuOriginX(for: .closed)
        menuState = .closed
        // bg
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) { [weak self] in
            self?.backgroundColor = .clear
        }
        
    }
}

private extension SideMenu {
    func createTransparentView(_ menuConfig: MenuConfig) -> UIView {
        let transparentView: UIView = .init(frame: CGRect(x: menuConfig.position == .left ? menuConfig.customView.frame.width : 0,
                                                          y: 0,
                                                          width: (menuConfig.vc.view.frame.width - menuConfig.customView.frame.width) + 10,
                                                          height: menuConfig.vc.view.frame.height))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didOutSideTapped(_:)))
        
        transparentView.addGestureRecognizer(tapGestureRecognizer)
        transparentView.backgroundColor = .clear
        
        return transparentView
    }
    // MARK: - menu animations
    func updateMenuOriginX(for status: MenuState) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            switch self.menuPosition {
            case .left:
                self.frame.origin.x = status == .opened ?  -5 : -(self.frame.width + 5)
            case .right:
                self.frame.origin.x = status == .opened ?  self.delegate!.view.frame.width - (self.frame.width - 5) : self.delegate!.view.frame.width + 5
            }
        }
        
        // for navigation controller pop event (-!- delay, important for animations)
        switch status {
        case .opened:
            self.isHidden = false
        case .closed:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.isHidden = true
            }
        }
    }

    // MARK: - Show or hide navigationBar
    func changeNavBarStatus(to status: NavBarStatus) {
        switch status {
        case .show:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) { [weak self] in
                self?.delegate?.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: 0)
                self?.backgroundColor = self?.menuBackgroundColor
            }
        case .hide:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) { [weak self] in
                self?.delegate?.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -200)
                self?.backgroundColor = .clear
            }
        }
    }
}

// MARK: - Gesture Settings
private extension SideMenu {
    // MARK: - setup gestures | open or close menu using left and right swipe
    func setupDelegateGestures() {
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        swipeGestureRecognizerLeft.direction = .left
        
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        swipeGestureRecognizerRight.direction = .right
        
        self.addGestureRecognizer(swipeGestureRecognizerLeft)
        self.addGestureRecognizer(swipeGestureRecognizerRight)
        
        // edge swipe action
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = self.menuPosition == .left ? .left : .right
        
        delegate?.view.addGestureRecognizer(edgePan)
    }
    
    // MARK: - Swipe Methods
    @objc func didOutSideTapped(_ sender: UITapGestureRecognizer) {
        if menuState == .opened {
            closeMenu()
        }
    }
    
    @objc func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        switch menuPosition {
        case .left:
            if menuState == .opened {
                closeMenu()
            }
        case .right:
            if menuState == .closed {
                openMenu()
            }
        }
    }
    
    @objc func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        switch menuPosition {
        case .left:
            if menuState == .closed {
                openMenu()
            }
        case .right:
            if menuState == .opened {
                closeMenu()
            }
        }
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            openMenu()
        }
    }
}
#endif
