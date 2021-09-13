import UIKit

protocol TaxiTariffViewDelegate: AnyObject {
    func useScores()
    func usePromocode()
    func tariffEntered()
}

class TaxiTariffView: UIView {

    //MARK: - API
    weak var delegate: TaxiTariffViewDelegate?
    
    var usedScores = false { didSet { updateScoresView() }}
    var usedPromocode = false { didSet { updatePromocodeView() }}
    var selectedIndex: Int?
    var scoresEntered = 0
    
    private let prices = [100,250,430]
    
    //MARK: - Outlets
    
    @IBOutlet weak var scoresLabel: UILabel! { didSet {
        scoresLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        scoresLabel.text = Localizable.Promocode.scores.localized
    }}
    @IBOutlet weak var scoresImageView: UIImageView!
    
    @IBOutlet weak var promocodeLabel: UILabel! { didSet {
        promocodeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        promocodeLabel.text = Localizable.Promocode.promocode.localized
    }}
    @IBOutlet weak var promocodeImageView: UIImageView!
    @IBOutlet weak var promocodeDiscountLabel: UILabel! { didSet {
        promocodeDiscountLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
        promocodeDiscountLabel.isHidden = true
    }}
    @IBOutlet weak var scoresEnterValueLabel: UILabel! { didSet {
        scoresEnterValueLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
    }}
    
    @IBOutlet weak var scoresEnteredLabel: UILabel! { didSet {
        scoresEnteredLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
        scoresEnteredLabel.text = Localizable.Scores.scoresAvailable.localized
    }}
    
    @IBOutlet weak var scoresRoundedView: RoundedView! { didSet {
        setup(scoresRoundedView)
    }}
    
    @IBOutlet weak var promocodeRoundedView: RoundedView! { didSet {
        setup(promocodeRoundedView)
    }}
    
    
    @IBOutlet weak var standartRoundedView: RoundedView! { didSet {
        setup(standartRoundedView)
        standartRoundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectStandartView(_:))))
    }}
    @IBOutlet weak var standartLabel: UILabel! { didSet {
        standartLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var standartPriceLabel: UILabel! { didSet {
        standartPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        standartPriceLabel.text = "\(prices[0]) руб"
    }}
    @IBOutlet weak var standartDurationLabel: UILabel! { didSet {
        standartDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    @IBOutlet weak var standartOldPriceLabel: UILabel! { didSet {
        standartOldPriceLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    @IBOutlet weak var standartImageView: UIImageView!
    
    @IBOutlet weak var premiumRoundedView: RoundedView! { didSet {
        setup(premiumRoundedView)
        premiumRoundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPremiumView(_:))))
    }}
    
    @IBOutlet weak var premiumLabel: UILabel! { didSet {
        premiumLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var premiumPriceLabel: UILabel! { didSet {
        premiumPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        premiumPriceLabel.text = "\(prices[1]) руб"
    }}
    @IBOutlet weak var premiumDurationLabel: UILabel! { didSet {
        premiumDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    @IBOutlet weak var premiumOldPriceLabel: UILabel! { didSet {
        premiumOldPriceLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    @IBOutlet weak var premiumImageView: UIImageView!

    @IBOutlet weak var businessRoundedView: RoundedView! { didSet {
        setup(businessRoundedView)
        businessRoundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBusinessView(_:))))
    }}
    @IBOutlet weak var businessLabel: UILabel! { didSet {
        businessLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var businessPriceLabel: UILabel! { didSet {
        businessPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        businessPriceLabel.text = "\(prices[2]) руб"
    }}
    @IBOutlet weak var businessDurationLabel: UILabel! { didSet {
        businessDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    @IBOutlet weak var businessOldPriceLabel: UILabel! { didSet {
        businessOldPriceLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    @IBOutlet weak var businessImageView: UIImageView!

    
    //MARK: - Actions
    
    @IBAction func useScores(_ sender: UIButton) {
        delegate?.useScores()
    }
    
    @IBAction func usePromocode(_ sender: UIButton) {
        delegate?.usePromocode()
    }
    
    private func setup(_ roundedView: RoundedView) {
        roundedView.colorToFill = .white
        roundedView.cornerRadius = 15.0
    }

    @objc
    private func selectStandartView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended  {
            reset()
            selectedIndex = 0
            updateStandartView()
            delegate?.tariffEntered()
        }
    }
    
    private func updateStandartView() {
        standartRoundedView.colorToFill = .white
        standartImageView.image = #imageLiteral(resourceName: "StandartCar")
        standartDurationLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        standartPriceLabel.textColor = .black
        if usedScores {
            update(oldLabel: standartOldPriceLabel, label: standartPriceLabel, oldPrice: prices[0], price: prices[0] - scoresEntered)
        }
    }
    
    @objc
    private func selectPremiumView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended  {
            reset()
            selectedIndex = 1
            updatePremiumView()
            delegate?.tariffEntered()
        }
    }
    
    private func updatePremiumView() {
        premiumRoundedView.colorToFill = .white
        premiumImageView.image = #imageLiteral(resourceName: "PremiumCar")
        premiumDurationLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.2588235294, blue: 0.9490196078, alpha: 1)
        premiumPriceLabel.textColor = .black
        if usedScores {
            update(oldLabel: premiumOldPriceLabel, label: premiumPriceLabel, oldPrice: prices[1], price: prices[1] - scoresEntered)
        }
    }
    
    
    @objc
    private func selectBusinessView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended  {
            reset()
            selectedIndex = 2
            updateBusinessView()
            delegate?.tariffEntered()
        }
    }
    
    private func updateBusinessView() {
        businessRoundedView.colorToFill = .white
        businessImageView.image = #imageLiteral(resourceName: "BusinessCar")
        businessDurationLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.7411764706, blue: 0.5019607843, alpha: 1)
        businessPriceLabel.textColor = .black
        if usedScores {
            update(oldLabel: businessOldPriceLabel, label: businessPriceLabel, oldPrice: prices[2], price: prices[2] - scoresEntered)
        }
    }
    
    func reset() {
        
        frame.size.height = 155

        selectedIndex = nil
        if !usedScores { usedScores = false }
        if !usedPromocode { usedPromocode = false }

        standartRoundedView.colorToFill = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        premiumRoundedView.colorToFill = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        businessRoundedView.colorToFill = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        
        standartDurationLabel.textColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        premiumDurationLabel.textColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        businessDurationLabel.textColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)

        standartImageView.image = #imageLiteral(resourceName: "StandartCarRaw")
        premiumImageView.image = #imageLiteral(resourceName: "PremiumCarRaw")
        businessImageView.image = #imageLiteral(resourceName: "BusinessCarRaw")

        standartPriceLabel.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5529411765, alpha: 1)
        premiumPriceLabel.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5529411765, alpha: 1)
        businessPriceLabel.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5529411765, alpha: 1)

        standartOldPriceLabel.isHidden = true
        premiumOldPriceLabel.isHidden = true
        businessOldPriceLabel.isHidden = true

        standartPriceLabel.text = "\(prices[0]) руб"
        premiumPriceLabel.text = "\(prices[1]) руб"
        businessPriceLabel.text = "\(prices[2]) руб"

        recreateViewIfNeeded()
    }
    
    func updateUIWith(scores:Int) {
        usedScores = true
        scoresLabel.isHidden = true
        scoresImageView.isHidden = true
        scoresEnteredLabel.isHidden = false
        scoresEnterValueLabel.isHidden = false
        scoresEnterValueLabel.text = "- \(scores)"
        scoresRoundedView.colorToFill = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        guard let index = selectedIndex else { return }
        switch index {
            case 0:
                let newPrice = prices[0] - scores
                update(oldLabel: standartOldPriceLabel, label: standartPriceLabel, oldPrice: prices[0], price: newPrice)
            case 1:
                let newPrice = prices[1] - scores
                update(oldLabel: premiumOldPriceLabel, label: premiumPriceLabel, oldPrice: prices[1], price: newPrice)
            case 2:
                let newPrice = prices[2] - scores
                update(oldLabel: businessOldPriceLabel, label: businessPriceLabel, oldPrice: prices[2], price: newPrice)
            default: break
        }
    }
    
    private func update(oldLabel:UILabel,label:UILabel,oldPrice:Int,price:Int) {
        label.text = "\(price) руб"
        
        oldLabel.isHidden = false
        let attrString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice) руб")
        attrString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attrString.length))
        oldLabel.attributedText = attrString
    }
    
    
    private func recreateViewIfNeeded() {
        guard let index = selectedIndex else { return }
        switch index {
            case 0:
                updateStandartView()
                if usedScores { standartOldPriceLabel.isHidden = false }
            case 1:
                updatePremiumView()
                if usedScores { premiumOldPriceLabel.isHidden = false }
            case 2:
                updateBusinessView()
                if usedScores { businessOldPriceLabel.isHidden = false }
        default:break
        }
    }
    
    private func updatePromocodeView() {
        
        promocodeRoundedView.colorToFill = usedPromocode ? #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) : .white
        promocodeImageView.isHidden = usedPromocode
        promocodeDiscountLabel.isHidden = !usedPromocode
        promocodeDiscountLabel.text = "-15%"
        promocodeLabel.font = usedPromocode ? UIFont.SFUIDisplayBold(size: 15.0) : UIFont.SFUIDisplayRegular(size: 15.0)

        
    }
    
    private func updateScoresView() {
        
        scoresImageView.isHidden = usedScores
        scoresEnteredLabel.isHidden = !usedScores
        scoresRoundedView.colorToFill = usedScores ? #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) : .white
        scoresEnterValueLabel.isHidden = !usedScores
        scoresLabel.isHidden = usedScores
    }
    
}
