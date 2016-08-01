//
//  TrainingDetailViewController.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/16/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TrainingDetailViewController: UIViewController {
    

    @IBOutlet weak var titleStatementLabel: UILabel!
    @IBOutlet weak var textStatementLabel: UILabel!
    
    @IBOutlet weak var titleQuizLabel: UILabel!
    @IBOutlet weak var textQuizLabel: UILabel!
    @IBOutlet weak var answerOneQuizLabel: UILabel!
    @IBOutlet weak var answerTwoQuizLabel: UILabel!
    @IBOutlet weak var answerThreeQuizLabel: UILabel!
    @IBOutlet weak var answerOneQuizButton: UIButton!
    @IBOutlet weak var answerTwoQuizButton: UIButton!
    @IBOutlet weak var answerThreeQuizButton: UIButton!


    var myModule: Module?
    var answerSelected = Int()
    var statement: Statement?
    let brown = UIColor(red: 1, green: 207/255, blue: 110/255, alpha: 1)
    let orange = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    var uid = String?()
    let userRef = FIRDatabase.database().reference().child("users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCorrectUser()
        
        let moduleIndex = myModule?.currentUnit ?? 0
        
        //populate Quiz view
        if(myModule?.unitsArray[moduleIndex].isQuiz == true){
            
        titleQuizLabel?.text = myModule?.title
            
        let quiz = myModule?.unitsArray[(myModule?.currentUnit)!] as! Quiz
        textQuizLabel?.text = quiz.text
        answerOneQuizLabel?.text = quiz.answersArray![0]
        answerTwoQuizLabel?.text = quiz.answersArray![1]
        answerThreeQuizLabel?.text = quiz.answersArray![2]
        }
        
        //populate Statement view
        if(myModule?.unitsArray[moduleIndex].isQuiz == false){

        titleStatementLabel?.text = myModule?.title
        
        let mainStatement = myModule?.unitsArray[(myModule?.currentUnit)!] as! Statement
        textStatementLabel?.text = mainStatement.text
        statement = mainStatement
        }

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCorrectUser(){
        if let user = FIRAuth.auth()?.currentUser {
            uid = "\(user.uid)"
        }
    }
    
    
    
    //create view of statement or quiz
    func buildUnit(){
        
        
    //if next unit exists
    if ((myModule?.unitsArray.count)! > (myModule?.currentUnit)!+1){
        
        //increment unit index
        (myModule!.currentUnit)! = 1 + (myModule?.currentUnit)!
        
        //update current unit in Firebase
        self.userRef.child(uid!).child("current_module_unit").setValue((myModule?.currentUnit)! as Int)
        
        //generate new view controller for quiz with quiz storyboard
        if(myModule?.unitsArray[(myModule?.currentUnit)!].isQuiz == true){
        
        //use quiz storyboard
        let detailViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("QuizDetailViewController")) as! TrainingDetailViewController
            detailViewController.myModule = myModule
            detailViewController.myModule?.currentUnit = (myModule?.currentUnit)!
            
        //present view controller created
        self.presentViewController(detailViewController, animated: true, completion:nil)

                }
        
        // if next module is a statement
        if(myModule!.unitsArray[(myModule?.currentUnit)!].isQuiz == false){
    
            //generate new view controller for statement with statement storyboard
        let detailViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StatementDetailViewController")) as! TrainingDetailViewController
            
        detailViewController.myModule = myModule
        detailViewController.myModule?.currentUnit = (myModule?.currentUnit)!
            
        //present view controller created
        self.presentViewController(detailViewController, animated: true, completion:nil)
        }
    }else{
        
    //module is complete
        
    //in firebase, add or update object/value pair with module title and set to true
        if let completedRef = userRef.child(self.uid!).child("Completed") as FIRDatabaseReference?
        {
            if let mod:String = "\((myModule?.title)!)"{
            completedRef.updateChildValues([mod : true])
            }
        }
        
    //in firebase, change current module unit to 0
        if let completedRef = userRef.child(self.uid!) as FIRDatabaseReference?
        {
            if let currentModUnit:String = "current_module_unit"{
                completedRef.updateChildValues([currentModUnit : 0])
            }
        }
        
        
    //present congratulations view
    self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CompleteViewController"), animated: true, completion:nil)
    }
    }
    

    @IBAction func continueStatementButton(sender: UIButton) {
        buildUnit()
    }
    
    
    @IBAction func continueQuizButton(sender: UIButton) {
       
        //only move forward if answer has been selected
        if (answerSelected == 1 || answerSelected == 2 || answerSelected == 3){
        checkForCorrectAnswer()
        buildUnit()
            
        //reset answer selected
        answerSelected = 0
        }else{

            // no selection made, request answer from user with alert
            let alertController = UIAlertController(title: "Please Answer First", message: "As soon as an answer is selected you can move forward", preferredStyle: .Alert)
            let OkayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
            }
            alertController.addAction(OkayAction)
            self.presentViewController(alertController, animated: true) {}
        }
    }
    
    func checkForCorrectAnswer(){
        let quiz = myModule?.unitsArray[(myModule?.currentUnit)!] as! Quiz
        if let title = myModule?.title{
            if let unit:String = "Unit \((myModule?.currentUnit)!)"{
        if (quiz.correctAnswerArray![answerSelected-1] == true){
            //answer is correct, update firebase
            userRef.child(uid!).child(title).updateChildValues([unit:true])
            
        }
        else if (quiz.correctAnswerArray![answerSelected-1] == false){
            //answer is incorrect, update firebase
            userRef.child(uid!).child(title).updateChildValues([unit:false])
                }
            
            }
        }
    }


    @IBAction func answerOneQuizButton(sender: UIButton) {
        answerSelected = 1
        setColorsForSelection(sender, brownButton: answerTwoQuizButton, brownButtonTwo: answerThreeQuizButton)
    }

    
    @IBAction func answerTwoQuizButton(sender: UIButton) {
        answerSelected = 2
        setColorsForSelection(sender, brownButton: answerOneQuizButton, brownButtonTwo: answerThreeQuizButton)
    }
    
    @IBAction func answerThreeQuizButton(sender: UIButton) {
        answerSelected = 3
        setColorsForSelection(sender, brownButton: answerOneQuizButton, brownButtonTwo: answerTwoQuizButton)
    }

    func setColorsForSelection(orangeButton:UIButton, brownButton:UIButton, brownButtonTwo:UIButton){
        orangeButton.backgroundColor = orange
        brownButton.backgroundColor = brown
        brownButtonTwo.backgroundColor = brown
        
    }
    
    

    @IBAction func extraInforButton(sender: UIButton) {

        let extra = UIAlertController(title: "Tip", message: "\(statement!.extraInfo!)", preferredStyle: .ActionSheet)
        let OkayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
        }
        extra.addAction(OkayAction)
        presentViewController(extra, animated: true, completion: nil)
        
        
    }

}
