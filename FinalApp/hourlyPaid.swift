//
//  hourlyPaid.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/19.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation

class hourlyPaid{
    
    var name: String?
    var paid: String?
    var uid: String?
    var companyNum: String?
    
    init(nameText: String?, paidText: String?, uidText: String?, companynumText: String?){
        
        name = nameText
        paid = paidText
        uid = uidText
        companyNum = companynumText
        
    }
}
