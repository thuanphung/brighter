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

class AskForTodayMood: UIViewController, UITextViewDelegate {
    var energyLevel = 5
    var stressLevel = 5
    var moodLevel = 5
    var dbRefCurrentUser: DatabaseReference!
    var currentDateNode: DatabaseReference?
    var currentUserRef = User()


    @IBOutlet weak var energySlider: UISlider!
    
    @IBOutlet weak var addEntryNavbAR: UINavigationBar!
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "logOutFromMainSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
    
    @IBAction func SaveButton(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to save today's entry?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction) in
            
            let todayLevels = ["energy": self.energyLevel, "stress": self.stressLevel,"mood": self.moodLevel]
            var newStreak = 0
            let dbStreak = self.dbRefCurrentUser.child("Streak")
            dbStreak.observeSingleEvent(of:.value, with: { (snapshot) in
                if snapshot.exists() {
                    newStreak = snapshot.value as! Int + 1
                    self.currentUserRef.userEntries = newStreak
                    dbStreak.setValue(newStreak)
                    
                } else {
                    print("snapshot doesn't exist")
                }
            })
            
            self.currentDateNode!.child("Levels").setValue(todayLevels)
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SavedEntryThankYouViewController {
            destination.currentUserRef = self.currentUserRef
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let date = Date()
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        
        let dates = DateFormatter()
        dates.dateFormat = "MM-dd-yyyy"
        let stringDate : String = dates.string(from: date)
        
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        dbRefCurrentUser = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
        currentDateNode = dbRefCurrentUser.child("\(year)").child(intToMonth(num: month)).child(stringDate).child(timeFormatter.string(from: date))
        currentUserRef.lastEntryRef = currentDateNode
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        addEntryNavbAR.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Medium", size: 21)!]
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        

        addEntryNavbAR.topItem?.title = result
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "addEntryToLogInSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    func intToMonth(num: Int) -> String {
        if num == 1{
            return "January"
        } else if num == 2 {
            return "Febuary"
        } else if num == 3 {
            return "March"
        } else if num == 4 {
            return "April"
        } else if num == 5 {
            return "May"
        } else if num == 6 {
            return "June"
        } else if num == 7 {
            return "July"
        } else if num == 8 {
            return "August"
        } else if num == 9 {
            return "September"
        } else if num == 10 {
            return "October"
        } else if num == 11 {
            return "November"
        } else {
            return "December"
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
