//
//  diaryEntry.swift
//  MoodCycle
//
//  Created by Thuan Phung on 11/23/18.
//  Copyright © 2018 Thuan Phung. All rights reserved.
//

import Foundation
import UIKit

class diaryEntry {
    var title: String
    var body: String
    var date: String
    var time: String
    var dbRef: String
    
    init(title: String, body: String, date: String, time: String, databaseRef: String) {
        self.title = title
        self.body = body
        self.date = date
        self.time = time
        self.dbRef = databaseRef
    }
}
