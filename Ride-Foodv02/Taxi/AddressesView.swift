import UIKit

protocol AddressesViewDelegate: AnyObject {
    func moveDown()
    func next()
}

class AddressesView: UIView {

    //MARK: - API
    weak var delegate: AddressesViewDelegate?
    
    var fromAddress = String() { didSet {
        fromTextField?.text = fromAddress
        updateUI()
    }}
    var toAddress = String() { didSet {
        toTextField?.text = toAddress
        updateUI()
    }}
    
    //MARK: - Outlets
    
    @IBOutlet weak var fromTextField: UITextField! { didSet {
        fromTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    @IBOutlet weak var fromAnnotationView: UIImageView!
    @IBOutlet weak var fromUnderbarLine: UIView!
    
    @IBOutlet weak var toTextField:UITextField! { didSet {
        toTextField.font = UIFont.SFUIDisplayLight(size: 17.0)
    }}
    @IBOutlet weak var toAnnotationView: UIImageView!
    @IBOutlet weak var toUnderbarLine: UIView!
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoCorneredView: TopRoundedView!
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    @IBOutlet weak var nextButton: UIButton! { didSet {
        nextButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    
    @IBAction func next(_ sender: UIButton) {
        if !fromAddress.isEmpty && !toAddress.isEmpty {
            delegate?.next()
        }
    }

    //MARK: - UI update
    
    private func updateUI() {
        fromUnderbarLine.backgroundColor = fromAddress.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        toUnderbarLine.backgroundColor = toAddress.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        
        fromAnnotationView.image = fromAddress.isEmpty ? #imageLiteral(resourceName: "RawAnnotation") : #imageLiteral(resourceName: "Annotation")
        toAnnotationView.image = toAddress.isEmpty ? #imageLiteral(resourceName: "RawAnnotation") : #imageLiteral(resourceName: "Annotation")

        nextButton.isUserInteractionEnabled = !fromAddress.isEmpty && !toAddress.isEmpty
        roundedView.colorToFill = (!fromAddress.isEmpty && !toAddress.isEmpty) ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }
    
    
    //MARK: - Init
    
    private func setup() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(moveDown(_:)))
        swipe.direction = .down
        addGestureRecognizer(swipe)
    }
    
    @objc
    private func moveDown(_ recgoznier: UISwipeGestureRecognizer) {
        toTextField.resignFirstResponder()
        delegate?.moveDown()
    }
    
    
    
}
