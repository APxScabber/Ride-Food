//
//  PaymentWaysViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import UIKit

class PaymentWaysViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var linkCardButtonOutlet: UIButton!
    
    // MARK: - Properties
    
    var navigationTitle = PaymentMainViewText.topTitle.text()
    
    let cellHeight: CGFloat = 44
    var selectedCell: Int = 0
    
    var textPaymentOptions = [[String]]()
    var paymentOptions = [PaymentWaysModel]()
    
    let paymentWaysInteractor = PaymentWaysInteractor()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navigationTitle
        
        paymentWaysInteractor.getUserID()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        bgImageView.image = #imageLiteral(resourceName: "paymentWaysBG")
        
        linkCardButtonOutlet.alpha = 0
        isFirstEnter()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPaymentData()
    }
    
    // MARK: - Methods
    
    //Настройка кнопки Привязать карту
    private func setupLinkCardButton() {

        if textPaymentOptions[1].count == 1 {
            linkCardButtonOutlet.style()
            linkCardButtonOutlet.backgroundColor = PaymentWaysColors.blueColor.value
            linkCardButtonOutlet.setTitle(PaymentMainViewText.addButtonText.text(), for: .normal)
            linkCardButtonOutlet.alpha = 1
        } else {
            linkCardButtonOutlet.alpha = 0
        }
    }
    
    // Получаем данные о картах с сервера и в соответствии c этим заполняем Table View
    private func getPaymentData() {
        
        textPaymentOptions = [[PaymentMainViewText.cashTV.text(), "Apple Pay"], [PaymentMainViewText.scoresTV.text()]]
        
        paymentWaysInteractor.loadPaymentData { modelsArray in
            
            DispatchQueue.main.async {
                self.paymentOptions = []
                self.paymentOptions = modelsArray
                self.createPaymentOptions()
                self.setupLinkCardButton()
                self.tableView.reloadData()
            }
        }
    }
    
    // Определяем есть ли у пользователя уже привязанные к аккаунту карты или нет
    // Формируем массив данных для Table View
    private func createPaymentOptions() {
        
        if paymentOptions.isEmpty {
            let bankCard = PaymentMainViewText.bankCardTV.text()
            textPaymentOptions[0].insert(bankCard, at: 1)
        } else {
            for i in 0 ... paymentOptions.count - 1 {
                let index = i + 1
                textPaymentOptions[0].insert(paymentOptions[i].number, at: index)
            }
            let addCard = PaymentMainViewText.addCardTV.text()
            textPaymentOptions[1].insert(addCard, at: 0)
        }
    }
    
    
    // Устанавливаем в Table View Cell картинку слева
    private func setLefImage(for cell: PaymentWaysTableViewCell, section: Int, row: Int) {
        if section == 0 {
            switch row {
            case 0:
                cell.leftImageView.image = #imageLiteral(resourceName: "cash")
                
            case textPaymentOptions[0].count - 1 :
                cell.leftImageView.image = #imageLiteral(resourceName: "applePay")
                
            default:
                if paymentOptions.isEmpty {
                    cell.leftImageView.image = #imageLiteral(resourceName: "one")
                } else {
                    cell.leftImageView.image = #imageLiteral(resourceName: "visa")
                }
            }
        } else {
            if textPaymentOptions[1].count == 1 {
                cell.leftImageView.image = UIImage(named: "scores")
            } else {
                switch row {
                case 1:
                    cell.leftImageView.image = UIImage(named: "scores")
                default:
                    cell.leftImageView.image = nil
                }
            }
        }
    }
    
    // Устанавливаем в Table View Cell картинку справа
    private func setRightImage(for cell: PaymentWaysTableViewCell, section: Int, row: Int) {
        if section == 0 {
            if paymentOptions.isEmpty {
                switch row {
                case 1:
                    cell.rightImageView.image = #imageLiteral(resourceName: "rightArrow")
                default :
                    cell.rightImageView.image = row == selectedCell ? #imageLiteral(resourceName: "selectedCheckBox") : #imageLiteral(resourceName: "emptyCheckBox")
                }
            } else {
                cell.rightImageView.image = row == selectedCell ? #imageLiteral(resourceName: "selectedCheckBox") : #imageLiteral(resourceName: "emptyCheckBox")
            }
        } else {
            cell.rightImageView.image = #imageLiteral(resourceName: "rightArrow")
        }
    }
    
    //Проверяем первый ли это вход, если да, то показываем общее количество бонусных баллов
    private func isFirstEnter() {
        
        let isFirst = UserDefaultsManager.shared.isFirstEnter
        
        if isFirst {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CongratulationsScores") as! CongratulationsScoresViewController
            vc.modalPresentationStyle = .formSheet
            vc.userID = paymentWaysInteractor.userID
            present(vc, animated: true, completion: nil)
            
            UserDefaultsManager.shared.isFirstEnter = false
        }
    }
    
    // MARK: - Actions
    
    //Действие по нажатию на кнопку Привязать карту
    @IBAction func linkCardButtonAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Действие по нажатию на кнопку Назад
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - Extensions TableView Data Source
extension PaymentWaysViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return textPaymentOptions.isEmpty ? 1 : textPaymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textPaymentOptions.isEmpty ? 0 : textPaymentOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentWaysTableViewCell
        
        cell.paymentTextLabel.text = ""
        cell.textLabel?.text = ""
        setLefImage(for: cell, section: indexPath.section, row: indexPath.row)
        
        if textPaymentOptions[1].count == 1 {
            cell.paymentTextLabel.text = textPaymentOptions[indexPath.section][indexPath.row]
        } else {
            switch indexPath.section {
            case 0:
                let inputText = textPaymentOptions[indexPath.section][indexPath.row]
                if paymentWaysInteractor.filter(text: inputText) {
                    let formatedCardNumber = PaymentMainViewText.cardNumber.text() + " " + inputText.suffix(4)
                    let finallText = paymentWaysInteractor.createTextAttribute(for: formatedCardNumber)
                    cell.paymentTextLabel.attributedText = finallText
                } else {
                    cell.paymentTextLabel.text = inputText
                }

            case 1:
                if indexPath.row == 0 {
                    cell.textLabel?.text = textPaymentOptions[indexPath.section][indexPath.row]
                } else {
                    cell.paymentTextLabel.text = textPaymentOptions[indexPath.section][indexPath.row]
                }
            default:
                break
            }
        }
        
        setRightImage(for: cell, section: indexPath.section, row: indexPath.row)
        
        return cell
    }
 
}

// MARK: - Extensions TableView Delegate
extension PaymentWaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let cellPreview = tableView.visibleCells[selectedCell] as! PaymentWaysTableViewCell
            let cellCurrent = tableView.visibleCells[indexPath.row] as! PaymentWaysTableViewCell
            
            if !paymentOptions.isEmpty {
                cellPreview.rightImageView.image = #imageLiteral(resourceName: "emptyCheckBox")
                cellCurrent.rightImageView.image = #imageLiteral(resourceName: "selectedCheckBox")
                selectedCell = indexPath.row
            } else {
                switch indexPath.row {
                case 1:
                    let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
                    navigationController?.pushViewController(vc, animated: true)
                default :
                    cellPreview.rightImageView.image = #imageLiteral(resourceName: "emptyCheckBox")
                    cellCurrent.rightImageView.image = #imageLiteral(resourceName: "selectedCheckBox")
                    selectedCell = indexPath.row
                }
            }
        } else {
            switch indexPath.row {
            case 0:
                let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TotalScores") as! TotalScoreViewController
                vc.modalPresentationStyle = .formSheet
                vc.userID = paymentWaysInteractor.userID
                present(vc, animated: true, completion: nil)
            default :
                print("???????")
            }
        }
            
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
}


