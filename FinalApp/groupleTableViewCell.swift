//
//  groupleTableViewCell.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/5.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

/*protocol popDelegate {
    func popView ()
}*/

class groupleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var emaillabel: UILabel!
    
   // var delegate: popDelegate?
    
    @IBOutlet weak var phonelabel: UILabel!
  
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
