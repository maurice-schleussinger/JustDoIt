//
//  GoalDetailsViewController.swift
//  JustDoIt
//
//  Created by Some one on 04/01/16.
//  Copyright © 2016 Some one. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class GoalDetailsViewController: UIViewController {
    var goal: NSManagedObject!
    
    @IBOutlet var goalNameLabel: UILabel!
    
    @IBOutlet var statsLabel: UILabel!
    @IBOutlet var frequencyValue: UILabel!
    
    @IBOutlet var lastAchieved: UILabel!
    @IBOutlet var frequencyType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let goal = goal {
            goalNameLabel.text = String(goal.valueForKey("name")!)
            frequencyValue.text = String(goal.valueForKey("frequencyValue")!)
            frequencyType.text = String(goal.valueForKey("frequencyType")!) + "!"
            let bestStreak = goal.valueForKey("bestStreak")!
            statsLabel.text = "So far I have archieved this goal \(bestStreak) times"
            lastAchieved.text = String(goal.valueForKey("lastAchieved")!)
        }
    }
    
}
