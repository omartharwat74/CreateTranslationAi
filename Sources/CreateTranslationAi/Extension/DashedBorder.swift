//
//  File.swift
//
//
//  Created by Omar Tharwat on 14/05/2024.
//

import UIKit

class RectangularDashedView: UIView {
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = 0.5
        dashBorder.strokeColor = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 1).cgColor
        dashBorder.lineDashPattern = [10, 5]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
        
        //            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
