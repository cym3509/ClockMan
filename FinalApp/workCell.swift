//
//  workCell.swift
//  FinalApp
//
//  Created by ORLA on 2017/12/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class workCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var totalSalary: UILabel!
    @IBOutlet weak var workInsurance: UILabel!
    @IBOutlet weak var retire: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
