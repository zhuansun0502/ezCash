import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageSnap: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var itemType: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
