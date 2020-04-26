//
//  healthCell.swift
//  FinalApp
//
//  Created by ORLA on 2017/12/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class healthCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var salary: UILabel!
    
    @IBOutlet weak var health: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
