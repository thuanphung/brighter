//
//  DiaryEntryViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/7/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit

class DiaryEntryViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var entry: UITextView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entry.delegate = self
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        dateLabel2.text = result
        
//        NotificationCenter.default.addObserver(self, selector: #selector(22(notifcation:)), name: Notification.Name.UIKeyBoardWillChangeFrame, object: nil)
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
