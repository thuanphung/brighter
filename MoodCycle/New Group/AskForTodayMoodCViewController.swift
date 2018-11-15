//
//  AskForTodayMood.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/7/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AskForTodayMood: MainPageViewController {
    var energyLevel = 5
    var stressLevel = 5
    var moodLevel = 5
    var dbRef: DatabaseReference!
    var current = Auth.auth().currentUser

//    @IBAction func logOutButtonPressed(_ sender: Any) {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//        
//        self.performSegue(withIdentifier: "logOutSegue", sender: self)
//    }
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBAction func SaveButton(_ sender: UIButton) {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let currentDateNode = dbRef.child("Users").child((current?.uid)!).child("\(year)").child("\(month)_" + "\(year)").child("\(month)_" + "\(day)_" + "\(year)")
        

        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to save today's entry?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction) in
            
            let todayLevels = ["energy": self.energyLevel, "stress": self.stressLevel,"mood": self.moodLevel]
    
            currentDateNode.child("levels").setValue(todayLevels)
            
                self.performSegue(withIdentifier: "toThankYouSegue", sender: self)
        
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func EnergyLevelSlider(_ sender: UISlider) {
        energyLevel = Int(sender.value)
    }
    @IBAction func StressLevelSlider(_ sender: UISlider) {
        stressLevel = Int(sender.value)
    }
    
    @IBAction func MoodLevelSlider(_ sender: UISlider) {
        moodLevel = Int(sender.value)
    }
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
        dbRef = Database.database().reference()
        
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
