//
//  CalendarViewController.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/23/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func meetingLocationButton(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string:"https://goo.gl/maps/6EgqpaWE2x62")!)
    }

    @IBAction func creditsButton(sender: UIButton) {
        
        let creditsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreditsViewController")
        
        //present view controller created
        self.presentViewController(creditsViewController, animated: true, completion:nil)
        
        
    }
}
