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
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 1).cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [10, 5]
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
}

