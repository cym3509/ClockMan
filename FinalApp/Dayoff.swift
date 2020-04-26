//
//  Dayoff.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
class Dayoff{
 
    var dstart: String?
    var dayoffname : String?
    var dstarttime: String?
    var dend : String?
    var dendtime : String?
    var audit : String?
    var key : String?
    
    init(dayoffnameText : String?, dstartString : String? , dstarttimeString : String? ,dendString: String?, dendtimeString: String?, auditText : String?, keyText : String?){
        
       dstart = dstartString
        dayoffname = dayoffnameText
        dstarttime = dstarttimeString
        dend = dendString
       dendtime = dendtimeString
     audit = auditText
        
        key = keyText
    }


}
