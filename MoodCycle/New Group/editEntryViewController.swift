//
//  editEntryViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/29/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class editEntryViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var entry: diaryEntry?
    
    var diaryEntryBody = ""
    var currentUserRef: User?
    var result: String = ""
    
    @IBOutlet weak var titleOfEntry: UITextField!

    @IBOutlet weak var diaryNavBar: UINavigationBar!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        diaryEntryBody = entryBody.text
        var fullEntry = [String: String]()
        fullEntry["Date"] = entry!.date
        fullEntry["Body"] = diaryEntryBody
        fullEntry["dbRef"] = entry!.dbRef
        if titleOfEntry.text != "Title of Entry" {
            fullEntry["Title"] = titleOfEntry.text
        }
        let oldRef = Database.database().reference(fromURL: (entry?.dbRef)!) 
        oldRef.child("Notes").setValue(fullEntry)
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBOutlet weak var entryBody: UITextView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Begin Typing Here" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != nil {
            diaryEntryBody = textView.text
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Title of Entry" {
            textField.text = ""
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.entryBody.delegate = self
        titleOfEntry.delegate = self
        

        diaryNavBar.topItem?.title = entry!.date
        entryBody.text = entry?.body
        titleOfEntry.text = entry?.title
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func updateTextView(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        _ = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            entryBody.contentInset = UIEdgeInsets.zero
        } else {
            entryBody.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrameScreenCoordinates.height, right: 0)
            entryBody.scrollIndicatorInsets = entryBody.contentInset
        }
        
        entryBody.scrollRangeToVisible(entryBody.selectedRange)
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
