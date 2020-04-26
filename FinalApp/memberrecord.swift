//
//  memberrecord.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/24.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
class memberrecord{
    
    var membername: String?
    var dateon: String?
    var dateoff: String?
    
    var month: String?
    var date: String?
    var clockin: String?
    var clockout: String?
    
    var uid: String?
    
    init(nameText: String?, onString: String?, offString: String? , monthString: String?, dateString: String? , inString: String?, outString: String?, uidText: String?){
        
        
        membername = nameText
        dateon = onString
        dateoff = offString
        clockin = inString
        clockout = outString
        month = monthString
        date = dateString
        uid = uidText
    }
    
    
    
    
    
    
    
}
