//
//  sclockinViewController.swift
//  FinalApp
//
//  Created by LiangYu on 2017/7/20.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class sclockinViewController: UIViewController {
    
    @IBOutlet weak var clockintime: UILabel!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser?.uid
    }
    
        
        
//        ref.child("Clock").child(uid!).observeSingleEvent(of: .value , with:  { (snapshot) in
//            print(snapshot)
//            
//            if let dataDict = snapshot.value as? [String: AnyObject]{
//                
//                let value = snapshot.value as? NSDictionary
//                let username = value?["userName"] as? String ?? ""
//                let companynum = value?["companyNum"] as? String ?? ""
//                let email = value?["email"] as? String ?? ""
//                let role = value?["role"] as? String ?? ""
//                let pic = value?["pic"] as? String ?? ""
//        
//                
//                
//            }
//        })
//    }
//    
//                self.profilename.text = username
//                self.profilecompanynum.text = companynum
//                self.profileemail.text = email


        

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
         }
    
    

  }

