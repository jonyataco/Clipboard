//
//  ClipCell.swift
//  Clipboard
//
//  Created by Jonathan Yataco  on 5/24/20.
//  Copyright © 2020 JonYataco. All rights reserved.
//

import UIKit

class ClipCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var faviconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
