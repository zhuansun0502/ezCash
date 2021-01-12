import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    @objc func backToMap() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupNavigationBar() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let backButtonIcon = UIImage(systemName: "xmark", withConfiguration: config)

        backButton.tintColor = .black
        backButton.setImage(backButtonIcon, for: .normal)
        backButton.sizeToFit()
        
        navigationItem.title = "Nearby Postings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @IBAction func backButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "Hello"

        return cell
    }
}
