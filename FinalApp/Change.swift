//
//  Change.swift
//  FinalApp
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
class Change{
    var changestart: String?
    var dayoffname : String?
    var changestarttime: String?
    var changeend : String?
    var changeendtime : String?
    var changeaudit : String?
    var key : String?
    
    init(dayoffnameText : String?, changestartString : String? , changestarttimeString : String? ,changeendString: String?, changeendtimeString: String?, changeauditText : String?, keyText : String?){
        
        changestart = changestartString
        dayoffname = dayoffnameText
       changestarttime = changestarttimeString
         changeend = changeendString
         changeendtime = changeendtimeString
        changeaudit = changeauditText
        
        key = keyText
    }
}
