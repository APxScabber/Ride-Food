import UIKit

class OrderHistoryVC: UIViewController {

   //MARK: - Outlets
    @IBOutlet weak var label: UILabel! { didSet {
        label.font = UIFont.SFUIDisplayRegular(size: 26.0)
    }}
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! { didSet {
        guard let font = UIFont.SFUIDisplayRegular(size: 15.0) else { return }
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentedControl.setTitle(Localizable.OrderHistory.done.localized, forSegmentAt: 0)
        segmentedControl.setTitle(Localizable.OrderHistory.canceled.localized, forSegmentAt: 1)
    }}
    @IBOutlet weak var transparentView: UIView! { didSet {
        transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveDetailViewBack(_:))))
    }}
    
    let taxiDetailView = TaxiDetailView.initFromNib()
    let foodDetailView = FoodDetailView.initFromNib()
    
    private var initialDetailViewFrame: CGRect = .zero
    private var selectedIndexPath: IndexPath?
    
    //MARK: - Actions
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func changeOrderType(_ sender: UISegmentedControl) {
        tableView.beginUpdates()
        tableView.visibleCells.forEach {
            if let orderHistoryCell = $0 as? OrderHistoryTableViewCell {
                orderHistoryCell.updateViews()
            }
        }
        tableView.endUpdates()
        perform(#selector(update), with: nil, afterDelay: 0.25)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localizable.OrderHistory.history.localized
        foodDetailView.isHidden = true
        taxiDetailView.isHidden = true
        view.addSubview(foodDetailView)
        view.addSubview(taxiDetailView)
    }
    
    //MARK: - Reload data
    @objc
    private func update() {
        tableView.reloadData()
    }
}

//MARK: - UItableview datasourse


extension OrderHistoryVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath)
        
        if let orderHistoryCell = cell as? OrderHistoryTableViewCell {
            orderHistoryCell.orderHistoryState = segmentedControl.selectedSegmentIndex == 0 ? .done : .cancel
            return orderHistoryCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        transparentView.isHidden = false
        tableView.cellForRow(at: indexPath)?.isHidden = true
        selectedIndexPath = indexPath
        tableView.isUserInteractionEnabled = false
        let cellFrame = tableView.rectForRow(at: indexPath)
        let cellFrameInView = tableView.convert(cellFrame, to: tableView.superview)
        initialDetailViewFrame = CGRect(x: 25, y: cellFrameInView.origin.y, width: view.bounds.width - 50, height: cellFrameInView.height)
        taxiDetailView.frame = initialDetailViewFrame
        taxiDetailView.isHidden = false
        taxiDetailView.alpha = 0
        let newFrame = CGRect(x: 25, y: 200, width: view.bounds.width - 50, height: 390)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.taxiDetailView.alpha = 1.0
            self.taxiDetailView.frame = newFrame
            self.taxiDetailView.cornerRadius = 15.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return segmentedControl.selectedSegmentIndex == 0 ? 120 : 150
    }
    
    @objc
    private func moveDetailViewBack(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
                self.taxiDetailView.alpha = 0.0
                self.taxiDetailView.frame = self.initialDetailViewFrame
            } completion: { if $0 == .end {
                self.tableView.cellForRow(at: self.selectedIndexPath!)?.isHidden = false
                self.transparentView.isHidden = true
                self.tableView.isUserInteractionEnabled = true
            }
            }

        }
    }
    
}
