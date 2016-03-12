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
import AudioToolbox



class GoalDetailsViewController: UIViewController {
    var goal: NSManagedObject!
    
    @IBOutlet var goalNameLabel: UILabel!
    
    @IBOutlet var statsLabel: UILabel!
    @IBOutlet var frequencyValue: UILabel!
    
    @IBOutlet var lastAchieved: UILabel!
    @IBOutlet var frequencyType: UILabel!
    
    @IBAction func secretButtonPressed(sender: AnyObject) {
        print("secret button pressed")
        if let soundURL = NSBundle.mainBundle().URLForResource("justdoit", withExtension: "caf") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            // Play
            AudioServicesPlaySystemSound(mySound);
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let goal = goal {
            goalNameLabel.text = String(goal.valueForKey("name")!)
            frequencyValue.text = String(goal.valueForKey("frequencyValue")!)
            frequencyType.text = String(goal.valueForKey("frequencyType")!) + "!"
            let bestStreak = goal.valueForKey("bestStreak")!
            statsLabel.text = "So far I have archieved this goal \(bestStreak) times"
            let lastAchievedVal = goal.valueForKey("nextDue")
            if lastAchievedVal != nil {
                lastAchieved.text = String(lastAchievedVal!)
            }
            else {
                lastAchieved.text = ""
            }
        }
    }
}
