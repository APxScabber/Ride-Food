import UIKit

class MainScreenTableViewController: UITableViewController {

    @IBOutlet weak var menuLabel: UILabel! { didSet {
        menuLabel.font = UIFont.SFUIDisplaySemibold(size: 26)
    }}

    @IBAction func dismiss(_ sender: UIButton) {
        
    }
    
}
