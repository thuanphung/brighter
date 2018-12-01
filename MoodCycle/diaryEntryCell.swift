//
//  diaryEntryCell.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/22/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit

class diaryEntryCell: UITableViewCell {
    var myEntry: diaryEntry?

    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setDiaryEntryCell(entry: diaryEntry) {
        myEntry = entry
        entryTitle.text = entry.title
//        let start = entry.time.index(entry.time.startIndex, offsetBy: 5)
//        let end = entry.time.index(entry.time.endIndex, offsetBy: 0)
//        let range = start..<end
        dateLabel.text = entry.date + " - " + entry.time
    }

}
