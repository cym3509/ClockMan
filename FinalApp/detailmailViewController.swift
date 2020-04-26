//
//  detailmailViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class detailmailViewController: UIViewController {
    var ref: DatabaseReference!
    
    let storageRef = Storage.storage().reference()
    var vianame = ""
  
    var viakey = ""
    

    @IBOutlet weak var labelname: UILabel!
    
    @IBOutlet weak var changename: UILabel!
    @IBOutlet weak var labelapply: UILabel!
    
    @IBOutlet weak var labelcate: UILabel!
    
    @IBOutlet weak var startyear: UILabel!
    @IBOutlet weak var enddate: UILabel!
    
    @IBOutlet weak var startmonth: UILabel!
    @IBOutlet weak var endmonth: UILabel!
    
 
    @IBOutlet weak var endyear: UILabel!
    @IBOutlet weak var dayoffimage: UIImageView!
    
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var startdate: UILabel!
    
    @IBAction func acceptt(_ sender: RoundButton) {
        
        ref.child("DayOff").child(viakey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let audit1 = dic["audit"] as? String
                
                if audit1 == "yes"{
                    let alreadyAudit = UIAlertController(title: "已審核", message: "此假單已審核" ,preferredStyle: .alert)
                    let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler: {
                        action in print("close")
                        
                        
                    })
                    alreadyAudit.addAction(closeAction)
                    self.present(alreadyAudit, animated: true, completion: nil)

                }
                
                else{
                    let alertActionSheet = UIAlertController(title: "審核", message: nil ,preferredStyle: .actionSheet)
                    
                    let yesAction = UIAlertAction(title: "核准", style: .default, handler: {
                        action in print("yes")
                        
                        
                        
                        self.ref.child("DayOff").child(self.viakey).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            if let dic = snapshot.value as? [String: AnyObject]{
                                let applyday = dic["Applyday"] as? String
                                let dayoffs = dic["startTime"] as? String
                                let dayoffe = dic["endTime"] as? String
                                let dayoffy = dic["startYear"] as? String
                                let dayoffm = dic["startMonth"] as? String
                                let dayoffd = dic["startDate"] as? String
                                let dayoffuid = dic["uid"] as? String
                                let audit = dic["audit"] as? String
                                let datoffuid = dic["uid"] as? String
                                let changeName = dic["changemember"] as? String
                                let sendName = dic["sendName"] as? String
                                
                                
                                self.ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
                                    if let dic = snapshot.value as? [String: AnyObject]{
                                        let nameText = dic["name"] as? String
                                        let onString = dic["startTime"] as? String
                                        let offString = dic["endTime"] as? String
                                        let chooseyear = dic["year"] as? String
                                        let choosemonth = dic["month"] as? String
                                        let choosedate = dic["date"] as? String
                                        let imageString = dic["pic"] as? String
                                        let inString = dic["clockin"] as? String
                                        let uid = dic["uid"] as? String
                                        let outString = dic["clockout"] as? String
                                        let keyw = dic["key"] as? String
                                        let category = dic["category"] as? String
                                        
                                        
                                        self.ref.child("Members").observe(.childAdded, with: {(snapshot) in
                                            
                                            if let dic = snapshot.value as? [String: AnyObject]{
                                                let memberName = dic["userName"] as? String
                                                let companyNum = dic["companyNum"] as? String
                                                let pic = dic["pic"] as? String
                                                let uid = dic["uid"] as? String
                                                
                                                
                                                
                                                
                                                
                                                if (dayoffy == chooseyear && dayoffm == choosemonth && dayoffd == choosedate && sendName == nameText && dayoffs == onString && dayoffe != offString){
                                                    
                                                    
                                                    let statusRef = Database.database().reference().child("DayOff").child(self.viakey)
                                                    let newValue = ["audit": "yes"] as [String: Any]
                                                    
                                                    statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    let statusRef2 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue2 = ["clockin": "請假"] as [String: Any]
                                                    
                                                    statusRef2.updateChildValues(newValue2, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    let statusRef3 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue3 = ["clockout": "請假"] as [String: Any]
                                                    
                                                    statusRef3.updateChildValues(newValue3, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    let statusRef4 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue4 = ["category": "dayoff"] as [String: Any]
                                                    
                                                    statusRef4.updateChildValues(newValue4, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    if(changeName == memberName){
                                                        
                                                        let key2 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key2).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": dayoffe,
                                                                "startTime": dayoffs,
                                                                "name": changeName,
                                                                "uid": uid,
                                                                "key": key2,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                    }
                                                    
                                                    if(sendName == memberName){
                                                        
                                                        let key3 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key3).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": offString,
                                                                "startTime": dayoffe,
                                                                "name": sendName,
                                                                "uid": uid,
                                                                "key": key3,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                    
                                                else if (dayoffy == chooseyear && dayoffm == choosemonth && dayoffd == choosedate && sendName == nameText && dayoffs != onString && dayoffe == offString){
                                                    
                                                    
                                                    let statusRef = Database.database().reference().child("DayOff").child(self.viakey)
                                                    let newValue = ["audit": "yes"] as [String: Any]
                                                    
                                                    statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    let statusRef2 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue2 = ["clockin": "請假"] as [String: Any]
                                                    
                                                    statusRef2.updateChildValues(newValue2, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    let statusRef3 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue3 = ["clockout": "請假"] as [String: Any]
                                                    
                                                    statusRef3.updateChildValues(newValue3, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    let statusRef4 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue4 = ["category": "dayoff"] as [String: Any]
                                                    
                                                    statusRef4.updateChildValues(newValue4, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    if(changeName == memberName){
                                                        
                                                        let key2 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key2).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": dayoffe,
                                                                "startTime": dayoffs,
                                                                "name": changeName,
                                                                "uid": uid,
                                                                "key": key2,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                    }
                                                    
                                                    if(sendName == memberName){
                                                        
                                                        let key3 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key3).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": dayoffs,
                                                                "startTime": onString,
                                                                "name": sendName,
                                                                "uid": uid,
                                                                "key": key3,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                    
                                                else if (dayoffy == chooseyear && dayoffm == choosemonth && dayoffd == choosedate && sendName == nameText && dayoffs == onString && dayoffe == offString){
                                                    
                                                    
                                                    let statusRef = Database.database().reference().child("DayOff").child(self.viakey)
                                                    let newValue = ["audit": "yes"] as [String: Any]
                                                    
                                                    statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    let statusRef2 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue2 = ["clockin": "請假"] as [String: Any]
                                                    
                                                    statusRef2.updateChildValues(newValue2, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    let statusRef3 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue3 = ["clockout": "請假"] as [String: Any]
                                                    
                                                    statusRef3.updateChildValues(newValue3, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    let statusRef4 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue4 = ["category": "dayoff"] as [String: Any]
                                                    
                                                    statusRef4.updateChildValues(newValue4, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    if(changeName == memberName){
                                                        
                                                        let key2 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key2).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": dayoffe,
                                                                "startTime": dayoffs,
                                                                "name": changeName,
                                                                "uid": uid,
                                                                "key": key2,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                                    
                                                else if (dayoffy == chooseyear && dayoffm == choosemonth && dayoffd == choosedate && sendName == nameText && dayoffs != onString && dayoffe != offString && category != "change"){
                                                    
                                                    
                                                    let statusRef = Database.database().reference().child("DayOff").child(self.viakey)
                                                    let newValue = ["audit": "yes"] as [String: Any]
                                                    
                                                    statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    let statusRef2 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue2 = ["clockin": "請假"] as [String: Any]
                                                    
                                                    statusRef2.updateChildValues(newValue2, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    let statusRef3 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue3 = ["clockout": "請假"] as [String: Any]
                                                    
                                                    statusRef3.updateChildValues(newValue3, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    let statusRef4 = Database.database().reference().child("WorkDay").child(keyw!)
                                                    let newValue4 = ["category": "dayoff"] as [String: Any]
                                                    
                                                    statusRef4.updateChildValues(newValue4, withCompletionBlock: { (error, _) in
                                                        
                                                        
                                                        
                                                        
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "Failed to set status value")
                                                        }
                                                        print("Successfully set status value")
                                                        // Update your UI
                                                        DispatchQueue.main.async {
                                                            // Do anything with your UI
                                                        }
                                                        
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    if(changeName == memberName){
                                                        
                                                        let key2 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key2).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": dayoffe,
                                                                "startTime": dayoffs,
                                                                "name": changeName,
                                                                "uid": uid,
                                                                "key": key2,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                    }
                                                    
                                                    if(sendName == memberName){
                                                        
                                                        let key3 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key3).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": dayoffs,
                                                                "startTime": onString,
                                                                "name": sendName,
                                                                "uid": uid,
                                                                "key": key3,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                        
                                                        
                                                        let key4 = self.ref.child("WorkDay").childByAutoId().key
                                                        self.ref.child("WorkDay").child(key4).setValue(
                                                            
                                                            
                                                            [
                                                                "category": "change",
                                                                "year": dayoffy,
                                                                "month": dayoffm,
                                                                "date": dayoffd,
                                                                "endTime": offString,
                                                                "startTime": dayoffe,
                                                                "name": sendName,
                                                                "uid": uid,
                                                                "key": key4,
                                                                "pic": pic,
                                                                "clockin" : "未打卡",
                                                                "clockout": "未打卡",
                                                                "companyNum": companyNum
                                                                
                                                                
                                                            ])
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                            }})
                                        
                                        
                                    }})
                                
                                
                            }})
                        
                        
                        
                        
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let dest = Storyboard.instantiateViewController(withIdentifier: "detailmailViewController") as! detailmailViewController
                        dest.vianame = self.labelname.text!
                        dest.viakey = self.viakey
                        
                        self.navigationController?.pushViewController(dest, animated: true)
                        
                        
                    })
                    
                    
                    
                    let noAction = UIAlertAction(title: "否決", style: .destructive, handler: {
                        action in print("no")
                        
                        
                        self.ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
                            
                            if let dic = snapshot.value as? [String: AnyObject]{
                                let usernameText = dic["sendName"] as? String
                                let applyday = dic["Applyday"] as? String
                                let key = dic["key"] as? String
                                
                                
                                
                                if usernameText == self.vianame && key == self.viakey{
                                    
                                    
                                    
                                    //  let senderKey = key
                                    let statusRef = Database.database().reference().child("DayOff").child(key!)
                                    let newValue = ["audit": "no"] as [String: Any]
                                    
                                    statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                                        
                                        
                                        
                                        
                                        if error != nil {
                                            print(error?.localizedDescription ?? "Failed to set status value")
                                        }
                                        print("Successfully set status value")
                                        // Update your UI
                                        DispatchQueue.main.async {
                                            // Do anything with your UI
                                        }
                                        
                                        
                                        
                                    })
                                    
                                    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let dest = Storyboard.instantiateViewController(withIdentifier: "detailmailViewController") as! detailmailViewController
                                    dest.vianame = self.labelname.text!
                                    dest.viakey = self.viakey
                                    
                                    
                                    self.navigationController?.pushViewController(dest, animated: true)
                                    
                                }
                                
                                
                                
                                
                            }
                        })
                        
                        
                        
                        
                        
                        
                    })
                    let closAction = UIAlertAction(title: "關閉", style: .cancel, handler: {
                        action in print("close")
                        
                        
                    })
                    
                    
                    
                    alertActionSheet.addAction(yesAction)
                    alertActionSheet.addAction(noAction)
                    alertActionSheet.addAction(closAction)
                    
                    self.present(alertActionSheet, animated: true, completion: nil)
                }

            }
            


        })
        
        
        
        

      
    }
 
  

    
    
    @IBOutlet weak var labelalarm: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
                dayoffimage.layer.cornerRadius = dayoffimage.frame.size.width/2
        dayoffimage.clipsToBounds = true
        labelname.text = vianame
        //labelapply.text = viaapply
        print("qqqqqqqqq" , viakey)
         ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
          
            if let dic = snapshot.value as? [String: AnyObject]{
            let usernameText = dic["sendName"] as? String
                let applyday = dic["Applyday"] as? String
                let category = dic["category"] as? String
                let startyear = dic["startYear"] as? String
                let startmonth = dic["startMonth"] as? String
                let startdate = dic["startDate"] as? String
                let starttime = dic["startTime"] as? String
                let endyear = dic["endYear"] as? String
                let endmonth = dic["endMonth"] as? String
                let enddate = dic["endDate"] as? String
                let endtime = dic["endTime"] as? String
                let uid = dic["uid"] as? String
                let key = dic["key"] as? String
                let audit = dic["audit"] as? String
                let reason = dic["reason"] as? String
                let changeaudit = dic["changeaudit"] as? String
                let changemember = dic["changemember"] as? String
                self.labelapply.text = applyday

                if usernameText == self.vianame && key == self.viakey && (changeaudit == "yes"){
                
                    
                    
                    if audit == "yes"{
                    self.labelalarm.text = "此假單已核准！"
                        self.labelalarm.textColor = UIColor.white
                    } else if audit == "no"{
                        self.labelalarm.text = "此假單已否決！"
                        self.labelalarm.textColor = UIColor.red
                        
                    }
                    
                    
                    if category == "sick"{
                       self.labelcate.text = "病假"
                        
                    }
                    else if category == "absence"{
                        self.labelcate.text = "事假"
                        
                    }
                    else if category == "other"{
                       self.labelcate.text = "其他"
                        
                    }
                                        
                    self.startyear.text = startyear
                    self.startmonth.text = startmonth
                    self.startdate.text = startdate
                    self.starttime.text = starttime
                    self.endyear.text = endyear
                    self.endmonth.text = endmonth
                    self.enddate.text = enddate
                    self.endtime.text = endtime
                    self.reason.text = reason
                    self.changename.text = changemember
                
                    let statusRef = Database.database().reference().child("Members").child(uid!)
                    statusRef.observeSingleEvent(of: .value , with:  { (snapshot) in

                      
                        print(snapshot)
                        
                        if let dataDict = snapshot.value as? [String: AnyObject]{
                            
                            let value = snapshot.value as? NSDictionary
                            let username = value?["userName"] as? String ?? ""
                        
                        print(username)
                            if let profileImageURL = dataDict["pic"] as? String{
                                let url = URL(string: profileImageURL)
                                if url != nil{
                                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                    if  error != nil{
                                        print(error!)
                                        return
                                    }
                                    DispatchQueue.main.async{
                                        self.dayoffimage?.image = UIImage(data: data!)
                                    }
                                }).resume()
                            }
                            }
                        
                        }
                        
                    })
                    
                    
                
                }
                                /*   self.ref.child("Members").observe(.childAdded, with: { (snapshot) in
                    
                    if let dic2 = snapshot.value as? [String: AnyObject]{
                        
                       
                        let useruid = dic2["uid"] as? String
                        
                        let pic = dic2["pic"] as? String
                        
                        
                        if useruid == uid {
                        
                        
                            if let profileImageURL = dic2["pic"] as? String{
                                let url = URL(string: profileImageURL)
                                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                    if  error != nil{
                                        print(error!)
                                        return
                                    }
                                    DispatchQueue.main.async{
                                        self.dayoffimage?.image = UIImage(data: data!)
                                    }
                                }).resume()
                            }

                        
                        
                        
                        }
                        
                        
                        
                        
                    }
                    
                })
                */
            
            
            
            }
            
         } )
        
     
        
        
        
       
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
