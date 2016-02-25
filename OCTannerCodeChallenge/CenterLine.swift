//
//  CenterLine.swift
//  OCTannerCodeChallenge
//
//  Created by Derik Flanary on 2/24/16.
//  Copyright © 2016 Derik Flanary. All rights reserved.
//

import Foundation
import UIKit

class CenterLine: UIView {
    
    override func layoutSubviews() {
        
        drawCenterLine()
    }
    
    private func drawCenterLine() {
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x:bounds.width/2 + 0.5, y:bounds.height - 40))
        path.addLineToPoint(CGPoint(x:bounds.width/2 + 0.5, y:bounds.height - 130))
        
        //Draw Path as a Layer
        let line = CAShapeLayer()
        line.path = path.CGPath
        line.lineWidth = 3.0
        line.strokeColor = UIColor(red: 0.16, green: 0.60, blue: 0.98, alpha: 1).CGColor
        self.layer.addSublayer(line)
    }

}