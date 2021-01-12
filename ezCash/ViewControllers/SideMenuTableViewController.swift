import UIKit
import Firebase
import SVProgressHUD

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            dismiss(animated: true, completion: nil)
            FireBaseHelper().signOut()
        presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "editView", sender: self)
        }
    }

    @IBAction func backButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
