//
//  File.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/4.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
class User{
    var email: String?
    var username : String?
    var imageUrl : String?
    var phone : String?
    
    init(usernameText : String?, emailString : String? , imageString : String? , phoneString: String?){
        
        email = emailString
        username = usernameText
        phone = phoneString
        imageUrl = imageString
        
    }
}


