//
//  UISideMenuNavigationController.swift
//
//  Created by Jon Kent on 1/14/16.
//  Copyright © 2016 Jon Kent. All rights reserved.
//

import UIKit

public protocol UISideMenuNavigationControllerDelegate: class {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool)
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool)
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool)
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool)
}

// This makes adherance to the protocol optional:
extension UIViewController {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {}
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {}
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {}
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {}
}

open class UISideMenuNavigationController: UINavigationController {
    
    fileprivate weak var temporarySideMenuDelegate: UISideMenuNavigationControllerDelegate?
    fileprivate func findDelegate(forViewController: UIViewController?) -> UISideMenuNavigationControllerDelegate? {
        if let navigationController = forViewController as? UINavigationController {
            return findDelegate(forViewController: navigationController.topViewController)
        }
        if let tabBarController = forViewController as? UITabBarController {
            return findDelegate(forViewController: tabBarController.selectedViewController)
        }
        if let splitViewController = forViewController as? UISplitViewController {
            return findDelegate(forViewController: splitViewController.viewControllers.last)
        }
        
        temporarySideMenuDelegate = forViewController as? UISideMenuNavigationControllerDelegate
        return temporarySideMenuDelegate
    }
    internal var originalMenuBackgroundColor: UIColor?
    internal var transition: SideMenuTransition {
        get {
            return sideMenuManager.transition
        }
    }
    internal var sideMenuDelegate: UISideMenuNavigationControllerDelegate? {
        get {
            guard !view.isHidden else {
                return nil
            }
            
            return temporarySideMenuDelegate ?? findDelegate(forViewController: presentingViewController)
        }
    }
    
    /// SideMenuManager instance associated with this menu. Default is `SideMenuManager.default`. This property cannot be changed after the menu has loaded.
    open weak var sideMenuManager: SideMenuManager! = SideMenuManager.default {
        didSet {
            if isViewLoaded && oldValue != nil {
                print("SideMenu Warning: a menu's sideMenuManager property cannot be changed after it has loaded.")
                sideMenuManager = oldValue
            }
        }
    }
    
    /// Width of the menu when presented on screen, showing the existing view controller in the remaining space. Default is zero. When zero, `sideMenuManager.menuWidth` is used. This property cannot be changed while the isHidden property is false.
    @IBInspectable open var menuWidth: CGFloat = 0 {
        didSet {
            if !isHidden && oldValue != menuWidth {
                menuWidth = oldValue
            }
        }
    }
    
    /// Whether the menu appears on the right or left side of the screen. Right is the default. This property cannot be changed after the menu has loaded.
    @IBInspectable open var leftSide: Bool = false {
        didSet {
            if isViewLoaded && leftSide != oldValue {
                print("SideMenu Warning: a menu's leftSide property cannot be changed after it has loaded.")
                leftSide = oldValue
            }
        }
    }
    
    /// Indicates if the menu is anywhere in the view hierarchy, even if covered by another view controller.
    open var isHidden: Bool {
        get {
            return self.presentingViewController == nil
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if leftSide {
            sideMenuManager.menuLeftNavigationController = self
        } else {
            sideMenuManager.menuRightNavigationController = self
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Dismiss keyboard to prevent weird keyboard animations from occurring during transition
        presentingViewController?.view.endEditing(true)
        
        temporarySideMenuDelegate = nil
        sideMenuDelegate?.sideMenuWillAppear(menu: self, animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // We had presented a view before, so lets dismiss ourselves as already acted upon
        if view.isHidden {
            transition.hideMenuComplete()
            dismiss(animated: false, completion: { () -> Void in
                self.view.isHidden = false
            })
            
            return
        }
        
        sideMenuDelegate?.sideMenuDidAppear(menu: self, animated: animated)
        
        if topViewController == nil {
            print("SideMenu Warning: the menu doesn't have a view controller to show! UISideMenuNavigationController needs a view controller to display just like a UINavigationController.")
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // When presenting a view controller from the menu, the menu view gets moved into another transition view above our transition container
        // which can break the visual layout we had before. So, we move the menu view back to its original transition view to preserve it.
        if !isBeingDismissed {
            guard let sideMenuManager = sideMenuManager else {
                return
            }
            
            if let mainView = transition.mainViewController?.view {
                switch sideMenuManager.menuPresentMode {
                case .viewSlideOut, .viewSlideInOut:
                    mainView.superview?.insertSubview(view, belowSubview: mainView)
                case .menuSlideIn, .menuDissolveIn:
                    if let tapView = transition.tapView {
                        mainView.superview?.insertSubview(view, aboveSubview: tapView)
                    } else {
                        mainView.superview?.insertSubview(view, aboveSubview: mainView)
                    }
                }
            }
            
            // We're presenting a view controller from the menu, so we need to hide the menu so it isn't showing when the presented view is dismissed.
            UIView.animate(withDuration: animated ? sideMenuManager.menuAnimationDismissDuration : 0,
                           delay: 0,
                           usingSpringWithDamping: sideMenuManager.menuAnimationUsingSpringWithDamping,
                           initialSpringVelocity: sideMenuManager.menuAnimationInitialSpringVelocity,
                           options: sideMenuManager.menuAnimationOptions,
                           animations: {
                            self.transition.hideMenuStart()
                            self.sideMenuDelegate?.sideMenuWillDisappear(menu: self, animated: animated)
            }) { (finished) -> Void in
                self.sideMenuDelegate?.sideMenuDidDisappear(menu: self, animated: animated)
                self.view.isHidden = true
            }
            
            return
        }
        
        sideMenuDelegate?.sideMenuWillDisappear(menu: self, animated: animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Work-around: if the menu is dismissed without animation the transition logic is never called to restore the
        // the view hierarchy leaving the screen black/empty. This is because the transition moves views within a container
        // view, but dismissing without animation removes the container view before the original hierarchy is restored.
        // This check corrects that.
        if let sideMenuDelegate = sideMenuDelegate as? UIViewController, sideMenuDelegate.view.window == nil {
            transition.hideMenuStart().hideMenuComplete()
        }
        
        sideMenuDelegate?.sideMenuDidDisappear(menu: self, animated: animated)
        
        // Clear selecton on UITableViewControllers when reappearing using custom transitions
        guard let tableViewController = topViewController as? UITableViewController,
            let tableView = tableViewController.tableView,
            let indexPaths = tableView.indexPathsForSelectedRows,
            tableViewController.clearsSelectionOnViewWillAppear else {
            return
        }
        
        for indexPath in indexPaths {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Don't bother resizing if the view isn't visible
        guard !view.isHidden else {
            return
        }
        
        NotificationCenter.default.removeObserver(self.transition, name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
        coordinator.animate(alongsideTransition: { (context) in
            self.transition.presentMenuStart()
        }) { (context) in
            NotificationCenter.default.addObserver(self.transition, selector:#selector(SideMenuTransition.handleNotification), name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
        }
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let sideMenuManager = sideMenuManager, viewControllers.count > 0 && sideMenuManager.menuPushStyle != .subMenu else {
            // NOTE: pushViewController is called by init(rootViewController: UIViewController)
            // so we must perform the normal super method in this case.
            super.pushViewController(viewController, animated: animated)
            return
        }

        let splitViewController = presentingViewController as? UISplitViewController
        let tabBarController = presentingViewController as? UITabBarController
        let potentialNavigationController = (splitViewController?.viewControllers.first ?? tabBarController?.selectedViewController) ?? presentingViewController
        guard let navigationController = potentialNavigationController as? UINavigationController else {
            print("SideMenu Warning: attempt to push a View Controller from \(String(describing: potentialNavigationController.self)) where its navigationController == nil. It must be embedded in a Navigation Controller for this to work.")
            return
        }
        
        let sideMenuDelegate = self.sideMenuDelegate
        temporarySideMenuDelegate = nil
        
        // To avoid overlapping dismiss & pop/push calls, create a transaction block where the menu
        // is dismissed after showing the appropriate screen
        CATransaction.begin()
        if sideMenuManager.menuDismissOnPush {
            CATransaction.setCompletionBlock( { () -> Void in
                sideMenuDelegate?.sideMenuDidDisappear(menu: self, animated: animated)
                if !animated {
                    self.transition.hideMenuStart().hideMenuComplete()
                }
                self.dismiss(animated: animated, completion: nil)
            })
        
            if animated {
                let areAnimationsEnabled = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(true)
                UIView.animate(withDuration: sideMenuManager.menuAnimationDismissDuration,
                               delay: 0,
                               usingSpringWithDamping: sideMenuManager.menuAnimationUsingSpringWithDamping,
                               initialSpringVelocity: sideMenuManager.menuAnimationInitialSpringVelocity,
                               options: sideMenuManager.menuAnimationOptions,
                               animations: {
                                sideMenuDelegate?.sideMenuWillDisappear(menu: self, animated: animated)
                                self.transition.hideMenuStart()
                })
                UIView.setAnimationsEnabled(areAnimationsEnabled)
            }
        }
        
        if let lastViewController = navigationController.viewControllers.last, !sideMenuManager.menuAllowPushOfSameClassTwice && type(of: lastViewController) == type(of: viewController) {
            CATransaction.commit()
            return
        }
        
        switch sideMenuManager.menuPushStyle {
        case .subMenu, .defaultBehavior: break // .subMenu handled earlier, .defaultBehavior falls through to end
        case .popWhenPossible:
            for subViewController in navigationController.viewControllers.reversed() {
                if type(of: subViewController) == type(of: viewController) {
                    navigationController.popToViewController(subViewController, animated: animated)
                    CATransaction.commit()
                    return
                }
            }
        case .preserve, .preserveAndHideBackButton:
            var viewControllers = navigationController.viewControllers
            let filtered = viewControllers.filter { preservedViewController in type(of: preservedViewController) == type(of: viewController) }
            if let preservedViewController = filtered.last {
                viewControllers = viewControllers.filter { subViewController in subViewController !== preservedViewController }
                if sideMenuManager.menuPushStyle == .preserveAndHideBackButton {
                    preservedViewController.navigationItem.hidesBackButton = true
                }
                viewControllers.append(preservedViewController)
                navigationController.setViewControllers(viewControllers, animated: animated)
                CATransaction.commit()
                return
            }
            if sideMenuManager.menuPushStyle == .preserveAndHideBackButton {
                viewController.navigationItem.hidesBackButton = true
            }
        case .replace:
            viewController.navigationItem.hidesBackButton = true
            navigationController.setViewControllers([viewController], animated: animated)
            CATransaction.commit()
            return
        }
        
        navigationController.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

}


