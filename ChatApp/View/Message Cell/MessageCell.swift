//
//  MessageCell.swift
//  ChatApp
//
//  Created by admin on 07/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageImageVew: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.messageBackground.layer.cornerRadius = 5.0
        self.messageBackground.layer.borderWidth = 1.0
        self.messageBackground.layer.borderColor = UIColor.red.cgColor
        
        //self.messageBackground.layer.borderColor = UIColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
