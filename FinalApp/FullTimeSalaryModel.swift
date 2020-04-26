//
//  FullTimeSalaryModel.swift
//  FinalApp
//
//  Created by Hello Kitty on 2017/10/25.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation

class FullTimeSalaryModel {
    var name: String?
    var baseSalary: String?
    var uid: String?
    var companyNum: String?
    var healthInsurance: String?
    var workInsurance: String?
    
    init(nameText: String?, baseSalaryText: String?, healthInsurance: String?, workInsurance: String?, uidText: String?, companynumText: String?){
        
        name = nameText
        baseSalary = baseSalaryText
        self.healthInsurance = healthInsurance
        self.workInsurance = workInsurance
        uid = uidText
        companyNum = companynumText
        
    }

}
