//
//  recorddateTableViewCell.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/16.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class recorddateTableViewCell: UITableViewCell {

    @IBOutlet weak var datecome: UILabel!
    @IBOutlet weak var dateover: UILabel!
    @IBOutlet weak var dateoff: UILabel!
    @IBOutlet weak var dateon: UILabel!
    @IBOutlet weak var datename: UILabel!
    @IBOutlet weak var dateimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
