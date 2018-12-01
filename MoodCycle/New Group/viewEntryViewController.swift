//
//  viewEntryViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/26/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import  FirebaseDatabase

class viewEntryViewController: UIViewController {

    var entryToView: diaryEntry?

    @IBOutlet weak var titleOfEntryTextField: UITextField!
    
    @IBOutlet weak var bodyOfEntryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEntryNavBar.topItem?.title = entryToView?.date
        let oldRef = Database.database().reference(fromURL: (entryToView?.dbRef)!)
        oldRef.child("Notes").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                let entryVals = snapshot.value as! [String: String]
                self.titleOfEntryTextField.text = entryVals["Title"]
                self.bodyOfEntryTextView.text = entryVals["Body"]
                self.titleOfEntryTextField.isUserInteractionEnabled = false
                self.bodyOfEntryTextView.isUserInteractionEnabled = false
            }
        })
        
        
//        titleOfEntryTextField.text = entryToView!.title
//        bodyOfEntryTextView.text = entryToView!.body
//        titleOfEntryTextField.isUserInteractionEnabled = false
//        bodyOfEntryTextView.isUserInteractionEnabled = false
//
        

        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var viewEntryNavBar: UINavigationBar!
    
    @IBAction func editButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "editEntrySegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEntrySegue" {
            let destination = segue.destination as! editEntryViewController
            destination.entry = entryToView
        }
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
