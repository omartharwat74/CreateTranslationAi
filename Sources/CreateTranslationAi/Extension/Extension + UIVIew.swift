//
//  Extension + UIVIew.swift
//  SolvingMathematicalEquations
//
//  Created by Omar Tharwat on 28/04/2024.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            parentResponder = responder.next
        }
        return nil
    }
}

public func SCImage(named name: String) -> UIImage? {
    UIImage(named: name, in: Bundle.module, compatibleWith: nil)
}

extension UIView {
    
     func addDashedBorder() {
         let borderLayer = CAShapeLayer()
        let viewRect = CGRect(x: 0, y: 0, width: 1000, height: frame.size.height)

        borderLayer.bounds = viewRect
        borderLayer.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 1).cgColor
        borderLayer.lineWidth = 0.5
        borderLayer.lineJoin = .round

        borderLayer.lineDashPattern = [10, 5]
        borderLayer.path = UIBezierPath(roundedRect: viewRect, cornerRadius: 25).cgPath

        layer.addSublayer(borderLayer)
    }
}

