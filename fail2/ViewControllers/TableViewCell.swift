//
//  TableViewCell.swift
//  fail2
//
//  Created by Guillaume Malo on 2018-07-20.
//  Copyright © 2018 Guillaume Malo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
