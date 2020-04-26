//
//  ViewController.swift
//  leave1
//
//  Created by Rachel on 2017/8/4.
//  Copyright © 2017年 Rachel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MemberDayOffViewController: UIViewController  , UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var ref: DatabaseReference!
    let namePicker = UIPickerView()
    var arrayName = [sheetName]()
    var selectedName = String()

    @IBOutlet weak var nowdate: UILabel!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var changemember: UITextField!
    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var menubutton: UIBarButtonItem!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var reason: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        label.returnKeyType = .done
        reason.returnKeyType = .done
        
        createDatePicker()
        createDatePicker1()
        load()
        
        datePicker.locale = Locale.init(identifier: "zh-Hant")
        datePicker1.locale = Locale.init(identifier: "zh-Hant")
        
        
        let date = Date()
        let cal = Calendar.current
        
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        print(month)
        
        let day = cal.component(.day, from: date)
        
        
        nowdate.text = "\(year)/\(month)/\(day)"
        pickerView.setValue(UIColor.white, forKey: "textColor")
        
        changemember.inputView = namePicker
        
        namePicker.dataSource = self
        namePicker.delegate = self
        
    }

    
    
    @IBAction func send(_ sender: Any) {
        
        if (label.text == "" || start.text == "" || end.text == "" || reason.text == "") {
            
            let alertController = UIAlertController(title: "Error", message: "請輸入完整的請假資訊", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
            
        else{
            
            let s = start.text?.components(separatedBy: "/")
            
            let splitdate = s?[2].components(separatedBy: " ")
            let sy = s?[0] //2017
            let sm = s?[1] //08
            
            let sd = splitdate?[0] //04
            let st = splitdate?[1] //12:00
            
            //////
            
            let e = end.text?.components(separatedBy: "/")
            let splitdateend = e?[2].components(separatedBy: " ")
            let ey = e?[0] //2017
            let em = e?[1] //08
            
            let ed = splitdateend?[0] //04
            let et = splitdateend?[1] //12:00
            
            
            
            let uid = Auth.auth().currentUser?.uid
            
            let messID = self.ref.child("DayOff").childByAutoId().key
            ref.child("Members").child(uid!).observeSingleEvent(of: .value , with:  { (snapshot) in
                print(snapshot)
                
                if let dataDict = snapshot.value as? [String: AnyObject]{
                    
                    let value = snapshot.value as? NSDictionary
                    let username = value?["userName"] as? String ?? ""
                    let uid = value?["uid"] as? String ?? ""
                    
                    var a = ""
                    if     self.label.text == "事假"{
                        a = "absence"
                        
                    }
                    else if self.label.text == "病假"{
                        a = "sick"
                        
                    }
                    else if self.label.text == "其他"{
                        a = "other"
                        
                    }
                    
                    
                    self.ref.child("DayOff").child(messID).setValue([
                        
                        
                        "category":a,
                        
                        
                        
                        
                        "Applyday": self.nowdate.text!,
                        "startYear": sy,
                        "startMonth": sm,
                        "startDate": sd,
                        "startTime": st,
                        "endYear":ey,
                        "endMonth":em,
                        "endDate":ed,
                        "endTime":et,
                        "sendName":username,
                        "reason":self.reason?.text!,
                        "uid":uid,
                        "audit":"nil",
                        "key": messID,
                        "changemember" : self.changemember.text!,
                        "changeaudit": "nil"
                        
                        ])
                    
                    
                    
                    
                    
                }
                
                
                
            }
            )
            
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dest = Storyboard.instantiateViewController(withIdentifier: "MemberdayoffrecordViewController2") as! MemberdayoffrecordViewController
            
            
            self.navigationController?.pushViewController(dest, animated: true)
            
            
        }
        
        
        
        
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MemberDayOffViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        changemember.inputAccessoryView = toolBar
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    
    
    let leave = ["事假", "病假" , "其他"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == namePicker{
            return arrayName[row].sheetname
        }
        else{
            return leave[row]
        }
        
        

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == namePicker{
            return arrayName.count
        }
        else{
            return leave.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        
    {
        if pickerView == namePicker{
            selectedName = arrayName[row].sheetname
            changemember.text = selectedName

        }
        
        else{
            label.text = leave[row]
        }
        
        
    }
    

    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        start?.inputAccessoryView = toolbar
        start?.inputView = datePicker
        
        
    }
    @objc func donePressed() {
        
        let  formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        
        
        
        
        start.text = formatter.string(from: datePicker.date)
        
        
        
        self.view.endEditing(true)
    }
    
    func createDatePicker1(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton1], animated: false)
        
        end.inputAccessoryView = toolbar
        end.inputView = datePicker1
        
        
    }
    
    @objc func donePressed1() {
        
        let  formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        end.text = formatter.string(from: datePicker1.date)
        
        self.view.endEditing(true)
}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
