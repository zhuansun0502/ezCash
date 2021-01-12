import UIKit
import Firebase
import JVFloatLabeledTextField
import SVProgressHUD
import SCLAlertView

class UserPasswordLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var welcomeLabel1: UILabel!
    @IBOutlet weak var welcomeLabel2: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var showPasswdButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwdTextField: JVFloatLabeledTextField!
        
    var emailAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel1.adjustsFontSizeToFitWidth = true
        welcomeLabel2.adjustsFontSizeToFitWidth = true
        
        setupCancelButton()
        setupPasswdTextField()
        setupRegisterButton()
        setupShowPasswdButton()
    }

    func setupCancelButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let cancelButtonIcon = UIImage(systemName: "chevron.left", withConfiguration: config)

        cancelButton.setImage(cancelButtonIcon, for: .normal)
        cancelButton.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    func setupPasswdTextField() {
        passwdTextField.delegate = self
        passwdTextField.setPlaceholder("Password", floatingTitle: "Password")
        passwdTextField.layer.cornerRadius = 10
        passwdTextField.floatingLabelYPadding = 7
    }
    
    func setupRegisterButton() {
        loginButton.backgroundColor = .some(UIColor(red: 0, green: 0.7686, blue: 0.051, alpha: 1.0))
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 10
        loginButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        loginButton.layer.shadowRadius = 1
        loginButton.layer.shadowOpacity = 0.1
        loginButton.isEnabled = false
    }
    
    func setupShowPasswdButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        let showPasswdButtonIcon = UIImage(systemName: "eye.slash", withConfiguration: config)
        
        showPasswdButton.tintColor = .systemGray
        showPasswdButton.setImage(showPasswdButtonIcon, for: .normal)
        showPasswdButton.sizeToFit()
    }
    
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        let trans = CATransition()
        trans.duration = 0.3
        trans.type = .moveIn
        trans.subtype = .fromLeft
        
        view.window?.layer.add(trans, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if passwdTextField.text != "" && passwdTextField.text!.count >= 6 {
            loginButton.isEnabled = true
        }
        else {
            loginButton.isEnabled = false
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwdTextField.text != "" && passwdTextField.text!.count >= 6 {
            loginButton.isEnabled = true
        }
        else {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func showPasswdButtonTouched(_ sender: Any) {
        passwdTextField.isSecureTextEntry = !passwdTextField.isSecureTextEntry
        
        let config = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        showPasswdButton.tintColor = .systemGray
        showPasswdButton.sizeToFit()
        
        if passwdTextField.isSecureTextEntry == false {
            let showPasswdButtonIcon_show = UIImage(systemName: "eye", withConfiguration: config)
            showPasswdButton.setImage(showPasswdButtonIcon_show, for: .normal)
        }
        else {
            let showPasswdButtonIcon_hide = UIImage(systemName: "eye.slash", withConfiguration: config)
            showPasswdButton.setImage(showPasswdButtonIcon_hide, for: .normal)
        }
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Logging in...")
        SVProgressHUD.setMinimumSize(CGSize(width: 80, height: 80))
        self.view.isUserInteractionEnabled = false
        
        FireBaseHelper().login(email: emailAddress, password: passwdTextField.text!) {
            (success) in
            
            if success {
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                
                let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.showError("Login Failed", subTitle: "Your password is incorrect")
            }
        }
    }
}
