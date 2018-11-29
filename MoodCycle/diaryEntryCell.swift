//
//  diaryEntry.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/22/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import UIKit

class diaryEntry: UITableViewCell {

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

}
