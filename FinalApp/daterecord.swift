//
//  daterecord.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/16.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
class daterecord{
 
    var datename: String?
    var dateon: String?
    var dateoff: String?
    var imageUrl: String?
    var clockin: String?
    var clockout: String?
    
    init(nameText: String?, onString: String?, offString: String? , imageString: String?, inString: String?, outString: String?){
    
    
    datename = nameText
        dateon = onString
        dateoff = offString
   imageUrl = imageString
        clockin = inString
        clockout = outString
    
    }







}
