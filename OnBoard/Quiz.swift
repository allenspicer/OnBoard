//
//  Quiz.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/15/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit

class Quiz: Unit {

    var answersArray: Array<String>?
    var correctAnswerArray: Array<Bool>?
    
    init(question: String, answers: NSDictionary) {
        super.init()
        self.isQuiz = true
        self.text = question
        self.answersArray = answers.allKeys as? Array<String>
        self.correctAnswerArray = answers.allValues as? Array<Bool>
        
    }
    
}



