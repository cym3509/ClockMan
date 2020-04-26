//
//  showSheet.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/12.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation

class showSheet{
    
    var name: String?
    var startTime: String?
    var endTime: String?
    var uid: String?
    var year: String?
    var month: String?
    var date: String?
    var key: String?
    var category: String?
    
    init(nameText: String?, starttimeText: String?, endtimeText: String?, uidText: String?, yearText: String?,monthText: String?, dateText: String?, keyText: String?, categoryText: String?){
        
        name = nameText
        startTime = starttimeText
        endTime = endtimeText
        uid = uidText
        year = yearText
        month = monthText
        date = dateText
        key = keyText
        category = categoryText
        
    }
}
