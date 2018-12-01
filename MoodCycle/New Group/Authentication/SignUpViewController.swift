//
//  SignUpViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/12/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var dbRef: DatabaseReference!

    var userEmail = ""
    var userFirstName = ""
    var userLastName = ""
    var userPassword = ""
    var userVerifiedPassWord = ""

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        guard let email = emailTextField.text else { return }
        
        if email == "" || password == "" || firstName == "" || lastName == "" || confirmPassword == "" {
            let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
                if error == nil {
                    Auth.auth().currentUser?.createProfileChangeRequest().displayName = self.userEmail
                    Auth.auth().currentUser?.createProfileChangeRequest().commitChanges {
                        error in
                        if error == nil {
                            print("user successfully created")
                        }
                    }
                    self.dbRef.child("Users").child((Auth.auth().currentUser?.uid)!).child("Account Info").setValue(["Name": self.userFirstName + self.userLastName, "Email": self.userEmail, "Password": self.userPassword])
                    self.dbRef.child("Users").child((Auth.auth().currentUser?.uid)!).child("Streak").setValue(0)
                    let alert = UIAlertController(title: "Account Successfully Created", message: "Thank you for signing up!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {
                        (action: UIAlertAction) in
                        self.performSegue(withIdentifier: "registerToAddEntrySegue", sender: self)
                        
                        }))
                    self.present(alert, animated: true)
                } else if password != confirmPassword {
                    let alertController = UIAlertController(title: "Verification Error.", message: "The two passwords do not match.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.confirmPasswordTextField.textColor = UIColor.red
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print(error.debugDescription + "there was a problem")
                    return
                }
                
            }
   


        
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let text = textField.text
        if text == "First Name" || text == "Last Name" || text == "Email" || text == "Password" || text == "Confirm Password" {
            textField.clearsOnBeginEditing = true
            if  text == "Password" || text == "Confirm Password" {
                textField.isSecureTextEntry = true
            }
            textField.textColor = UIColor.black
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText  {
            if textField == self.firstNameTextField {
                    userFirstName = textField.text!
            
            } else if textField == self.lastNameTextField {
                    userLastName = textField.text!

            } else if textField == self.emailTextField {
                    userEmail = textField.text!
                
            } else if textField == self.passwordTextField {
                    userPassword = textField.text!
            
            } else {
                    userVerifiedPassWord = textField.text!
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
