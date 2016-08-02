//
//  TrainingViewController.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/13/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//


import UIKit
import Firebase


class TrainingViewController: UITableViewController {
    
    var detailViewController: TrainingDetailViewController = TrainingDetailViewController()
    var myModule: Module?
    var moduleArray: [Module] = []
    let ref = FIRDatabase.database().reference()
    var uid = String?()
    var userDictionary: NSDictionary?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clean table view by overwriting empty footer
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //store modules from Firebase as local dictionary
    _ = ref.child("training_modules").observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
        let moduleDictionary = snapshot.value as! NSDictionary
        for (_, moduleValue) in moduleDictionary{
            self.moduleArray.append(Module(dictionary: moduleValue as! NSDictionary))
        }
        self.getCorrectUser()
        self.updateCurrentUnitForUser()
        self.removeCompletedModulesForUser()
        self.tableView.reloadData()
    }
        
}
    
    override func viewWillDisappear(animated: Bool) {
        self.ref.child("training_modules").removeAllObservers()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func getCorrectUser(){
        if let user = FIRAuth.auth()?.currentUser {
            uid = "\(user.uid)"

        
        }
    }
    
    
    func updateCurrentUnitForUser(){
        if (uid != nil){
        
        ref.child("users").child(self.uid!).observeSingleEventOfType(.Value){(snapshot: FIRDataSnapshot) in
            let userDict = snapshot.value as! NSDictionary
            self.userDictionary = userDict
            print(userDict)
            print(snapshot.value)
            }
        }
    }
    
    
// MARK: - Table View setup
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((moduleArray.count))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = moduleArray[indexPath.row].title
        cell.detailTextLabel?.text = moduleArray[indexPath.row].time
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCellWithIdentifier("Header")
    headerCell?.textLabel?.textAlignment = .Center
        headerCell?.textLabel?.text = "Training"
        headerCell?.textLabel?.textColor = UIColor(colorLiteralRed: 15/255, green: 193/255, blue: 193/255, alpha: 1)
        headerCell?.textLabel?.font = UIFont(name: "Circular-Std-Medium", size: 25)
        return headerCell
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        //store current module
        myModule = moduleArray[indexPath.row]
        
        //update to unit user is currently on for the correct module

            myModule?.currentUnit = (userDictionary?.objectForKey("current_module_unit")) as? Int
        
    //if user is currently on a statement
    if (myModule?.unitsArray[(myModule?.currentUnit)!].isQuiz == false){
            
        //use statement storyboard
        detailViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StatementDetailViewController")) as! TrainingDetailViewController

        //pass module to instantiated detail VC
        detailViewController.myModule = myModule

        //present view controller created
        self.presentViewController(detailViewController, animated: true, completion:nil)
    
        
    //if user is currently on a quiz
    }else if (myModule?.unitsArray[(myModule?.currentUnit)!].isQuiz ==  true){
            
        //use quiz storyboard
        detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("QuizDetailViewController") as! TrainingDetailViewController
        
        //pass module to instantiated detail VC
        detailViewController.myModule = myModule
        
        //present view controller created
        self.presentViewController(detailViewController, animated: true, completion:nil)

        }
        
    }
    

    
    func removeCompletedModulesForUser(){
        
        //retrieve dictionary of modules for user
        if let userModuleDictionary = userDictionary?.objectForKey("Completed") as! NSDictionary? {
            
            //extract modules that are completed
            if let completedModules = userModuleDictionary.allKeysForObject(true) as NSArray?{
                
            //remove listed from moduleArray
                let i = 0
                while i < moduleArray.count{
                    if  (completedModules.containsObject(moduleArray[i].title!) == true){
                        moduleArray.removeAtIndex(i)
                    }
                }
            }
        }
        
        //reload data
        self.tableView.reloadData()
    }
    
}
