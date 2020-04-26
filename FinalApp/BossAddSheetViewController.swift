//
//  BossAddSheetViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/4.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BossAddSheetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var ref: DatabaseReference!
    
    // @IBOutlet weak var picker1: UIPickerView!
    
    @IBOutlet weak var selectName: UITextField!
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var endTime: UITextField!
    
    var viaYear = ""
    var viaMonth = ""
    var viaDate = ""
    var arrayName = [sheetName]()
    var selectedName = String()
    var showDate = String()
    let namePicker = UIPickerView()
    let starttimePicker = UIDatePicker()
    let endtimePicker = UIDatePicker()
    
    @IBOutlet weak var lbStartYear: UILabel!
    @IBOutlet weak var lbStartMonth: UILabel!
    @IBOutlet weak var lbStartDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbStartYear.text = viaYear
        lbStartMonth.text = viaMonth
        lbStartDate.text = viaDate
        
        showDate = ("\(lbStartYear.text)")+("\(lbStartMonth.text)")+("\(lbStartDate.text)")
        
        
        
        selectName.inputView = namePicker
        
        
        ref = Database.database().reference()
        
        load()
        createNamePicker()
        createStartPicker()
        createEndPicker()
        
        namePicker.dataSource = self
        namePicker.delegate = self
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        
        ref.child("Members").observe(.childAdded, with: {(snapshot) in
            
            if  let dic = snapshot.value as? [String: AnyObject]{
                let usernameText = dic["userName"] as? String
                let uid = dic["uid"] as? String
                let imageUrl = dic["pic"] as? String
                let companyNum = dic["companyNum"] as? String
                
                if usernameText == self.selectedName{
                    
                    
                    let key = self.ref.child("WorkDay").childByAutoId().key
                    self.ref.child("WorkDay").child(key).setValue(
                        
                        
                        [
                            
                            "year":self.lbStartYear.text! as String,
                            "month":self.lbStartMonth.text! as String,
                            "date":self.lbStartDate.text! as String,
                            "endTime": self.endTime.text! as String,
                            "startTime": self.startTime.text! as String,
                            "name": self.selectedName,
                            "uid": uid,
                            "key": key,
                            "pic": imageUrl,
                            "clockin" : "未打卡",
                            "clockout": "未打卡",
                            "companyNum": companyNum
                            
                            
                        ])
                }
                
                
            }
            
            
            
        })
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "BossSheetViewController") as! BossSheetViewController
        dest.viaYear = lbStartYear.text!
        dest.viaMonth = lbStartMonth.text!
        dest.viaDate = lbStartDate.text!
        
        
        self.navigationController?.pushViewController(dest, animated: true)
        
        
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
                    
                    if(company == companyNum){
                
                    let sheet = sheetName(sheetText : sheetText)
                    
                    self.arrayName.append(sheet)
                    
                    self.namePicker.reloadAllComponents()
                    }
                }
            }
            )
        }
        
        })
        
        
        
    }
    
    func createNamePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(BossAddSheetViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        selectName.inputAccessoryView = toolBar
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func createStartPicker(){
        
        starttimePicker.datePickerMode = .time
        startTime.inputView = starttimePicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        startTime.inputAccessoryView = toolBar
        
    }
    
    func createEndPicker(){
        
        endtimePicker.datePickerMode = .time
        endTime.inputView = endtimePicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed2))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        endTime.inputAccessoryView = toolBar
        
    }
    
    func donePressed(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        startTime.text = dateFormatter.string(from: starttimePicker.date)
        
        self.view.endEditing(true)
    }
    
    func donePressed2(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        endTime.text = dateFormatter.string(from: endtimePicker.date)
        self.view.endEditing(true)
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
        selectedName = arrayName[row].sheetname
        selectName.text = selectedName
    }
    
    
    
}


