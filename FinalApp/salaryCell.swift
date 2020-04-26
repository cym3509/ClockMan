//
//  SalaryCell.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/23.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class salaryCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var totalSalary: UILabel!

    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
