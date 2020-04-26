//
//  healthWorkInsurance.swift
//  FinalApp
//
//  Created by ORLA on 2017/12/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation

class healthWorkInsurance{
    
    var name: String?
    var totalSalary: String?
    var health: String?
    var work: String?
    var retire: String?
    
    
    init(nameText: String?, totalsalaryText: String?, healthText: String?, workText: String?, retireText: String?){
        
        name = nameText
        totalSalary = totalsalaryText
        health = healthText
        work = workText
        retire = retireText
        
    }
    
}
