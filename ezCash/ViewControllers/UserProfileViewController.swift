import UIKit
import SVProgressHUD
import SCLAlertView

class UserProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        
    @IBOutlet weak var profileHeaderView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var emailImage: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var postsNumLabel: UILabel!
    @IBOutlet weak var soldNumLabel: UILabel!
    @IBOutlet weak var ratingNumLabel: UILabel!
    
    
    let transition = SlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupProfileHeaderView()
        setupBackButton()
        setupSettingButton()
    }
    
    func setupProfileHeaderView() {
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        profileHeaderView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        profileHeaderView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        setupProfileImageView()
        setupLabels()
        setupImageViews()
    }
    
    func setupLabels() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        postsLabel.translatesAutoresizingMaskIntoConstraints = false
        soldLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        postsNumLabel.translatesAutoresizingMaskIntoConstraints = false
        soldNumLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingNumLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 25).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor).isActive = true
        
        postsLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 30).isActive = true
        postsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width/6).isActive = true
        
        soldLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 30).isActive = true
        soldLabel.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor).isActive = true
        
        ratingLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 30).isActive = true
        ratingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.frame.width / 6).isActive = true
        
        postsNumLabel.topAnchor.constraint(equalTo: postsLabel.bottomAnchor, constant: 20).isActive = true
        postsNumLabel.centerXAnchor.constraint(equalTo: postsLabel.centerXAnchor).isActive = true
        
        soldNumLabel.topAnchor.constraint(equalTo: soldLabel.bottomAnchor, constant: 20).isActive = true
        soldNumLabel.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor).isActive = true
        
        ratingNumLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20).isActive = true
        ratingNumLabel.centerXAnchor.constraint(equalTo: ratingLabel.centerXAnchor).isActive = true
    }
    
    func setupImageViews() {
        phoneImage.translatesAutoresizingMaskIntoConstraints = false
        emailImage.translatesAutoresizingMaskIntoConstraints = false
        
        phoneImage.rightAnchor.constraint(equalTo: profileHeaderView.rightAnchor, constant: -profileHeaderView.frame.width/12).isActive = true
        phoneImage.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 25).isActive = true
        phoneImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        phoneImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        phoneImage.tintColor = .systemGray4
        
        emailImage.rightAnchor.constraint(equalTo: profileHeaderView.rightAnchor, constant: -profileHeaderView.frame.width/12).isActive = true
        emailImage.topAnchor.constraint(equalTo: phoneImage.bottomAnchor, constant: 15).isActive = true
        emailImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupProfileImageView() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileHeaderView.widthAnchor, multiplier: 1/3).isActive = true
        profileImage.widthAnchor.constraint(equalTo: profileHeaderView.widthAnchor, multiplier: 1/3).isActive = true
        
        SVProgressHUD.show()
        FireBaseHelper().getUserInfo() {
            (email, imageURL, userName, phoneNum) in

            self.userNameLabel.text = userName
            
            if phoneNum != "" {
                self.phoneImage.tintColor = .systemBlue
            }
            
            let tURL = URL(string: imageURL)
            URLSession.shared.dataTask(with: tURL!, completionHandler: {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(data: data!)
                    SVProgressHUD.dismiss()
                }
            }).resume()
            self.navigationItem.title = email
        }
        
        profileImage.layoutIfNeeded()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleToFill
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImage)))
        profileImage.isUserInteractionEnabled = true
    }
    
    func setupBackButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let backButtonIcon = UIImage(systemName: "xmark", withConfiguration: config)

        backButton.tintColor = .black
        backButton.setImage(backButtonIcon, for: .normal)
        backButton.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func uploadImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func setupSettingButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let settingButtonIcon = UIImage(systemName: "gear", withConfiguration: config)

        settingButton.tintColor = .black
        settingButton.setImage(settingButtonIcon, for: .normal)
        settingButton.sizeToFit()

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImg: UIImage?
        
        if let editedImg = info[.editedImage] as? UIImage {
            selectedImg = editedImg
        }
        else if let originalImage = info[.originalImage] as? UIImage {
            selectedImg = originalImage
        }
        
        if let img = selectedImg {
            profileImage.image = img
        }
        
        SVProgressHUD.show(withStatus: "Uploading image...")
        
        guard let image = profileImage.image,
            let imgData = image.jpegData(compressionQuality: 1.0) else {
                var alertView = SCLAlertView()
                let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300.0)
                alertView = SCLAlertView(appearance: appearance)
                
                alertView.showError("Error", subTitle: "Unable to upload image, please try again later")
                return
        }
        
        FireBaseHelper().uploadImage(uploadType: "pic_profile", imageData: [imgData], postID: "") {
            (success, url) in
            
            if !success {
                var alertView = SCLAlertView()
                let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300.0)
                alertView = SCLAlertView(appearance: appearance)
                
                alertView.showError("Error", subTitle: "Unable to upload image, please try again later")
            }
            
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonTouched(_ sender: Any) {
        presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingButtonTouched(_ sender: Any) {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController")
        
        sideMenu!.modalPresentationStyle = .overCurrentContext
        sideMenu!.transitioningDelegate = self
        present(sideMenu!, animated: true, completion: nil)
    }
}

extension UserProfileViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
