//
//  ReceiverTableViewCell.swift
//  WhatsUp
//
//  Created by mohamdan on 20/07/2023.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
