
import Foundation
import UIKit
import CoreData



class GoalDetailsViewController: UIViewController {
    var goal: Goal!
    
    @IBOutlet var goalNameLabel: UILabel!
    
    @IBOutlet var statsLabel: UILabel!
    @IBOutlet var frequencyValue: UILabel!
    
    @IBOutlet var lastAchieved: UILabel!
    @IBOutlet var frequencyType: UILabel!
    
    @IBAction func deleteGoalButtonPressed(sender: AnyObject) {
        //        delete goal on button press
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(goal)
        do {
            try managedContext.save()
        } catch {
        }
        
        //also delete the possibly existing notification for the goal
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["name"] as! String == goal.name{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
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
