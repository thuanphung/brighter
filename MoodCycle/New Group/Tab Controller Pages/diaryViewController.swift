//
//  diaryViewController.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/22/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class diaryViewController: UITableViewController {
    
    var entries: [diaryEntry] = []
    

    override func viewWillAppear(_ animated: Bool) {
        entries = []
        super.viewWillAppear(true)
        let currentUserDBRef = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
        tableView.rowHeight = 100
        currentUserDBRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.exists() {
                let yearSnap = snapshot.value as! [String: AnyObject]
                for (key, value) in yearSnap {
                    if key != "Account Info" && key != "Streak" {
                        let monthSnap = value as! [String: AnyObject]
                        for (month, date) in monthSnap {
                            let dates = date as! [String: AnyObject]
                            for (date, times) in dates{
                                let timeSnaps = times as! [String: AnyObject]
                                for (time, data) in timeSnaps {
                                    let entryTime = time
                                    let data = data as! [String: AnyObject]
                                    let entry = data["Notes"] as? [String: String]
                                    if let trueEntry = entry {
                                        let newEntry = diaryEntry(title: trueEntry["Title"]!, body: trueEntry["Body"]!, date:  trueEntry["Date"]!, time: entryTime, databaseRef: trueEntry["dbRef"] ?? "peace")
                                        self.entries.append(newEntry)
                                        self.entries.sort(by: { $0.time < $1.time })
                                        self.entries.sort(by: { $0.date > $1.date })
                                        self.tableView.reloadData()
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                            } else {
                print("snapshot doesn't exist")
            }
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! diaryEntryCell
        if entries.count != 0 {
        cell.setDiaryEntryCell(entry: entries[indexPath.row])
    
            // Configure the cell...
        }
        return cell
       
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewEntrySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEntrySegue" {
            let destination = segue.destination as! viewEntryViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let selectedRow = self.entries[(indexPath?.row)!]
            destination.entryToView = selectedRow
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
