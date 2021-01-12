import UIKit

class SwitchViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UITextViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return ownedPeriods.count
        }
        else {
            return conditions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return ownedPeriods[row]
        }
        else {
            return conditions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            timeTextField.text = ownedPeriods[row]
        }
        else {
            if row == 0 {
                conditionTextField.text = ""
            }
            else {
                conditionTextField.text = conditions[row]
            }
        }
    }
    
    @IBOutlet weak var switchViewSegment: UISegmentedControl!
    
    @IBOutlet weak var switchViews: UIView!
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var sellView: UIView!
    
    @IBOutlet weak var inReturnLabel: UILabel!
    @IBOutlet weak var inReturnTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionTextField: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var negotiableLabel: UILabel!
    @IBOutlet weak var negotiableSwitch: UISwitch!
    @IBOutlet weak var deliverLabel: UILabel!
    @IBOutlet weak var deliverSwitch: UISwitch!
    @IBOutlet weak var warningTextView: UITextView!
    
    let timePickerView = UIPickerView()
    let conditionPickerView = UIPickerView()
    let ownedPeriods = ["Less than 1 month", "Less than 6 months", "Less than 1 year", "Less than 2 years", "Less than 5 years", "5 years and above"]
    let conditions = ["----", "99% new", "90% new", "70% new", "50% new", "A bit old"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePickerView.tag = 0
        conditionPickerView.tag = 1
        
        setupSwitchSegment()
        setupSwitchViews()
        setupExchangeView()
        setupDismissPickerView()
    }

    func setupSwitchSegment() {
        switchViewSegment.translatesAutoresizingMaskIntoConstraints = false
        
        switchViewSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchViewSegment.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        switchViewSegment.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
    }
    
    func setupSwitchViews() {
        switchViews.translatesAutoresizingMaskIntoConstraints = false
        exchangeView.translatesAutoresizingMaskIntoConstraints = false
        sellView.translatesAutoresizingMaskIntoConstraints = false
        
        switchViews.topAnchor.constraint(equalTo: switchViewSegment.bottomAnchor, constant: 5).isActive = true
        switchViews.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        switchViews.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        switchViews.heightAnchor.constraint(equalToConstant: 650).isActive = true
        
        exchangeView.centerXAnchor.constraint(equalTo: switchViews.centerXAnchor).isActive = true
        exchangeView.centerYAnchor.constraint(equalTo: switchViews.centerYAnchor).isActive = true
        exchangeView.widthAnchor.constraint(equalToConstant: switchViews.frame.width).isActive = true
        exchangeView.heightAnchor.constraint(equalToConstant: switchViews.frame.height).isActive = true
        
        sellView.centerXAnchor.constraint(equalTo: switchViews.centerXAnchor).isActive = true
        sellView.centerYAnchor.constraint(equalTo: switchViews.centerYAnchor).isActive = true
        sellView.widthAnchor.constraint(equalToConstant: switchViews.frame.width).isActive = true
        sellView.heightAnchor.constraint(equalToConstant: switchViews.frame.height).isActive = true
    }
    
    func setupExchangeView() {
        inReturnLabel.translatesAutoresizingMaskIntoConstraints = false
        inReturnTextView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inReturnLabel.topAnchor.constraint(equalTo: switchViewSegment.bottomAnchor, constant: 15).isActive = true
        inReturnLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        inReturnTextView.topAnchor.constraint(equalTo: inReturnLabel.bottomAnchor, constant: 10).isActive = true
        inReturnTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inReturnTextView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        inReturnTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        inReturnTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        inReturnTextView.layer.cornerRadius = 5
        inReturnTextView.backgroundColor = .systemGray6
        
        timeLabel.topAnchor.constraint(equalTo: inReturnTextView.bottomAnchor, constant: 15).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        timeTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        timeTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        timeTextField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        timeTextField.addTarget(self, action: #selector(passData), for: .editingDidEnd)
        timeTextField.backgroundColor = .systemGray6
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        conditionPickerView.delegate = self
        conditionPickerView.dataSource = self
        timeTextField.inputView = timePickerView
        conditionTextField.inputView = conditionPickerView
        
        conditionLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 15).isActive = true
        conditionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        conditionTextField.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 10).isActive = true
        conditionTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        conditionTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        conditionTextField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        conditionTextField.addTarget(self, action: #selector(passData), for: .editingDidEnd)
        conditionTextField.backgroundColor = .systemGray6
    }
    
    func setupSellView() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        negotiableLabel.translatesAutoresizingMaskIntoConstraints = false
        negotiableSwitch.translatesAutoresizingMaskIntoConstraints = false
        deliverLabel.translatesAutoresizingMaskIntoConstraints = false
        deliverSwitch.translatesAutoresizingMaskIntoConstraints = false
        warningTextView.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.topAnchor.constraint(equalTo: switchViewSegment.bottomAnchor, constant: 15).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10).isActive = true
        priceTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        priceTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        priceTextField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        priceTextField.backgroundColor = .systemGray6
        priceTextField.addTarget(self, action: #selector(passData), for: .editingChanged)
        
        negotiableLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 25).isActive = true
        negotiableLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        negotiableSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        negotiableSwitch.centerYAnchor.constraint(equalTo: negotiableLabel.centerYAnchor).isActive = true
        
        deliverLabel.topAnchor.constraint(equalTo: negotiableLabel.bottomAnchor, constant: 25).isActive = true
        deliverLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        deliverSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        deliverSwitch.centerYAnchor.constraint(equalTo: deliverLabel.centerYAnchor).isActive = true
        
        warningTextView.topAnchor.constraint(equalTo: deliverLabel.bottomAnchor, constant: 50).isActive = true
        warningTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        warningTextView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        warningTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        warningTextView.layer.cornerRadius = 5
        warningTextView.backgroundColor = .systemGray6
    }
    
    @IBAction func didSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            priceTextField.text = ""
            negotiableSwitch.setOn(true, animated: false)
            deliverSwitch.setOn(true, animated: false)
            setupExchangeView()
            switchViews.bringSubviewToFront(exchangeView)
        }
        else {
            inReturnTextView.text = ""
            timeTextField.text = ""
            conditionTextField.text = ""
            setupSellView()
            switchViews.bringSubviewToFront(sellView)
        }
    }
    
    func setupDismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inReturnTextView.inputAccessoryView = toolBar
        timeTextField.inputAccessoryView = toolBar
        conditionTextField.inputAccessoryView = toolBar
        priceTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBAction func negotiableSwitchTouched(_ sender: Any) {
        if negotiableSwitch.isOn {
            priceLabel.text = "Price($CA)"
            priceLabel.textColor = .black
        }
        else {
            priceLabel.text = "Price($CA)*"
            priceLabel.textColor = .red
        }
        passData()
    }
    
    @objc func passData() {
        let parentVC = parent as! NewPostViewController
               
        if switchViewSegment.selectedSegmentIndex == 0 {
            parentVC.postType = "exchange"
            parentVC.inReturnText = inReturnTextView.text!
            parentVC.timeOwned = timeTextField.text!
            parentVC.currentCondition = conditionTextField.text!
        }
        else {
            parentVC.postType = "sell"
            parentVC.price = priceTextField.text!
                
            if negotiableSwitch.isOn {
                parentVC.negotiable = true
            }
            else {
                parentVC.negotiable = false
            }
            if deliverSwitch.isOn {
                parentVC.deliver = true
            }
            else {
                parentVC.deliver = false
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        passData()
    }
}
