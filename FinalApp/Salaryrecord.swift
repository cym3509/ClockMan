//
//  Salaryrecord.swift
//  FinalApp
//
//  Created by 米娜 on 2017/8/16.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
class Salaryrecord{
    
    var date: String?
    var month : String?
    var realhour : String?
    var hourlypaid : String?
    var persum  : String?
     var holiday  : String?
    var overtime : String?
    var overtimepaid : String?
    
    init(dateText : String?, monthText : String? , realhourText : String?,hourlypaidText : String?, persumText : String?, holidaytext : String? ,overtimeText: String? , overtimepaidText: String?){
        
        date = dateText
        
        month = monthText
        
        realhour = realhourText
        
         hourlypaid =  hourlypaidText
        persum = persumText
        
        holiday = holidaytext
        overtime = overtimeText
        overtimepaid = overtimepaidText
        
        
    }
    
    
}
