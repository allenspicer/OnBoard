//
//  ProfileViewController.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/9/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var organizationNameLabel: UILabel!
    
    let paleGreen = UIColor.init(red: 92/255, green: 214/255, blue: 214/255, alpha: 1)
    let red = UIColor.init(red: 1, green: 20/255, blue: 20/255, alpha: 1)
    let darkGray = UIColor.init(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    let vanilla = UIColor.init(red: 252/255, green: 251/255, blue: 227/255, alpha: 1)
    let userRef = FIRDatabase.database().reference().child("users")
    var userDict: NSDictionary?
    var uid = String?()
    var viewHeight = CGFloat()
    var viewWidth = CGFloat()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCorrectUser()
        formatLabelsAndViews()
        setProfileNameDateAndOrg()
        determineViewSize()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateModuleResultsInProfile()
    }
    
    @IBAction func logOutButton(sender: UIButton) {
         try! FIRAuth.auth()!.signOut()
        self.performSegueWithIdentifier("LogOutSegueIdentifier", sender: self)
    }
    
    @IBAction func resetButton(sender: UIButton) {
        resetAllModulesAndQuizAnswers()
    }

    

    func addLabelFromQuizResult(x:CGFloat, y:CGFloat, title:String, correct:Bool){
    
        var newlabel = UILabel(frame: CGRectMake(x,y, 30, 30))
        newlabel.accessibilityIdentifier = "temp"

        //set text to unit number
        newlabel.text = title
        newlabel.textColor = .whiteColor()
        newlabel.textAlignment = .Center
        newlabel.font = UIFont(name: "Circular-Std-Medium", size: 20)
        setCornerRadiusAndMaskToBounds(&newlabel)
            
        //if true set to pale green, if false set to red
        if correct == true{
            newlabel.backgroundColor = paleGreen}
        if correct == false{
            newlabel.backgroundColor = red
        }
        self.view.addSubview(newlabel)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getCorrectUser(){
        if let user = FIRAuth.auth()?.currentUser {
            uid = "\(user.uid)"
        }
    }
    
    func setCornerRadiusAndMaskToBounds<T>(inout element:T){
        if element is UILabel{
            let label = element as! UILabel
            label.layer.cornerRadius = 15
            label.clipsToBounds = true
        }
        if element is UIImageView{
            let imageView = element as! UIImageView
            imageView.layer.cornerRadius = 15
            imageView.layer.masksToBounds = true
        }
    }
    
    func formatLabelsAndViews(){
        setCornerRadiusAndMaskToBounds(&profileImageView)
    }

    func updateModuleResultsInProfile(){
            
    if (uid != nil){
        
        //take snapshot data for user
        userRef.child(self.uid!).observeSingleEventOfType(.Value){(snapshot: FIRDataSnapshot) in
            self.userDict = snapshot.value as? NSDictionary
            
            //create array of completed module names
            if let completedModules = self.userDict!.objectForKey("Completed")!.allKeys as! Array<String>?{

                for (moduleIndex, moduleTitle) in completedModules.enumerate(){
                    
                self.addTitleLabel(moduleIndex, moduleTitle: moduleTitle)

                //find complete key for module
                    if let complete = self.userDict!.objectForKey("Completed")?.objectForKey("\(moduleTitle)") as! Bool? {
               
                // if value is now true module is completed
                if complete == true{

                //count answers in module and create local variable for spacing
                if let moduleAnswersDict = self.userDict!.objectForKey("\(moduleTitle)") as! NSDictionary? {
                  let count =  moduleAnswersDict.count
                let spacing = self.viewWidth/CGFloat(count)
                    
                        //for each answer in module
                            for index in moduleAnswersDict.enumerate(){
                                
                        //define x and y placement
                            let xLocation = CGFloat(index.index)*spacing - CGFloat(index.index*30) + CGFloat(spacing*0.75)
                            let yLocation = self.viewHeight*0.4 + (CGFloat(moduleIndex)*60)
                                
                        //define unit title for label
                        let titleCharacters = String(index.element.key).characters
                        let unitTitle = String(titleCharacters.last)
                                
                                
                        //create a label and place on view
                        self.addLabelFromQuizResult(xLocation, y: yLocation, title: unitTitle, correct: index.element.value as! Bool)
                        }
                }
                }
                }

                }
            }
            
        }
    }
    }
    
    func addTitleLabel(moduleIndex: Int, moduleTitle: String){
        
        
        //create vertical location for module title
        let yTitleLocation = CGFloat(self.viewHeight*0.4 + (CGFloat(moduleIndex)*60)-20)
        
        // use module name as title and set to storyboard
        let newlabel = UILabel(frame: CGRectMake(0, yTitleLocation, self.viewWidth, 20))
        
        newlabel.accessibilityIdentifier = "temp"
        
        //set title text color to vanilla if false
        let completedModuleIdentifier = userDict!.objectForKey("Completed")!.objectForKey("\(moduleTitle)") as! Bool?
        switch completedModuleIdentifier{
        case true?:
            newlabel.textColor = self.darkGray
        case false?:
            newlabel.textColor = self.vanilla
        default: break
        }
        
        //set text to unit number
        newlabel.text = moduleTitle
        newlabel.textAlignment = .Center
        newlabel.font = UIFont(name: "Circular-Std-Medium", size: 14)
        self.view.addSubview(newlabel)
        
        
    }
    
    func setProfileNameDateAndOrg(){
        userRef.observeSingleEventOfType(.Value){(snapshot: FIRDataSnapshot) in
            if let userDictionary = snapshot.value as! NSDictionary?{
                self.userDict = userDictionary
                
                if let namePath = self.userDict?.objectForKey(self.uid!){
                    self.profileNameLabel.text = namePath.objectForKey("full_name") as? String
                }
                if let datePath = self.userDict?.objectForKey(self.uid!){
                    self.joinDateLabel.text = datePath.objectForKey("created_at") as? String
                }
                if let orgPath = self.userDict?.objectForKey(self.uid!){
                    self.organizationNameLabel.text = orgPath.objectForKey("organization") as? String
                }
                
            }}
        
    }
    
    
    func determineViewSize(){
        //determine user view size
        viewWidth = view.frame.size.width
        viewHeight = view.frame.size.height
    }
    
    func resetAllModulesAndQuizAnswers(){

        //set completed to just one module with false value
        let completedString = "Completed"
        let emptyModuleString = "Fundraising Conversations"
        userRef.child(uid!).updateChildValues([completedString:[emptyModuleString:false]])
        
        //remove all temporary elements
        for subView in view.subviews{
            if subView.accessibilityIdentifier == "temp"{
                subView.removeFromSuperview()}
            print(subView.accessibilityIdentifier)
            
        }

    }
    
    
    func determineIfAnswersAreEvenOrOdd(){
        
        
    }
    
    

    
}

