import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var reputationLabel: UILabel!
  @IBOutlet var bronzeLabel: UILabel!
  @IBOutlet var silverLabel: UILabel!
  @IBOutlet var goldLabel: UILabel!
  
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.text = user.displayName
    reputationLabel.text = format(value: user.reputation)
    bronzeLabel.text = "\(user.badgeCounts.bronze)"
    silverLabel.text = "\(user.badgeCounts.silver)"
    goldLabel.text = "\(user.badgeCounts.gold)"
  }
  
  private func format(value: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .decimal
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: value)) ?? "n.a."
  }
}
