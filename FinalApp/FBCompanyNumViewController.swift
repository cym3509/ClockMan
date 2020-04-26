//
//  FBCompanyNumViewController.swift
//  FinalApp
//
//  Created by LiangYu on 2017/8/29.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class FBCompanyNumViewController: UIViewController {

    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
       // addHourlyPaid()

        }
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var CompanyNum: UITextField!
    
    
    @IBAction func fbcompany(_ sender: UIButton) {
        
        if (CompanyNum.text == nil)||(phone.text == nil) {
            let alertController = UIAlertController(title: "Error", message: "請輸入公司統編與手機號碼", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
           
            Editorial()
            addHourlyPaid()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "memberhome")
            self.present(vc!, animated: true, completion: nil)

    
        }
        
        
        
        
        
    }
    
    
    func Editorial() {
        
        let uid = Auth.auth().currentUser?.uid
        
        
        let statusRef = Database.database().reference().child("Members").child(uid!)
        let newValue = [ "companyNum":CompanyNum.text] as [String: Any]
        let newphone = ["phone":phone.text] as [String: Any]
        
        statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
            print("Successfully set status value")
            // Update your UI
            DispatchQueue.main.async {
            // Do anything with your UIs
            }
        })
        statusRef.updateChildValues(newphone, withCompletionBlock: { (error, _) in
            print("Successfully set phone")
            // Update your UI
            DispatchQueue.main.async {
                // Do anything with your UIs
            }
        })
        

        
       
        
        
    }
    
    func addHourlyPaid(){
        
        let uid2 = Auth.auth().currentUser?.uid
        print("===========abc     ",uid2!)
        
        
        ref.child("Members").observe(.childAdded, with: {(snapshot) in
            
            if  let dic = snapshot.value as? [String: AnyObject]{
                let usernameText = dic["userName"] as? String
                let uid = dic["uid"] as? String
                
                if(uid == uid2){
                    
                    self.ref.child("HourlyPaid").child(uid!).setValue(
                        [
                            "name": usernameText,
                            "uid": uid,
                            "companyNum": self.CompanyNum.text as! String,
                            "hourlyPaid": "0"
                            
                            ])
                    
                }
                
                
                
            }
            
            
            
        })

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
