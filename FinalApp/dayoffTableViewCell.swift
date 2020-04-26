//
//  dayoffTableViewCell.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class dayoffTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dayoffmember: UILabel!
    
    @IBOutlet weak var dstart: UILabel!
    
    @IBOutlet weak var dstarttime: UILabel!
    @IBOutlet weak var audit: UIImageView!
    
    @IBOutlet weak var dend: UILabel!
    
    @IBOutlet weak var dendtime: UILabel!
    
    
    
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
