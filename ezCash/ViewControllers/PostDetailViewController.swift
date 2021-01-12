import UIKit
import SVProgressHUD

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var typeIndicator: UIButton!
    
    @IBOutlet weak var timeOwnedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var postID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let backButtonIcon = UIImage(systemName: "xmark", withConfiguration: config)
        backButton.tintColor = .black
        backButton.setImage(backButtonIcon, for: .normal)
        backButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        typeIndicator.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: typeIndicator)
        
        setupImageScrollView()
        loadCurrentPost()
        setupDetailsView()
    }

    func setupImageScrollView() {
        imageScrollView.backgroundColor = .systemGray5

        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        imageScrollView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    func setupDetailsView() {
        timeOwnedLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        timeOwnedLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        timeOwnedLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        descriptionTextView.isUserInteractionEnabled = false
        descriptionTextView.isScrollEnabled = false
    }
    
    func loadCurrentPost() {
        var urls = [URL]()
        var photos = [UIImageView]()
        var dataArray = [NSData]()
        
        FireBaseHelper().getPostDetails(postID: postID) {
            (postType, title, description, inReturnText, timeOwned, currentCondition, price, negotiable, deliver, latitude, longitude, images) in
            SVProgressHUD.show()
            
            for i in 0..<images.count {
                let photo = UIImageView()
                photos.append(photo)
                
                urls.append(URL(string: images[i])!)
                
                let data = NSData(contentsOf: urls[i])
                dataArray.append(data!)
                
                photos[i].image = (UIImage(data: dataArray[i] as Data))
                photos[i].contentMode = .scaleAspectFit
                photos[i].isUserInteractionEnabled = false

                photos[i].frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.imageScrollView.frame.height)

                self.imageScrollView.contentSize.width = self.imageScrollView.frame.width * CGFloat(i + 1)
                self.imageScrollView.addSubview(photos[i])
            }
            self.titleLabel.text = title
            self.descriptionTextView.text = description
            self.timeOwnedLabel.text = timeOwned
            self.typeIndicator.setTitle("add", for: .normal)
            
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backButtonTouched(_ sender: Any) {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
