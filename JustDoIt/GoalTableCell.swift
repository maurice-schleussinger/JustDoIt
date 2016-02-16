//
//  GoalTableCell.swift
//  JustDoIt
//
//  Created by Some one on 27/01/16.
//  Copyright © 2016 Some one. All rights reserved.
//

import Foundation
import UIKit
import ABSteppedProgressBar

class GoalTableCell: UITableViewCell {
    
    @IBOutlet var goalNameLabel: UILabel!
    
    @IBOutlet var progressCounter: ABSteppedProgressBar!
    @IBOutlet var streakCountLabel: UILabel!
    @IBOutlet var streakProgressView: UIProgressView!
    
}
