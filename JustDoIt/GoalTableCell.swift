

import Foundation
import UIKit

class GoalTableCell: UITableViewCell {
    
    @IBOutlet var goalNameLabel: UILabel!
    @IBOutlet var nextDueLabel: UILabel!
    @IBOutlet var streakProgressView: UIProgressView!
    @IBOutlet var streakCountLabel: UILabel!
    @IBOutlet var categoryImageView: UIImageView!
    
    @IBOutlet var progressCounterLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
}
