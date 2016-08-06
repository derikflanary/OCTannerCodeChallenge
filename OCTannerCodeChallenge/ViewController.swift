//
//  ViewController.swift
//  OCTannerCodeChallenge
//
//  Created by Derik Flanary on 2/23/16.
//  Copyright © 2016 Derik Flanary. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate{
    
    //MARK: - PROPERTIES
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countingScrollView: CountingScrollView!
    @IBOutlet weak var centerLine: CenterLine!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - VIEW SETUP
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Setup counting scrollview
        countingScrollView.setup()
        countingScrollView.delegate = self
        countingScrollView.maxCount(300)
        countingScrollView.minCount(50)
        countingScrollView.lineSpacing(20)
        
        //Set count equal to count property of scrollview
        countLabel.text = "\(countingScrollView.count)"
        
        //Adjust layout of Save Button
        saveButton.backgroundColor = UIColor(white: 0.8, alpha: 1)
        saveButton.layer.cornerRadius = saveButton.bounds.height/2
        saveButton.clipsToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Bring center line to front after scrollview adds its subviews
        self.view.bringSubviewToFront(centerLine)
    }
    
    //MARK: - BUTTON FUNCTIONS
    @IBAction func savePressed(sender: AnyObject) {

        NSUserDefaults.standardUserDefaults().setInteger(countingScrollView.count, forKey: "Weight")
    }

    //MARK: - SCROLLVIEW DELEGATE
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //Update label text with changes in scrollview
        countLabel.text = "\(countingScrollView.count)"
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        countingScrollView.centerOnX(originalX: scrollView.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate{
            
            countingScrollView.centerOnX(originalX: scrollView.contentOffset.x)
        }
    }
    
}



