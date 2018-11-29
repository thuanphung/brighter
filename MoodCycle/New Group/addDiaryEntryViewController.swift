//
//  DiaryEntryViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/7/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DiaryEntryViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var currentDateNode: DatabaseReference?
    var diaryEntry = ""
    var currentUserRef: User?
    var result: String = ""

    @IBOutlet weak var titleOfEntry: UITextField!
    @IBAction func backButtonPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    
    }
    @IBOutlet weak var diaryNavBar: UINavigationBar!

    @IBAction func saveButtonPressed(_ sender: Any) {
        diaryEntry = entry.text
        var fullEntry = [String: String]()
        fullEntry["Date"] = result
        fullEntry["Entry"] = diaryEntry
        if titleOfEntry.text != "Title of Entry" {
            fullEntry["Title"] = titleOfEntry.text
        }
        currentUserRef?.lastEntryRef!.child("Notes").setValue(fullEntry)
        performSegue(withIdentifier: "savedEntryToMain", sender: self)
    }
    

  
    @IBOutlet weak var entry: UITextView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Begin Typing Here" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != nil {
            diaryEntry = textView.text
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entry.delegate = self
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        result = formatter.string(from: date)
        diaryNavBar.topItem?.title = result
        titleOfEntry.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func updateTextView(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            entry.contentInset = UIEdgeInsets.zero
        } else {
            entry.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrameScreenCoordinates.height, right: 0)
            entry.scrollIndicatorInsets = entry.contentInset
        }
        
        entry.scrollRangeToVisible(entry.selectedRange)
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
