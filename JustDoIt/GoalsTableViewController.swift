

import Foundation
import UIKit
import CoreData


class GoalsTableViewController : UITableViewController {
    
    let reuseIdentifier = "GoalTableCell"
    var goals = [Goal]()
    
    @IBAction func deleteButtonPressed(segue:UIStoryboardSegue){
        //        unwind segue for GoalDetailsViewController
    }
    
    func recheckAchievementStatus(){
        var achievedAchievements = NSUserDefaults.standardUserDefaults().arrayForKey("achievedAchievements") as! [String]
        for category in ["None", "Home", "Health", "Privat", "Social"]{
            //          check if the n'th achievement for the category has been achieved, if not check if it is achieved now
            if !achievedAchievements.contains("\(category)1") {
                let counter = NSUserDefaults.standardUserDefaults().integerForKey("counter\(category)")
                if counter >= 10{
                    achievedAchievements.append("\(category)1")
                }
            }
            
            //            check if the n'th achievement for the category has been achieved, if not check if it is achieved now
            if !achievedAchievements.contains("\(category)2") {
                let counter = NSUserDefaults.standardUserDefaults().integerForKey("counter\(category)")
                if counter >= 50{
                    achievedAchievements.append("\(category)2")
                }
            }
            //            check if the n'th achievement for the category has been achieved, if not check if it is achieved now
            if !achievedAchievements.contains("\(category)3") {
                let counter = NSUserDefaults.standardUserDefaults().integerForKey("counter\(category)")
                if counter >= 100{
                    achievedAchievements.append("\(category)2")
                }
            }
        }
        //        save the possible changed array back into userDefaults
        NSUserDefaults.standardUserDefaults().setObject(achievedAchievements, forKey: "achievedAchievements")
    }
    //    fetch goals from CoreData
    func refetchData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let goalFetchRequest = NSFetchRequest(entityName: "Goal")
        let sortDescriptor = NSSortDescriptor(key: "nextDue", ascending: true)
        goalFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let resultsG = try managedContext.executeFetchRequest(goalFetchRequest)
            goals = resultsG as! [Goal]
            self.tableView.reloadData()
        } catch let error as NSError {
            //            should not happen at all
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //    reschedule an possibly existing notification for a given goal
    func rescheduleNotification(goal:Goal){
        //        delete the old notification
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["name"] as! String == goal.name{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
        // add a notification for the next due date of the goal
        let notification = UILocalNotification()
        notification.alertBody = "'\(goal.name)' is due today!"
        notification.fireDate = goal.nextDue
        notification.userInfo = ["name": goal.name]
        notification.soundName =  UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    override func viewDidAppear(animated: Bool) {
        //        initially get goals from CoreData
        self.refetchData()
        
        let calendar = NSCalendar.currentCalendar()
        
        //        check if an goal is overdue by more than 1 of his frequencyType
        for goal in goals{
            var intervall = Double()
            let dayInSeconds = Double(86400)
            var calendarUnit = NSCalendarUnit.Day
            
            //            calculate nextDue based on frequency and frequencyType
            switch goal.frequencyType {
            case "Day":
                intervall = Double(dayInSeconds/goal.frequencyValue.doubleValue)
                calendarUnit = NSCalendarUnit.Hour
            case "Week":
                intervall = Double(dayInSeconds/goal.frequencyValue.doubleValue*7)
                calendarUnit = NSCalendarUnit.Day
            case "Month":
                intervall = Double(dayInSeconds/goal.frequencyValue.doubleValue*30)
                calendarUnit = NSCalendarUnit.Day
            default: break
            }
            //            check if the nextDue is smaller than the current time given it's frequencyType
            if calendar.compareDate(goal.nextDue, toDate: NSDate(timeIntervalSinceNow: intervall), toUnitGranularity: calendarUnit)  == NSComparisonResult.OrderedAscending{
                goal.currentStreak = 0
                goal.currentProgress = 0
                goal.calculateNextDue()
                self.rescheduleNotification(goal)
            }
        }
    }
    override func viewDidLoad() {
        
        //        call parent function
        super.viewDidLoad()
        
    }
    //    use prepareForeSegue to pass the calling Cell to the GoalDetailsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        check if the correct segue is called
        if segue.identifier == "ShowGoalDetail" {
            //            get reference to GoalDetailsViewController
            let goalDetailViewController = segue.destinationViewController as! GoalDetailsViewController
            if let selectedGoalCell = sender as? GoalTableCell {
                let indexPath = tableView.indexPathForCell(selectedGoalCell)!
                let selectedGoal = goals[indexPath.row]
                //                pass the goal of the corresponding cell
                goalDetailViewController.goal = selectedGoal
            }
        }
    }
    
    func saveChanges(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
        
    }
    //    cellForRowAtIndexPath
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GoalTableCell {
        //        create a cell
        let cell:GoalTableCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! GoalTableCell
        let goal = self.goals[indexPath.row]
        let calendar = NSCalendar.currentCalendar()
        //        set cell label to goal name
        cell.goalNameLabel.text = goal.name
        cell.progressCounterLabel.text = "\(goal.currentProgress)/\(goal.frequencyValue)"
        cell.categoryImageView.image = UIImage(named: "\(goal.category).png")
        if goal.category != "None"{
            cell.categoryLabel.text = goal.category
        }
        print("goal: \(goal)")
        //   render goal a little transparent if the goal is already finished for its given frequency
        if  goal.currentProgress.intValue >= goal.frequencyValue.intValue  {
            cell.streakCountLabel.alpha = 0.3
            cell.nextDueLabel.alpha = 0.3
            cell.goalNameLabel.alpha = 0.3
            cell.streakProgressView.alpha = 0.3
            cell.categoryImageView.alpha = 0.3
            
        }
        else{
            cell.streakCountLabel.alpha = 1
            cell.nextDueLabel.alpha = 1
            cell.goalNameLabel.alpha = 1
            cell.streakProgressView.alpha = 1
            cell.categoryImageView.alpha = 1
            
        }
        
        
        let formatter = NSDateFormatter()
        var nextDueString  = ""
        let dayInSeconds = Double(86400)
        let weekInSeconds = dayInSeconds * 7
        let oneWeekAhead = NSDate(timeIntervalSinceNow: weekInSeconds)
        
        if calendar.compareDate(goal.nextDue, toDate: NSDate(), toUnitGranularity: .Day)  == NSComparisonResult.OrderedAscending{
            nextDueString = "some time ago!!"
        }
        else if calendar.isDateInToday(goal.nextDue){
            nextDueString = "Today!"
        }
        else if calendar.isDateInTomorrow(goal.nextDue){
            nextDueString = "Tomorrow."
        }
        else if calendar.compareDate(goal.nextDue, toDate: oneWeekAhead, toUnitGranularity: .Minute)  == NSComparisonResult.OrderedAscending{
            formatter.dateFormat = "EEEE"
            nextDueString = formatter.stringFromDate(goal.nextDue) + "."
        }
        else {
            formatter.dateFormat = "dd.MM."
            nextDueString = "the " + formatter.stringFromDate(goal.nextDue)
        }
        
        cell.nextDueLabel.text = "Next due to \(nextDueString)"
        cell.streakCountLabel.text = String("Streak of \(goal.currentStreak)")
        let percentValue = (goal.currentStreak.floatValue/goal.bestStreak.floatValue)
        cell.streakProgressView.setProgress(percentValue, animated: false)
        
        return cell
    }
    
    
    //#### EDIT ACTIONS FOR TABLE CELLS
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //        Action to achieve a goal
        let archievedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal ,title: "Done") { (action, NSIndexPath) -> Void in
            
            //            get the corresponding goal and its current values
            let goal = self.goals[indexPath.row]
            //            increment currentStreak, alreadyAchieved and currentProgress
            goal.currentStreak = NSNumber(int: goal.currentStreak.intValue + 1)
            goal.totalAchieved = NSNumber(int: goal.totalAchieved.intValue + 1)
            goal.currentProgress = NSNumber(int: goal.currentProgress.intValue + 1)
            //            check if we have to change values for the global achievement counters
            let globalBestStreak = NSUserDefaults.standardUserDefaults().integerForKey("globalBestStreak")
            if goal.currentStreak.integerValue > globalBestStreak {
                NSUserDefaults.standardUserDefaults().setInteger(goal.currentStreak.integerValue, forKey: "globalBestStreak")
            }
            let totalAchieved = NSUserDefaults.standardUserDefaults().integerForKey("totalAchieved")
            NSUserDefaults.standardUserDefaults().setInteger(totalAchieved + 1, forKey: "totalAchieved")
            let score = NSUserDefaults.standardUserDefaults().integerForKey("score")
            NSUserDefaults.standardUserDefaults().setInteger(score + 10, forKey: "score")
            // set bestStreak to currentStreak if the value is now higher
            if goal.currentStreak.intValue > goal.bestStreak.intValue {
                goal.bestStreak = goal.currentStreak
                
            }
            goal.lastAchieved = NSDate()
            goal.calculateNextDue()
            
            self.saveChanges()
            self.rescheduleNotification(goal)
            //            update achievement counter
            let oldCounter = NSUserDefaults.standardUserDefaults().integerForKey("counter\(goal.category)")
            NSUserDefaults.standardUserDefaults().setInteger(oldCounter + 1 , forKey: "counter\(goal.category)")
            self.recheckAchievementStatus()
            print ("Goal archieved, streak counter incremented by +1.")
            //            refetch data to reapply correct sorting
            self.refetchData()
            self.tableView.reloadData()
            
        }
        //        change the color of the action to green
        archievedAction.backgroundColor = [#Color(colorLiteralRed: 0.2941176471, green: 0.8588235294, blue: 0.3607843137, alpha: 1)#]
        
        let skippedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Skip") { (action, NSIndexPath) -> Void in
            // maybe ask the user before breaking the streak
            let goal = self.goals[indexPath.row]
            //            reset the streak counter if the goal is skipped
            goal.currentProgress = 0
            goal.currentStreak = 0
            goal.calculateNextDue()
            self.saveChanges()
            self.rescheduleNotification(goal)
            print ("Goal skipped, streak counter set to 0.")
            //            refetch data to reapply correct sorting
            self.refetchData()
            self.tableView.reloadData()
            
            
        }
        return [archievedAction, skippedAction]
        
    }
    
    
}
