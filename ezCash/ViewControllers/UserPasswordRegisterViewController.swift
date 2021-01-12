import UIKit
import Firebase
import JVFloatLabeledTextField
import SVProgressHUD
import SCLAlertView

class UserPasswordRegisterViewController: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var welcomeLabel1: UILabel!
    @IBOutlet weak var welcomeLabel2: UILabel!
    @IBOutlet weak var showPasswdButton: UIButton!
    
    @IBOutlet weak var passwdTextField: JVFloatLabeledTextField!
    
    var alertView = SCLAlertView()
    
    var emailAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel1.adjustsFontSizeToFitWidth = true
        welcomeLabel2.adjustsFontSizeToFitWidth = true
        
        setupCancelButton()
        setupPasswdTextField()
        setupRegisterButton()
        setupShowPasswdButton()
        setupAlertView()
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
        registerButton.backgroundColor = .some(UIColor(red: 0, green: 0.7686, blue: 0.051, alpha: 1.0))
        registerButton.tintColor = .white
        registerButton.layer.cornerRadius = 10
        registerButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        registerButton.layer.shadowRadius = 1
        registerButton.layer.shadowOpacity = 0.1
        registerButton.isEnabled = false
    }
    
    func setupShowPasswdButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        let showPasswdButtonIcon = UIImage(systemName: "eye.slash", withConfiguration: config)
        
        showPasswdButton.tintColor = .systemGray
        showPasswdButton.setImage(showPasswdButtonIcon, for: .normal)
        showPasswdButton.sizeToFit()
    }
    
    func setupAlertView() {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 300.0,
            showCloseButton: false
        )
        alertView = SCLAlertView(appearance: appearance)
                
        self.alertView.addButton("Set up profile", backgroundColor: .some(UIColor(red: 0, green: 0.7686, blue: 0.051, alpha: 1.0)) ,target: self, selector: #selector(self.setupProfile))
        self.alertView.addButton("Set up later", backgroundColor: .some(UIColor(red: 0, green: 0.7686, blue: 0.051, alpha: 1.0)), target: self, selector: #selector(self.backToMap))
        
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        let trans = CATransition()
        trans.duration = 0.3
        trans.type = .moveIn
        trans.subtype = .fromLeft
        trans.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        view.window?.layer.add(trans, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if passwdTextField.text != "" && passwdTextField.text!.count >= 6{
            registerButton.isEnabled = true
            passwdTextField.floatingLabelActiveTextColor = .systemBlue
            passwdTextField.floatingLabelTextColor = .systemBlue
        }
        else {
            registerButton.isEnabled = false
            passwdTextField.floatingLabelActiveTextColor = .red
            passwdTextField.floatingLabelTextColor = .red
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwdTextField.text != "" && passwdTextField.text!.count >= 6{
            registerButton.isEnabled = true
            passwdTextField.floatingLabelActiveTextColor = .systemBlue
            passwdTextField.floatingLabelTextColor = .systemBlue
        }
        else {
            registerButton.isEnabled = false
            passwdTextField.floatingLabelActiveTextColor = .red
            passwdTextField.floatingLabelTextColor = .red
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
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Signing up...")
        SVProgressHUD.setMinimumSize(CGSize(width: 80, height: 80))
        self.view.isUserInteractionEnabled = false
        
        FireBaseHelper().createNewUser(email: emailAddress, password: passwdTextField.text!) {
            (success) in
            
            if success {
                self.view.isUserInteractionEnabled = true
                FireBaseHelper().uploadImage(uploadType: "pic_profile", imageData: [(UIImage(named: "profile_pic")?.jpegData(compressionQuality: 1.0))!], postID: "") {
                           (success, url) in

                    if !success {
                        var alertView = SCLAlertView()
                        let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300.0)
                        alertView = SCLAlertView(appearance: appearance)

                        alertView.showError("Error", subTitle: "Unable to upload image, please try again later")
                    }
                    else {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        self.alertView.showSuccess("Congratulations!", subTitle: "You have successfully created your account")

                        return
                    }
                }
            }
            else {
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                self.alertView.showError("Error", subTitle: "An error occurred, please try again later")
                
                return
            }
        }
    }

    @objc func setupProfile() {
        performSegue(withIdentifier: "userProfileView", sender: self)
    }
    
    @objc func backToMap() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
