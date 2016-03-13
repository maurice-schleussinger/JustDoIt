
import Foundation
import CoreAudioKit

class GamificationViewController: UIViewController {
    
    @IBOutlet var PointsLabel: UILabel!
    @IBOutlet var LevelLabel: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var totalAchievedLabel: UILabel!
    @IBOutlet var achievementCounterLabel: UILabel!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let titles = ["Newborn Achiever",
            "Teenie Achiever",
            "Advanced Achiever",
            "Professional Achiever",
            "Expert Achiever",
            "Grand Achiever"]
        let levels = [100, 200, 400, 600, 800, 1500]
        
        let globalBestStreak = NSUserDefaults.standardUserDefaults().integerForKey("globalBestStreak")
        let totalAchieved = NSUserDefaults.standardUserDefaults().integerForKey("totalAchieved")
        let score = NSUserDefaults.standardUserDefaults().integerForKey("score")
        var level = 0
        while score > levels[level]{
            level = level + 1
        }
        self.LevelLabel.text = "Level \(level)"
        self.totalAchievedLabel.text = "You have reached a total of \(totalAchieved) goals. \nGreat job!"
        self.TitleLabel.text = titles[level]
        self.PointsLabel.text = "\(score) Points"
        //        TODO count achievements
        self.achievementCounterLabel.text = "You got \(0) out of 12 Achievements."
        
    }
}