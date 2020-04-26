//
//  SalaryrecordTableViewCell.swift
//  FinalApp
//
//  Created by 米娜 on 2017/8/16.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class SalaryrecordTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var persum: UILabel!
    @IBOutlet weak var hourlypaid: UILabel!
    @IBOutlet weak var realhour: UILabel!
    @IBOutlet weak var choosedate: UILabel!
    @IBOutlet weak var choosemonth: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
