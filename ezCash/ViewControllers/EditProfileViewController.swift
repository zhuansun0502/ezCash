import UIKit
import JVFloatLabeledTextField
import SVProgressHUD
import SCLAlertView

class EditProfileViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    
    @IBOutlet weak var nameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var phoneNumTextField: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
    }
    
    func setupView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        phoneNumLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        phoneNumLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        phoneNumTextField.topAnchor.constraint(equalTo: phoneNumLabel.bottomAnchor, constant: 10).isActive = true
        phoneNumTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        phoneNumTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        phoneNumTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @IBAction func saveButtonTouched(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Updating...")
        view.isUserInteractionEnabled = false
        
        if nameTextField.text != "" && phoneNumTextField.text != "" {
            FireBaseHelper().updateUserInfo(userName: nameTextField.text!, phoneNum: phoneNumTextField.text!) {
                (success) in
                
                if success {
                    self.view.isUserInteractionEnabled = true
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else {
            SVProgressHUD.dismiss()
            view.isUserInteractionEnabled = true
            var alertView = SCLAlertView()
            let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300.0)
            alertView = SCLAlertView(appearance: appearance)
            alertView.showWarning("Error", subTitle: "You need to fill both fields")
        }
    }
    
    @IBAction func backButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
