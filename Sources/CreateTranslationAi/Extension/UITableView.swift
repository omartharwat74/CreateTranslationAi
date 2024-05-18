//
//  File.swift
//
//
//  Created by Omar Tharwat on 18/05/2024.
//

import UIKit

class TableViewContentSized: UITableView {
    
    // 2) Add a UITableView to your layout and set constraints on all sides. Set the class of it to ContentSizedTableView.
    
    // 3) You should see some errors, because Storyboard doesn't take our subclass' intrinsicContentSize into account. Fix this by opening the size inspector and overriding the intrinsicContentSize to a placeholder value. This is an override for design time. At runtime it will use the override in our ContentSizedTableView class
    
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

//MARK: - Extensions -
extension UITableView {
    
    private enum AnimationDirection {
        case up
        case down
        case left
        case right
    }
    private func reloadData(animationDirection:AnimationDirection) {
        self.reloadData()
        self.layoutIfNeeded()
        let cells = self.visibleCells
        var index = 0
        let tableHeight: CGFloat = self.bounds.size.height
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            switch animationDirection {
            case .up:
                cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
                break
            case .down:
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
                break
            case .left:
                cell.transform = CGAffineTransform(translationX: tableHeight, y: 0)
                break
            case .right:
                cell.transform = CGAffineTransform(translationX: -tableHeight, y: 0)
                break
            }
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    func animateToLeft() {
        self.reloadData(animationDirection: .left)
    }
    func animateToRight() {
        self.reloadData(animationDirection: .right)
    }
    func animateToTop() {
        self.reloadData(animationDirection:.down)
    }
    func animateToBottom() {
        self.reloadData(animationDirection: .up)
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            let sections = self.numberOfSections - 1
            let rows = self.numberOfRows(inSection: sections) - 1
            if (rows > 0){
                self.scrollToRow(at: NSIndexPath(row: rows, section: sections) as IndexPath, at: .bottom, animated: true)
            }
        }
    }
}

//MARK: - Placeholder -
enum TableViewPlaceHolder {
    case notLogin(action: [Selector]?)
    case notifications(action: [Selector]?)
    case empty
    case emptyHome(action: [Selector]?)
}
extension TableViewPlaceHolder {
    var title: String {
        switch self {
        case .notLogin:
            return "Your are not login"
        case .notifications:
            return "No Notifications Found"
        case .empty:
            return "No Data Found".localized
        case .emptyHome:
            return "No Posts Found".localized
        }
    }
    var message: String {
        switch self {
        case .notLogin:
            return "Start logging into your account with us"
        case .notifications:
            return ""
        case .empty:
            return ""
        case .emptyHome:
            return "Add Friends to see posts".localized
        }
    }
    var actionName: [String] {
        switch self {
        case .notLogin:
            return ["Login"]
        case .notifications:
            return [""]
        case .empty:
            return [""]
        case .emptyHome:
            return ["Add Friends".localized, "Register as store".localized]
        }
    }
    var imageName: String {
        switch self {
        case .notLogin:
            return "accountTotalLogo"
        case .notifications:
            return "NoNotifications"
        case .empty:
            return "emptyPlaceholder"
        case .emptyHome:
            return ""
        }
    }
    var action:  [Selector]? {
        switch self {
        case .notLogin(let action):
            return action
        case .notifications(_):
            return nil
        case .empty:
            return nil
        case .emptyHome(let actions):
            return actions
        }
    }
}

