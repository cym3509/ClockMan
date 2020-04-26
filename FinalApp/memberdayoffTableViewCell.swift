//
//  memberdayoffTableViewCell.swift
//  FinalApp
//
//  Created by 米娜 on 2017/8/7.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class memberdayoffTableViewCell: UITableViewCell {

    
    @IBOutlet weak var monthchoose: UILabel!
     @IBOutlet weak var datechoose: UILabel!
       
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var audit: RoundButton!
    
    @IBOutlet weak var detailsButton: UIButton!
    
       
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
