//
//  LogInViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/12/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LogInViewController: UIViewController, UITextFieldDelegate {
    var userEmail = ""
    var userPassword = ""

    var dbRef: DatabaseReference!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: userEmail, password: passwordTextField.text!){ (user, error) in
            if error == nil{
            self.performSegue(withIdentifier: "logInToAddEntrySegue", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let text = textField.text
        if text == "Email" || text == "Password" {
            textField.clearsOnBeginEditing = true
            if  text == "Password" {
                textField.isSecureTextEntry = true
            }
            textField.textColor = UIColor.black
        }
        
        return true
    }
    
    

    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == self.emailTextField {
                if textField.text != nil {
                self.userEmail = textField.text!
                }
            } else {
                if textField.text != nil {
                self.userPassword = textField.text!
                }
            }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "logInToAddEntrySegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Anamnisar.jpg")!)
        dbRef = Database.database().reference()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

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
