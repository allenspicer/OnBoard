//
//  TabBarController.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/9/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove shadow from tab bar
        UITabBar.appearance().shadowImage = UIImage()
        //remove dividing line from tab bar
        UITabBar.appearance().backgroundImage = UIImage()
        //set color of selected titles
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(red: 92/255, green: 214/255, blue: 214/255, alpha: 1)], forState: .Selected)
        //set color of tab titles
       // UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(red: 255/255, green: 20/255, blue: 20/255, alpha: 1)], forState: .Normal)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
