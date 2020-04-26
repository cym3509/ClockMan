//
//  recordDatedetailViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/20.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage






class recordDatedetailViewController: UIViewController {
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    var viadate = ""
    var viaon = ""
    var viaoff = ""
    var viain = ""
    var viaout = ""
    var vianame = ""
    
    
    
    @IBOutlet weak var detaildate: UILabel!
    
    @IBOutlet weak var detailon: UILabel!
    
    @IBOutlet weak var detailoff: UILabel!
    
    @IBOutlet weak var detailin: UILabel!
    
    @IBOutlet weak var hourlabel: UILabel!
    
    @IBOutlet weak var updatehour: UITextField!
    @IBOutlet weak var finalhour: UILabel!
    @IBOutlet weak var detailout: UILabel!
    
    
    @IBOutlet weak var detailimage: UIImageView!
    @IBOutlet weak var detailname: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        detailin.text = viain
        detailon.text = viaon
        detailoff.text = viaoff
        detailout.text = viaout
        detaildate.text = viadate //20170720
        detailname.text = vianame
        
        detailimage.layer.cornerRadius = detailimage.frame.size.width/2
        detailimage.clipsToBounds = true
        
        
        let spliton = viaon.components(separatedBy: ":")
        print(spliton[0]) //09
        print(spliton[1]) //50
        
        let splitoff = viaoff.components(separatedBy: ":")
        print(splitoff[0]) //12
        print(splitoff[1]) //55
        
        let offhour = Double(splitoff[0])
        
        let offmin = Double(splitoff[1])
        
        let onhour = Double(spliton[0])
        let onmin = Double(spliton[1])
        
        
        
        let x = ((offhour!*60 + offmin!) - (onhour!*60 + onmin!))/60
        
        
        
        
        let a = Double(x)  //3.5
        
        let b = Int(x)     //3
        let c = Double(b)  //3.0
        var new : Double?
        let temp = Double(a - c)
        
        if (temp != 0 && temp <= 0.5){
            new = Double(c + 0.5)
            finalhour.text = "\(new!)"
            
            
        }
            
            
        else if (temp != 0 && temp > 0.5){
            
            new = Double(c + 1.0)
            finalhour.text = "\(new!)"
            
            
        }
        else if (temp == 0){
            
            new = Double(c)
            
            finalhour.text = "\(new!)"
            
            
            
            
            
        }
        
        
        
        ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let usernameText = dic["name"] as? String
                //let urlString = dic["pic"] as? String ?? ""
                let uid = dic["uid"] as? String ?? ""
                
                
                self.ref.child("Members").observe(.childAdded, with: { (snapshot) in
                    
                    if let dic2 = snapshot.value as? [String: AnyObject]{
                        let username = dic2["userName"] as? String
                        
                        let uid2 = dic2["uid"] as? String ?? ""
                        
                        if usernameText == self.vianame  && uid == uid2 {
                            
                            
                            
                            
                            if let profileImageURL = dic["pic"] as? String{
                                
                                let url = URL(string: profileImageURL)
                                
                                if url != nil{
                                    
                                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                        if  error != nil{
                                            print(error!)
                                            return
                                        }
                                        DispatchQueue.main.async{
                                            self.detailimage?.image = UIImage(data: data!)
                                        }
                                    }).resume()}
                            }
                            

                            
                            
                        }
                    }
                })
                
                
                
                
                
                
                
            }
        })
        
        
        
        
        
        
        
        
        
        ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let usernameText = dic["name"] as? String
                let year = dic["year"] as? String
                let month = dic["month"] as? String ?? ""
                let date = dic["date"] as? String ?? ""
                let uid = dic["uid"] as? String ?? ""
                print(uid)
                
                self.ref.child("Clock").child(uid).child(year!).child(month).child(date).observeSingleEvent(of: .value , with:  { (snapshot) in
                    if let dic2 = snapshot.value as? [String: AnyObject]{
                        let uid2 = dic2["uid"] as? String
                        let clockDate = dic2["clockDate"] as? String
                        let splitclockdate = clockDate?.components(separatedBy: "/")

                        
                        
                        let splitdate = self.viadate.components(separatedBy: "/")
                        
                        
                        if usernameText == self.vianame  && uid == uid2 && splitdate[0] == year && splitdate[1] == month && splitdate[2] == date && splitclockdate?[2] == date {
                            
                            
                            
                            self.ref.child("Realhourtime").child(uid).child(year!).child(month).child(date).observeSingleEvent(of: .value , with:  { (snapshot) in
                                
                                
                                if let dic = snapshot.value as? [String: AnyObject]{
                                    let usernameText = dic["name"] as? String
                                    let realhour = dic["realhour"] as? String
                                    
                                    
                                    self.updatehour.text = realhour
                                    
                                    
                                    if realhour != "??"{
                                        
                                        
                                        self.hourlabel.text = "時數已審核！"
                                        self.hourlabel.textColor = UIColor.white
                                    }
                                    
                                    
                                }
                            })
                            
                        }
                    }
                })
            }
        })
        
        
        
    }
    
    
    
    @IBAction func updatebutton(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: vianame, message:"Give new values to update work hour", preferredStyle:.alert)
        
        
        
        let updateAction = UIAlertAction(title: "確認", style:.default){(_) in
            let hour = alertController.textFields?[0].text
            
            /////
            
            
            /*
             self.ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
             
             if let dic = snapshot.value as? [String: AnyObject]{
             let usernameText = dic["name"] as? String
             let year = dic["year"] as? String
             let month = dic["month"] as? String ?? ""
             let date = dic["date"] as? String ?? ""
             let uid = dic["uid"] as? String ?? ""
             
             //
             
             self.ref.child("testclock").observe(.childAdded, with: { (snapshot) in
             
             if let dic2 = snapshot.value as? [String: AnyObject]{
             let uid2 = dic2["uid"] as? String
             let clockyear = dic2["year"] as? String
             let clockmonth = dic2["month"] as? String
             let clockdate = dic2["date"] as? String
             
             
             
             //
             
             self.ref.child("HourlyPaid").observe(.childAdded, with: { (snapshot) in
             
             if let dic3 = snapshot.value as? [String: AnyObject]{
             let uid3 = dic3["uid"] as? String
             let hourlypaid = dic3["hourlyPaid"] as? String
             
             let splitdate = self.viadate.components(separatedBy: "/")
             //   print(splitdate[0]) //2017
             // print(splitdate[1]) //07
             //print(splitdate[2])
             
             //
             
             
             
             
             
             
             if uid == uid3 && usernameText == self.vianame  && uid == uid2 && splitdate[0] == year && splitdate[1] == month && splitdate[2] == date {
             
             //
             
             
             
             
             
             self.ref.child("Realhourtime").child(uid).child(year!).child(month).child(date).setValue(
             
             
             [
             "name": usernameText,
             "uid": uid,
             "year": year,
             "month": month,
             "date": date,
             
             "hourlyPaid": hourlypaid,
             "realhour":  hour
             
             
             
             ]
             
             
             )
             
             
             
             
             
             
             
             //
             
             }
             //
             
             
             
             
             }
             //
             
             
             
             
             
             })
             //
             
             
             
             }
             //
             
             
             
             
             })
             
             //
             }
             
             
             //
             
             }) */
            
            
            
            
            self.ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String: AnyObject]{
                    let usernameText = dic["name"] as? String
                    let year = dic["year"] as? String
                    let month = dic["month"] as? String ?? ""
                    let date = dic["date"] as? String ?? ""
                    let uid = dic["uid"] as? String ?? ""
                    
                    //
                    
                    self.ref.child("Clock").child(uid).child(year!).child(month).child(date).observeSingleEvent(of: .value , with:  { (snapshot) in                        
                        if let dic2 = snapshot.value as? [String: AnyObject]{
                            let uid2 = dic2["uid"] as? String
                            let clockDate = dic2["clockDate"] as? String
                            let splitclockdate = clockDate?.components(separatedBy: "/")
                            
                            let splitdate = self.viadate.components(separatedBy: "/")
                            
                            
                            
                            
                            if  usernameText == self.vianame  && uid == uid2 && splitdate[0] == year && splitdate[1] == month && splitdate[2] == date {
                                
                                
                                let statusRef = Database.database().reference().child("Realhourtime").child(uid).child(year!).child(month).child(date)
                                let newValue = [
                                    "realhour": hour
                                    
                                ]
                                
                                statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                                    
                                    if error != nil{
                                        print(error?.localizedDescription ?? "Failed to set status value")
                                    }
                                    print("Successful")
                                    
                                    DispatchQueue.main.async{
                                        
                                    }
                                    
                                    
                                })
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    })
                    
                    
                }
                
                
                
                
            })
            
            
            
            
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dest = Storyboard.instantiateViewController(withIdentifier: "recordDatedetailViewController") as! recordDatedetailViewController
            dest.viain = self.detailin.text!
            dest.viaon = self.detailon.text!
            dest.viaoff = self.detailoff.text!
            dest.viaout = self.detailout.text!
            dest.viadate = self.detaildate.text!
            dest.vianame = self.detailname.text!
            self.navigationController?.pushViewController(dest, animated: true)
            
            
            //
            
            
            
            
            
            
        }
        
        
        
        let closAction = UIAlertAction(title: "關閉", style: .cancel, handler: {
            action in print("close")
            
            
        })
        
        
        
        alertController.addTextField{(textField) in
            
            
            if self.updatehour.text == "??" || self.updatehour.text == nil {
                textField.text =  self.finalhour.text}
            else {textField.text =  self.updatehour.text}
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(closAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backrecord"{
            if let dest = segue.destination as? recordDateViewController{
                
                dest.viaDate = detaildate.text!
                
            }
        }
    }
    
    
    
}
