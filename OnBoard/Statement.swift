//
//  Statement.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/15/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit

class Statement: Unit {

    var extraInfo: String?
    
    init(text: String, extraInfo: String) {
        super.init()
        self.isQuiz = false
        self.extraInfo = extraInfo
        self.text = text
        
        
    }
    
    
}
