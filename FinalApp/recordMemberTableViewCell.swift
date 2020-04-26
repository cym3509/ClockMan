//
//  recordMemberTableViewCell.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/19.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class recordMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var dateoff: UILabel!
    @IBOutlet weak var dateover: UILabel!
    @IBOutlet weak var datecome: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var monthlabel: UILabel!
    @IBOutlet weak var dateon: UILabel!
    
     @IBOutlet weak var showrecord: RoundButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
