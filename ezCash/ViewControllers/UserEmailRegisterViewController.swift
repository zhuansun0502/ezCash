import UIKit
import Firebase
import SVProgressHUD
import JVFloatLabeledTextField

class UserEmailRegisterViewController: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var welcomeLabel1: UILabel!
    @IBOutlet weak var welcomeLabel2: UILabel!
    @IBOutlet weak var welcomeLabel3: UILabel!
    
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelRegisterButton: UIButton!
    
    var isUserFound: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWelcomeLabels()
        setupEmailTextField()
        setupRegisterButton()
    }
    
    func setupWelcomeLabels() {
        welcomeLabel1.adjustsFontSizeToFitWidth = true
        welcomeLabel2.adjustsFontSizeToFitWidth = true
        welcomeLabel3.adjustsFontSizeToFitWidth = true
    }
    
    func setupEmailTextField() {
        emailTextField.delegate = self
        emailTextField.setPlaceholder("Email", floatingTitle: "Email")
        emailTextField.layer.cornerRadius = 10
        emailTextField.floatingLabelYPadding = 7
        emailTextField.floatingLabelTextColor = .systemBlue
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !isValidEmail() {
            emailTextField.floatingLabelActiveTextColor = .red
            registerButton.isEnabled = false
        }
        else {
            emailTextField.floatingLabelActiveTextColor = .systemBlue
            registerButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if !isValidEmail() {
            emailTextField.floatingLabelTextColor = .red
        }
        else {
            emailTextField.floatingLabelTextColor = .systemBlue
        }
        
        return true
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: emailTextField.text)
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        let trans = CATransition()
        trans.duration = 0.3
        trans.type = .moveIn
        trans.subtype = .fromRight
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        
        FireBaseHelper().searchForUser(email: emailTextField.text!) {
            (userFound) in
            
            if !userFound {
                self.isUserFound = false
                SVProgressHUD.dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.performSegue(withIdentifier: "registerView", sender: self)
                    self.view.window?.layer.add(trans, forKey: kCATransition)
                    self.view.isUserInteractionEnabled = true
                }
            }
            else {
                self.isUserFound = true
                SVProgressHUD.dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.performSegue(withIdentifier: "loginView", sender: self)
                    self.view.window?.layer.add(trans, forKey: kCATransition)
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @IBAction func cancelRegisterButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isUserFound {
            let des = segue.destination as! UserPasswordLoginViewController
            des.emailAddress = emailTextField.text!
        }
        else {
            let des = segue.destination as! UserPasswordRegisterViewController
            des.emailAddress = emailTextField.text!
        }
    }
}
