//
//  StatsViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/7/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import Charts
import FirebaseAuth
import FirebaseDatabase

class StatsViewController: UIViewController {
    
    var dbRefCurrentUser: DatabaseReference!
    
    var energyDataPoints: [Double] = []
    var moodDataPoints: [Double] = []
    var stressDataPoints: [Double] = []
    
    func grabData() {
//       creates date array for the last 7 days
        var today = Date()
        var dateArray = [String]()
        for i in 1...7{
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let date = DateFormatter()
            date.dateFormat = "MM/dd/yyyy"
            var stringDate : String = date.string(from: today)
            today = tomorrow!
            dateArray.append(stringDate)
        }
        
//      creates an array of the paths needed to access
        var dataBaseArray = [DatabaseReference]()
        for i in 0...6{
            let currentWorkingDate = dateArray[i]
            var delimiter = "/"
            var token = currentWorkingDate.components(separatedBy: delimiter)
            
            let year = token[2]
            let month = intToMonth(num: Int(token[0])!)
        dataBaseArray.append(dbRefCurrentUser.child(year).child(month).child(currentWorkingDate))
        }
//      access every path and averages data if any (if no data, leave blank)
//        for i in 0...6{
//            dataBaseArray[i].observeSingleEvent(of:.value, with: { (snapshot) in
//                if snapshot.exists() {
//                    savedEntry = snapshot.value as! []
//                    self.currentUserRef.userEntries = newStreak
//                    dbStreak.setValue(newStreak)
//
//                } else {
//                    dataPoints.append(100)
//                }
//            }
//        }
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRefCurrentUser = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
        
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
