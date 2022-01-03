//
//  TodoCellViewControllerTableViewCell.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 24/12/21.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    

    @IBOutlet weak var cellText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
