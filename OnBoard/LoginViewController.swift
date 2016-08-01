//
//  LoginViewController.swift
//  OnBoard
//
//  Created by Allen Spicer on 6/9/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    override func viewDidLoad() {
        
        checkForUser()
        super.viewDidLoad()

        //  dismiss the keyboard on tap
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        dismissKeyboardTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    override func viewWillDisappear(animated: Bool) {
       // Data.getData()

    }
    
    
    @IBAction func LogInButton(sender: UIButton) {
        
        //uncomment to shortcut login
      // self.performSegueWithIdentifier("LogInSegueIdentifier", sender: self)
        
      checkForUser()
        logUserIn()
    }

    func checkForUser(){
        if let user = FIRAuth.auth()?.currentUser {
                print("\(user.email!) is signed in!")
            //check if system user email is same as current firebase user
            if (user.email == userEmailTextField.text){
                print(user.email)
                print(userEmailTextField.text)
                self.performSegueWithIdentifier("LogInSegueIdentifier", sender: self)
            
        }else{
            // No user is signed in.
            let alertController = UIAlertController(title: "Invalid Credentials", message: "That user does not exist or the password entered is incorrect. Would you like to create a new user?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "Create New User", style: .Default) { (action) in
                self.createUser()}
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
            }
            }
            print("No user is signed in")
}

    func createUser(){
    FIRAuth.auth()?.createUserWithEmail("\(self.userEmailTextField.text)", password: "\(self.userPasswordTextField.text)")
    { (user, error) in
        if (error != nil){
            //create alert controller requesting new email/password combo
            let alertController = UIAlertController(title: "Invalid Credentials", message: "That user or password does not qualify for an account", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: {})
            }
    }
}
    
    func logUserIn(){
                //Attempt to Sign in with input
                if let emailAddress = self.userEmailTextField.text{
            if let password = self.userPasswordTextField.text{
            FIRAuth.auth()?.signInWithEmail("\(emailAddress)", password: "\(password)"){ (user, error) in
            print(user?.email)
            print(user?.displayName)
            print(user?.uid)
            print(error)
                    }}}
            }

// Hide keyboard function
    func dismissKeyboard(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
 override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

}