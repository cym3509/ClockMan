//
//  changeTableViewCell.swift
//  FinalApp
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class changeTableViewCell: UITableViewCell {

    @IBOutlet weak var dayoffmember: UILabel!
    
    @IBOutlet weak var changestart: UILabel!
    
    @IBOutlet weak var changestarttime: UILabel!
    @IBOutlet weak var audit: UIImageView!
    
    @IBOutlet weak var changeend: UILabel!
    
    @IBOutlet weak var changeendtime: UILabel!
     var keys = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
