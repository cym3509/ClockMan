//
//  sheetCell.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/11.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class sheetCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var startTime: UILabel!

    @IBOutlet weak var endTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
