//
//  SavedEntryThankYouViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/11/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SavedEntryThankYouViewController: UIViewController {

    var dbRefCurrentUser: DatabaseReference!
    
    var currentUserRef: User?

    @IBOutlet weak var gifImage: UIImageView!
    
    @IBOutlet weak var numberOfEntryLabel: UILabel!
    
    func getStreak() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRefCurrentUser = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)

        let dbStreak = self.dbRefCurrentUser.child("Streak")
        dbStreak.observeSingleEvent(of:.value, with: { (snapshot) in
            if snapshot.exists() {
                let currStreak = snapshot.value as! Int
                self.numberOfEntryLabel.text = "\(currStreak) entries"
                
            } else {
                print("snapshot doesn't exist")
            }
        })

        let gifURL : String = "https://media.giphy.com/media/11sBLVxNs7v6WA/giphy.gif"
        gifImage.loadGif(name: "thank you")
        
    
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? addDiaryEntryViewController {
            destination.currentUserRef = self.currentUserRef
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
