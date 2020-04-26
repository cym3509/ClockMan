//
//  collection.swift
//  FinalApp
//
//  Created by ORLA on 2017/8/1.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
class collection{
   
    var username : String?
    var imageUrl : String?
    var clockin : String?
    var starttime: String?
    var endtime: String?
    var key: String?
    
    init(usernameText : String?, imageString : String?, clockinText: String?, starttimeText: String?, endtimeText: String?, keyText: String?){
        
        username = usernameText
        imageUrl = imageString
        clockin = clockinText
        starttime = starttimeText
        endtime = endtimeText
        key = keyText
    
    }
}
