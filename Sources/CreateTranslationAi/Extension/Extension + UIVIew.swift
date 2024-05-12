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
//  func addDashedBorder() {
//      let color = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 1).cgColor
//
//    let shapeLayer:CAShapeLayer = CAShapeLayer()
//    let frameSize = self.frame.size
//    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//
//    shapeLayer.bounds = shapeRect
//    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
//    shapeLayer.fillColor = UIColor.clear.cgColor
//    shapeLayer.strokeColor = color
//    shapeLayer.lineWidth = 2
//    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
//    shapeLayer.lineDashPattern = [6,3]
//    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 25).cgPath
//
//    self.layer.addSublayer(shapeLayer)
//    }
    func addDashedBorder() {
        let color = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 1).cgColor
        
        let shapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = .round
        
        // Adjust dash size and spacing here (e.g., [10, 5] for larger dashes and spacing)
        shapeLayer.lineDashPattern = [10, 5]
        
        // Calculate a larger rectangle to ensure dashes are drawn outside the view
        let largerRect = shapeRect.insetBy(dx: -shapeLayer.lineWidth / 2, dy: -shapeLayer.lineWidth / 2)
        shapeLayer.path = UIBezierPath(roundedRect: largerRect, cornerRadius: 25).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }

}

