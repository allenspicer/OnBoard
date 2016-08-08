//
//  Module.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/15/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit

class Module: NSObject {

    var unitsArray: Array<Unit> = [Unit]()
    var currentUnit: Int?
    var title: String?
    var time: String?
    
    
    init(dictionary:NSDictionary) {

        //populate units array
        for (statementKey, statementValue) in (dictionary.objectForKey("statements") as? NSDictionary)!{
        unitsArray.append(Statement(text: statementKey as! String, extraInfo: statementValue as! String))
            
        }
        
        for (quizKey, quizAnswers) in (dictionary.objectForKey("questions") as? NSDictionary)!{
            unitsArray.append(Quiz(question: quizKey as! String, answers: quizAnswers as! NSDictionary) )
        }
        
        //set current unit to zero until firebase overwrites
        currentUnit = 0
        
        //set module title
        title = dictionary.objectForKey("title") as? String
        
        //set module estimated time to finish
        time = dictionary.objectForKey("length") as? String
        
        
    }
    
}
