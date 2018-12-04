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
    var showingEnergy = false
    var showingStress = false
    var showingMood = false
    
    let fullChartData = LineChartData()
    var dbRefCurrentUser: DatabaseReference!
    var lastSevenDaysArray: [String] = []
    var lastThirtyDaysArray: [String] = []
    
    var energyLineDataSet: LineChartDataSet?
    var stressLineDataSet: LineChartDataSet?
    var moodLineDataSet: LineChartDataSet?
    
    
    var energyDataPoints: [String: Double] = [:]
    var moodDataPoints: [String: Double] = [:]
    var stressDataPoints: [String: Double] = [:]
    var energyLineChartEntry = [ChartDataEntry]()
    var moodLineChartEntry = [ChartDataEntry]()
    var stressLineChartEntry = [ChartDataEntry]()
    
    @IBOutlet weak var weeklyLineChart: LineChartView!
    

    
    @IBAction func changeDisplay(_ sender: UISwitch) {
        if sender.tag == 1 {
            if sender.isOn {
                fullChartData.addDataSet(energyLineDataSet)
            } else {
                fullChartData.removeDataSet(energyLineDataSet)
            }
        } else if sender.tag == 2 {
            if sender.isOn {
                fullChartData.addDataSet(stressLineDataSet)
            } else {
                fullChartData.removeDataSet(stressLineDataSet)
            }
        } else {
            if sender.isOn {
                fullChartData.addDataSet(moodLineDataSet)
            } else {
                fullChartData.removeDataSet(moodLineDataSet)
            }
        }
        
        weeklyLineChart.notifyDataSetChanged()
    }
    
    
  
    
    @IBAction func thirtyDayGraphWanted(_ sender: Any) {


        grabMonthlyData(completionHandler: {
            () in
            self.setChartEntry(emptyChartEntry: &self.energyLineChartEntry, dateArray: self.lastThirtyDaysArray, valueArray: self.energyDataPoints)
            self.setChartEntry(emptyChartEntry: &self.stressLineChartEntry, dateArray: self.lastThirtyDaysArray, valueArray: self.stressDataPoints)
            self.setChartEntry(emptyChartEntry: &self.moodLineChartEntry, dateArray: self.lastThirtyDaysArray, valueArray: self.moodDataPoints)
            
      
            self.stressLineDataSet  = LineChartDataSet(values: self.stressLineChartEntry, label: "Stress")
            self.stressLineDataSet!.colors = [UIColor(red:1.00, green:0.82, blue:0.75, alpha:1.0)]
            self.stressLineDataSet!.drawValuesEnabled = false
            self.stressLineDataSet!.lineWidth = 5
            
            
            self.energyLineDataSet = LineChartDataSet(values: self.energyLineChartEntry, label: "Energy")
            self.energyLineDataSet!.colors = [UIColor(red:0.68, green:0.87, blue:0.81, alpha:1.0)]
            self.energyLineDataSet!.drawValuesEnabled = false
            self.energyLineDataSet!.lineWidth = 5
            
            
            self.moodLineDataSet = LineChartDataSet(values: self.moodLineChartEntry, label: "Mood")
            self.moodLineDataSet!.colors = [UIColor(red:0.75, green:0.69, blue:0.84, alpha:1.0)]
            self.moodLineDataSet!.drawValuesEnabled = false
            self.moodLineDataSet!.lineWidth = 5
            
            
            self.stressLineDataSet!.circleColors = [UIColor(red:1.00, green:0.82, blue:0.75, alpha:1.0)]
            self.energyLineDataSet!.circleColors = [UIColor(red:0.68, green:0.87, blue:0.81, alpha:1.0)]
            self.moodLineDataSet!.circleColors = [UIColor(red:0.75, green:0.69, blue:0.84, alpha:1.0)]

            self.fullChartData.addDataSet(self.energyLineDataSet)
            self.showingEnergy = true
            
            self.weeklyLineChart.data = self.fullChartData
            
            
        })

    }

    
    
    func sevenDayGraphWanted () {
        grabWeeklyData(completionHandler: {
            () in
            self.setChartEntry(emptyChartEntry: &self.energyLineChartEntry, dateArray: self.lastSevenDaysArray, valueArray: self.energyDataPoints)
            self.setChartEntry(emptyChartEntry: &self.stressLineChartEntry, dateArray: self.lastSevenDaysArray, valueArray: self.stressDataPoints)
            self.setChartEntry(emptyChartEntry: &self.moodLineChartEntry, dateArray: self.lastSevenDaysArray, valueArray: self.moodDataPoints)
            
            
            
            let stressLine  = LineChartDataSet(values: self.stressLineChartEntry, label: "Stress")
            stressLine.colors = [UIColor(red:1.00, green:0.82, blue:0.75, alpha:1.0)]
            stressLine.drawValuesEnabled = false
            stressLine.lineWidth = 5
            let energyLine  = LineChartDataSet(values: self.energyLineChartEntry, label: "Energy")
            energyLine.colors = [UIColor(red:0.68, green:0.87, blue:0.81, alpha:1.0)]
            energyLine.drawValuesEnabled = false
            energyLine.lineWidth = 5
            let moodLine  = LineChartDataSet(values: self.moodLineChartEntry, label: "Mood")
            moodLine.colors = [UIColor(red:0.75, green:0.69, blue:0.84, alpha:1.0)]
            moodLine.drawValuesEnabled = false
            moodLine.lineWidth = 5
            
            
            stressLine.circleColors = [UIColor(red:1.00, green:0.82, blue:0.75, alpha:1.0)]
            energyLine.circleColors = [UIColor(red:0.68, green:0.87, blue:0.81, alpha:1.0)]
            moodLine.circleColors = [UIColor(red:0.75, green:0.69, blue:0.84, alpha:1.0)]
            
            self.energyLineDataSet = energyLine
            self.stressLineDataSet = stressLine
            self.moodLineDataSet = moodLine
            
            self.fullChartData.addDataSet(self.energyLineDataSet)
            self.showingEnergy = true
            self.weeklyLineChart.data = self.fullChartData

        })
        weeklyLineChart.leftAxis.setLabelCount(11, force: true)

    }
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "statsViewToLogInSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
   
    
    func grabWeeklyData(completionHandler: @escaping () -> Void ) {
//       creates date array for the last 7 days
        var today = Date()
        for _ in 1...8{
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let date = DateFormatter()
            date.dateFormat = "MM-dd-yyyy"
            let stringDate : String = date.string(from: today)
            today = tomorrow!
            lastSevenDaysArray.insert(stringDate, at: 0)
        }
        
//      creates an array of the paths needed to access
        var dataBaseArray = [DatabaseReference]()
        for i in 0...7{
            let currentWorkingDate = lastSevenDaysArray[i]
            let delimiter = "-"
            var token = currentWorkingDate.components(separatedBy: delimiter)
            
            let year = token[2]
            let month = intToMonth(num: Int(token[0])!)
            dataBaseArray.append(dbRefCurrentUser.child(year).child(month).child(currentWorkingDate))
        }
//      access every path and averages data if any (if no data, leave blank)
        for i in 0...7{
            dataBaseArray[i].observeSingleEvent(of:.value, with: { (snapshot) in
                if snapshot.exists() {
                    var mood: Double = 0
                    var stress: Double = 0
                    var energy: Double = 0
                    
                    let savedEntries = snapshot.value as! [String: AnyObject]
                    for (_, usefulData) in savedEntries {
                        let dataPoints = usefulData["Levels"] as! [String: Int]
                        mood = mood + Double(dataPoints["mood"]!)
                        stress = stress + Double(dataPoints["stress"]!)
                        energy = energy + Double(dataPoints["energy"]!)
                    }
                    
                    mood = mood / Double(savedEntries.count)
                    stress = stress / Double(savedEntries.count)
                    energy = energy / Double(savedEntries.count)
                    self.moodDataPoints[self.lastSevenDaysArray[i]] = mood
                    self.energyDataPoints[self.lastSevenDaysArray[i]] = energy
                    self.stressDataPoints[self.lastSevenDaysArray[i]] = stress
                    
                } else {
                    self.moodDataPoints[self.lastSevenDaysArray[i]] = 100
                    self.energyDataPoints[self.lastSevenDaysArray[i]] = 100
                    self.stressDataPoints[self.lastSevenDaysArray[i]] = 100
                    
                }
                
                if (self.stressDataPoints.count == 8) {
                    completionHandler()
                    self.weeklyLineChart.notifyDataSetChanged()
                }
            })

        }
        weeklyLineChart.xAxis.axisMaximum = 9
        
    }
    
    func grabMonthlyData(completionHandler: @escaping () -> Void ) {
        //       creates date array for the last 30 days
        var today = Date()
        for _ in 1...30{
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let date = DateFormatter()
            date.dateFormat = "MM-dd-yyyy"
            let stringDate : String = date.string(from: today)
            today = tomorrow!
            lastThirtyDaysArray.insert(stringDate, at: 0)
        }
        
        //      creates an array of the paths needed to access
        var dataBaseArray = [DatabaseReference]()
        for i in 0...29{
            let currentWorkingDate = lastThirtyDaysArray[i]
            let delimiter = "-"
            var token = currentWorkingDate.components(separatedBy: delimiter)
            
            let year = token[2]
            let month = intToMonth(num: Int(token[0])!)
            dataBaseArray.append(dbRefCurrentUser.child(year).child(month).child(currentWorkingDate))
            //            dataBaseArray.insert(dbRefCurrentUser.child(year).child(month).child(currentWorkingDate), at: 0)
        }
        //      access every path and averages data if any (if no data, leave blank)
        for i in 0...29{
            dataBaseArray[i].observeSingleEvent(of:.value, with: { (snapshot) in
                if snapshot.exists() {
                    var mood: Double = 0
                    var stress: Double = 0
                    var energy: Double = 0
                    
                    let savedEntries = snapshot.value as! [String: AnyObject]
                    for (_, usefulData) in savedEntries {
                        let dataPoints = usefulData["Levels"] as! [String: Int]
                        mood = mood + Double(dataPoints["mood"]!)
                        stress = stress + Double(dataPoints["stress"]!)
                        energy = energy + Double(dataPoints["energy"]!)
                    }
                    
                    mood = mood / Double(savedEntries.count)
                    stress = stress / Double(savedEntries.count)
                    energy = energy / Double(savedEntries.count)
                    self.moodDataPoints[self.lastThirtyDaysArray[i]] = mood
                    self.energyDataPoints[self.lastThirtyDaysArray[i]] = energy
                    self.stressDataPoints[self.lastThirtyDaysArray[i]] = stress
                    
                } else {
                    self.moodDataPoints[self.lastThirtyDaysArray[i]] = 100
                    self.energyDataPoints[self.lastThirtyDaysArray[i]] = 100
                    self.stressDataPoints[self.lastThirtyDaysArray[i]] = 100
                    
                }
                
                if (self.stressDataPoints.count > 29) {
                    completionHandler()
                }
            })
            
        }
        weeklyLineChart.xAxis.axisMaximum = 31

    }
    
    func setChartEntry(emptyChartEntry: inout [ChartDataEntry], dateArray: [String], valueArray: [String: Double]) {
        for i in 0..<dateArray.count {
            let values = valueArray[dateArray[i]]
            if values != Double(100) {
                let value = ChartDataEntry(x: Double(i + 1), y: values!)
                emptyChartEntry.append(value)
            }
            
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRefCurrentUser = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
        sevenDayGraphWanted()
        weeklyLineChart.leftAxis.axisMaximum = 11
        weeklyLineChart.leftAxis.axisMinimum = 0
        weeklyLineChart.leftAxis.drawTopYLabelEntryEnabled = false
        weeklyLineChart.leftAxis.drawBottomYLabelEntryEnabled = false
        weeklyLineChart.xAxis.axisMinimum = 0
        weeklyLineChart.xAxis.drawGridLinesEnabled = false
        
        weeklyLineChart.legend.enabled = false
        
        weeklyLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        weeklyLineChart.rightAxis.drawGridLinesEnabled = false
        weeklyLineChart.rightAxis.drawLabelsEnabled = false
        
        weeklyLineChart.xAxis.axisLineWidth = CGFloat(4)
        weeklyLineChart.leftAxis.axisLineWidth = CGFloat(4)
        
        weeklyLineChart.drawGridBackgroundEnabled = false
        weeklyLineChart.doubleTapToZoomEnabled = false
        
        let longDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let shortDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var offSet = 0
        
        var formattedShortDays = [""]
        
        let today = Date().dayOfWeek()
        offSet = (longDays.firstIndex(of: today!))!
        
        for i in 0...7 {
            formattedShortDays.append(shortDays[(i + offSet) % 7])
        }
        
        
        
        
        weeklyLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: formattedShortDays)
        weeklyLineChart.xAxis.granularity = 1
        weeklyLineChart.xAxis.setLabelCount(10, force: true)

        
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



@objc(LineChartFormatter)
public class LineChartFormatter: NSObject, IAxisValueFormatter{

        
        var labels: [String] = []
        let longDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let shortDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var offSet = 0

        
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[(Int(value) + offSet) % shortDays.count ]
        }
        
        init(labels: [String]) {
            super.init()
            let today = Date().dayOfWeek()
            setDays(today: today!)
            
            self.labels = labels
        }
        
        func setDays(today: String) {
            offSet = (longDays.firstIndex(of: today))!
            
        }
    
    

}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
