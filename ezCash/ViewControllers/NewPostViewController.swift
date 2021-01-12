import UIKit
import Pickle
import Photos
import SVProgressHUD
import SCLAlertView
import CoreLocation

class NewPostViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
        
    @IBOutlet weak var switchView: UIView!
    
    var itemImages = [UIImage]()
    var postType = ""
    var inReturnText = ""
    var timeOwned = ""
    var currentCondition = ""
    var price = ""
    var negotiable = true
    var deliver = true
    
    var postID = ""

    let config = UIImage.SymbolConfiguration(weight: .ultraLight)
    var imageIcon = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.keyboardDismissMode = .onDrag
        imageScrollView.backgroundColor = .systemGray5
        imageIcon = UIImage(systemName: "camera.circle", withConfiguration: config)!
        itemImages = [imageIcon]
        
        displaySelectedImages()
        setupTextView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(post))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func displaySelectedImages() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        imageScrollView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        for i in 0..<itemImages.count {
            let imageView = UIImageView()
            imageView.image = itemImages[i]
            imageView.contentMode = .scaleAspectFit
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImage)))
            imageView.isUserInteractionEnabled = true
            
            imageView.frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.imageScrollView.frame.height)
            
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(i + 1)
            imageScrollView.addSubview(imageView)
        }
    }
    
    func setupTextView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        titleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        titleTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        titleTextField.layer.cornerRadius = 5
        titleTextField.backgroundColor = .systemGray6
        titleTextField.delegate = self
        
        descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        descriptionTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        descriptionTextView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.backgroundColor = .systemGray6
        descriptionTextView.delegate = self
        
        switchView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
        switchView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        switchView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        switchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func uploadImage() {
        var parameters = Pickle.Parameters()
        parameters.allowedSelections = .limit(to: 3)
        let picker = ImagePickerController(configuration: parameters)
        
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func post() {
        let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300)
        
        if titleTextField.text == "" || descriptionTextView.text == "" || timeOwned == "" {
            let alertView = SCLAlertView(appearance: appearance)
            alertView.showError("Error", subTitle: "Please fill all essential fields")
            return
        }
        else {
            if postType == "exchange" {
                if timeOwned == "" {
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.showError("Error", subTitle: "Please fill all essential fields")
                    return
                }
            }
            else {
                if negotiable == false && price == "" {
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.showError("Error", subTitle: "Please fill all essential fields")
                    return
                }
            }
        }
        
        if itemImages[0] == imageIcon {
            var alertView = SCLAlertView()
            alertView = SCLAlertView(appearance: appearance)
            
            alertView.showError("Error", subTitle: "Please choose at least one picture")
        }
        else {
            postID = NSUUID().uuidString
            SVProgressHUD.show(withStatus: "Posting...")
            SVProgressHUD.setMinimumSize(CGSize(width: 80, height: 80))
            self.view.isUserInteractionEnabled = false
            
            var imgData = [Data]()
            for i in 0..<itemImages.count {
                imgData.append(itemImages[i].jpegData(compressionQuality: 1.0)!)
            }
            
            FireBaseHelper().createNewPost(postType: postType, title: titleTextField.text!, description: descriptionTextView.text, inReturnText: inReturnText, timeOwned: timeOwned, currentCondition: currentCondition, price: price, negotiable: negotiable, deliver: deliver, postID: postID, latitude: String(CLLocationManager().location!.coordinate.latitude), longitude: String(CLLocationManager().location!.coordinate.longitude)) {
                (success) in
                
                if !success {
                    var alertView = SCLAlertView()
                    let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300.0)
                    alertView = SCLAlertView(appearance: appearance)
                    
                    alertView.showError("Error", subTitle: "Unable to create post, please try again later")
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    return
                }
            }
            
            FireBaseHelper().uploadImage(uploadType: "pic_posts", imageData: imgData, postID: postID) {
                (success, url) in
                
                if !success {
                    var alertView = SCLAlertView()
                    let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300.0)
                    alertView = SCLAlertView(appearance: appearance)
                    
                    alertView.showError("Error", subTitle: "Unable to upload image, please try again later")
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    return
                }
                else {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    self.performSegue(withIdentifier: "postDetail", sender: self)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetail" {
            let con = segue.destination as! UINavigationController
            let des = con.topViewController as! PostDetailViewController
            
            des.postID = postID
            if postType == "exchange" {
                des.typeIndicator.setTitle("Exchange", for: .normal)
            }
            else {
                des.typeIndicator.setTitle("Buy", for: .normal)
            }
        }
    }
}

extension NewPostViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return false
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        itemImages.removeAll()
        for view in imageScrollView.subviews {
            view.removeFromSuperview()
        }
        
        for asset in assets {
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: self.view.frame.width, height: self.imageScrollView.frame.height), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                image = result!
                self.itemImages.append(image)
            })
        }
        dismiss(animated: true, completion: nil)
        
        displaySelectedImages()
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
