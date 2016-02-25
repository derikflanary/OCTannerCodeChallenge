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
    private(set) internal var count : Int = 0
    private var maxCount : Int = 500
    private var minCount : Int = 0
    private(set) internal var sizeConstant : CGFloat = 16
    private var firstLoad = true
    private var lineHeight : CGFloat = 25
    
    //MARK: - UI SETUP
    func setup() {
        
        self.showsHorizontalScrollIndicator = false
        
        self.decelerationRate = 0.994
        
        self.contentOffset = CGPointMake(0, contentOffset.y)
        
    }
    
    override func layoutSubviews() {
        
        if firstLoad{
            
            loadCount()
            
            self.contentSize = CGSizeMake((CGFloat(maxCount) * sizeConstant) + frame.width, frame.height) //set initial content size
            
            drawLines()
            
            firstLoad = false
        }
        
        calculateCount()
    }
    
    //MARK: - COUNT CALCULATION METHODS
    private func calculateCount() {
        
        count = Int(round(contentOffset.x/sizeConstant)) + minCount
        
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
        
        //Scroll to that weights location
        self.setContentOffset(CGPointMake(round(CGFloat(count) * sizeConstant), self.contentOffset.y), animated: true)
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
            
            x += sizeConstant
            
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
    }
    
    func sizeConstant(constant: CGFloat) {
        
        self.sizeConstant = constant
        
        setNewContentSize()
    }
    
    func lineHeight(lineHeight: CGFloat) {
        self.lineHeight = lineHeight
    }
    
    private func setNewContentSize() {
        //Adjusts Content Size when changes are made to the max count or the size constant
        self.contentSize = CGSizeMake((CGFloat(maxCount) * sizeConstant) + frame.width, frame.height)
    }
    
    //MARK: - SCROLL ADJUSTMENT
    func centerOnX(originalX originalX: CGFloat) {
        
        //See if the scrollviews x divided by the size constant is an exact location or not
        if !(originalX / sizeConstant).isInteger{
            
            let newX = round(originalX / sizeConstant)
            
            //Scroll to exact location
            setContentOffset(CGPointMake(newX * sizeConstant, contentOffset.y), animated: true)
        }
    }

    
}

