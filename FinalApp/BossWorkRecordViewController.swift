//
//  BossWorkRecordViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/6/7.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BossWorkRecordViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var ref: DatabaseReference!
    var viaDate = ""
    var car = ["asd", "sswe", "trsgrthy"]
    var arrayName = [sheetName]()
    @IBOutlet weak var pickerView: UIPickerView!
   var selectedname = String()
    @IBOutlet weak var datename: UITextField!
    @IBOutlet weak var membername: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
  
        }
        datepicker.setValue(UIColor.white, forKey: "textColor")
        pickerView.setValue(UIColor.white, forKey: "textColor")
        //datepicker.performSelector(inBackground: "HighlightsToday:", with:UIColor.red)
        
        pickerView.delegate = self
        pickerView.dataSource = self
       
        let  formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        
        datename.text = formatter.string(from: datepicker.date)


        
        ref = Database.database().reference()
        load()
    }
    
    func load(){
        
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("Members").observe(.childAdded, with: { snapshot in
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let sheetText = dic["userName"] as! String
                        let company = dic["companyNum"] as! String
                        
                        if (company == companyNum){
                        
                        let sheet = sheetName(sheetText : sheetText)
                        self.arrayName.append(sheet)
                        self.pickerView.reloadAllComponents()
                        
                        }
                    }
                }
                )
            }
        })
        
        

        
    }
  
    
    @IBAction func dateSelectedFromDatePicker(_ : AnyObject){
    
        let  formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        
        datename.text = formatter.string(from: datepicker.date)
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayName[row].sheetname
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayName.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // selectedname = car[row]
         membername.text = arrayName[row].sheetname
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showdate"{
            if let dest = segue.destination as? recordDateViewController{
                
                dest.viaDate = datename.text!
                
            }
        }
        
        
        
        if segue.identifier == "choosemonth"{
            if let dest2 = segue.destination as? recordmonthViewController{
                
                dest2.name = membername.text!
                
               
            }
        }
        
        
    }
    
    
    
}

