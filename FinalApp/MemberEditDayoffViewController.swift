//
//  MemberEditDayoffViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/9/21.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class MemberEditDayoffViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var applyday: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var s_year: UILabel!
    @IBOutlet weak var s_month: UILabel!
    @IBOutlet weak var s_date: UILabel!
    @IBOutlet weak var e_year: UILabel!
    @IBOutlet weak var e_month: UILabel!
    @IBOutlet weak var e_date: UILabel!
    @IBOutlet weak var reason: UITextView!
    @IBOutlet weak var s_time: UITextField!
    @IBOutlet weak var e_time: UITextField!
    
    let starttimePicker = UIDatePicker()
    let endtimePicker = UIDatePicker()

    
    
    
    var vianame = ""
    var viaapply = ""
    var viacategory = ""
    var viasyear = ""
    var viasmonth = ""
    var viasdate = ""
    var viaeyear = ""
    var viaemonth = ""
    var viaedate = ""
    var viareason = ""
    var viaEditKey = ""
    var viastime = ""
    var viaetime = ""


    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loaddata()
        
        pic.layer.cornerRadius = pic.frame.size.width/2
        pic.clipsToBounds = true
        
        createStartPicker()
        createEndPicker()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loaddata(){
        name.text = vianame
        applyday.text = viaapply
        category.text = viacategory
        s_year.text = viasyear
        s_month.text = viasmonth
        s_date.text = viasdate
        e_year.text = viasyear
        e_month.text = viasmonth
        e_date.text = viasdate
        reason.text = viareason
        s_time.text = viastime
        e_time.text = viaetime

        
        
        
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(uid!).observeSingleEvent(of: .value , with:  { (snapshot) in
            
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let pic = value?["pic"] as? String
                
                if let profileImageURL = dataDict["pic"] as? String{
                    let url = URL(string: profileImageURL)
                    if url != nil{
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if  error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async{
                                self.pic?.image = UIImage(data: data!)
                            }
                        }).resume()}
                }
                
            }
            
            
            
        })
    }
    
    func createStartPicker(){
        
        starttimePicker.datePickerMode = .time
        s_time.inputView = starttimePicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        s_time.inputAccessoryView = toolBar
        
    }
    
    func createEndPicker(){
        
        endtimePicker.datePickerMode = .time
        e_time.inputView = endtimePicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed2))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        e_time.inputAccessoryView = toolBar
        
    }
    
    func donePressed(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        s_time.text = dateFormatter.string(from: starttimePicker.date)
        
        self.view.endEditing(true)
    }
    
    func donePressed2(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        e_time.text = dateFormatter.string(from: endtimePicker.date)
        self.view.endEditing(true)
    }

    
    
    @IBAction func okBtn(_ sender: UIButton) {
        
        ref.child("DayOff").child(viaEditKey).updateChildValues(
            ["reason": reason.text,
             "startTime": s_time.text,
             "endTime": e_time.text], withCompletionBlock:{ (error, ref) in
                if error != nil{
                    print(error!)
                    return
                }
        })
        
        
    }
    
    
    
    
    
    

   
}
