//
//  InfiniteScrollView.swift
//  OCTannerCodeChallenge
//
//  Created by Derik Flanary on 2/24/16.
//  Copyright © 2016 Derik Flanary. All rights reserved.
//

import Foundation
import UIKit

class CountingScrollView: UIScrollView{
    
    private enum LineType{
        case Tall
        case Short
    }
    
    //MARK: - PROPERTIES
    private(set) internal var count = 0
    private var maxCount : Int = 500
    private var minCount : Int = 0
    private var lineSpacing : CGFloat = 16
    private var firstLoad = true
    private var lineHeight : CGFloat = 25
    private var lines = [CAShapeLayer]()
    
    //MARK: - UI SETUP
    func setup() {
        
        self.showsHorizontalScrollIndicator = false
        
        self.decelerationRate = 0.994
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if firstLoad{
            
            setNewContentSize()
            
            drawLines()
            
            firstLoad = false
            
        }
        
        calculateCount()
    }
    
    //MARK: - COUNT CALCULATION METHODS
    private func calculateCount() {
        
        count = Int(round(contentOffset.x / lineSpacing)) + minCount
        
        //Keep count from going negative when bouncing
        if count < minCount{
            
            count = minCount
            
        //Keep count from going above max when bouncing
        }else if count > maxCount{
            
            count = maxCount
        }
    }
    
    private func loadCount() {
        
        //Load weight from defaults
        count = NSUserDefaults.standardUserDefaults().integerForKey("Weight")
        
        //Scroll to that weight's location
        self.setContentOffset(CGPointMake(round(CGFloat(count * Int(lineSpacing))), self.contentOffset.y), animated: true)
    }
    
    //MARK: - DRAW LINES
    private func drawLines() {
        
        //x coordinate for the first line
        var x = self.bounds.width/2
        
        //height each line will be
        var height: CGFloat
        
        //Lets it know if it should be making a Tall line first
        var lineType = LineType.Tall
        
        //Add lines for the ruler until you reach the end of the content size's width
        repeat{
            
            switch lineType{
                
            case .Tall:
                
                height = lineHeight * 2
                lineType = .Short
                
            case .Short:
                height = lineHeight
                lineType = .Tall
            }
            
            //Create Path for Ruler line
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x:CGFloat(x), y:bounds.height - 50 - height))
            path.addLineToPoint(CGPoint(x:CGFloat(x), y:bounds.height - 50))
            
            //Draw Path as a Layer
            let line = CAShapeLayer()
            line.path = path.CGPath
            line.lineWidth = 1.0
            line.strokeColor = UIColor.lightGrayColor().CGColor
            self.layer.addSublayer(line)
            
            lines.append(line)
            
            x += lineSpacing
            
        }while x <= contentSize.width - self.bounds.width/2
    }
    
    //MARK: - PRIVATE PROPERTY SETTING
    func maxCount(maxCount: Int) {
        
        self.maxCount = maxCount
        
        setNewContentSize()
    }
    
    func minCount(minCount: Int) {
        
        self.minCount = minCount
        
        self.count = minCount
        
        setNewContentSize()
    }
    
    func lineSpacing(constant: CGFloat) {
        
        self.lineSpacing = constant
        
        setNewContentSize()
    }
    
    func lineHeight(var lineHeight: CGFloat) {
        
        if lineHeight > bounds.height{
            
            lineHeight = bounds.height
        }
        
        self.lineHeight = lineHeight
        
        resetScrollView()
    }
    
    private func setNewContentSize() {
        //Adjusts Content Size when changes are made to the max count or the size constant
        self.contentSize = CGSizeMake((CGFloat(maxCount) * lineSpacing) + frame.width, frame.height)
    }
    
    //MARK: - RESETTING SCROLL VIEW ASPECTS
    func resetScrollView() {
        
        for line in lines{
            line.removeFromSuperlayer()
        }
        
        lines.removeAll()
        
        setNewContentSize()
        
        drawLines()
        
    }
    
    //MARK: - SCROLL ADJUSTMENT
    func centerOnX(originalX originalX: CGFloat) {
        
        //See if the scrollviews x divided by the size constant is an exact location or not
        if !(originalX / lineSpacing).isInteger{
            
            let newX = round(originalX / lineSpacing)
            
            //Scroll to exact location
            setContentOffset(CGPointMake(newX * lineSpacing, contentOffset.y), animated: true)
            
            calculateCount()
        }
    }

    
}

