//
//  recordmonthViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/25.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class recordmonthViewController: UIViewController, UITextFieldDelegate {
    
    var name = ""
    
    @IBOutlet weak var selectmonth: UITextField!
    @IBOutlet weak var selectyear: UITextField!
    @IBOutlet weak var nametext: UILabel!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        selectyear.returnKeyType = .done
        selectmonth.returnKeyType = .done
        
        nametext.text = name
        let date = Date()
        let cal = Calendar.current
        
        let year = cal.component(.year, from: date)
         let month = cal.component(.month, from: date)
        
        
        if ("\(month)") == "11" || ("\(month)") == "12" || ("\(month)") == "10" {
        selectmonth.text = ("\(month)")
        
        }else{ selectmonth.text = "0" + ("\(month)")}
    selectyear.text = ("\(year)")
        
       
        
     /*   let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
           
        }*/
        
        
        // Do any additional setup after loading the view.
    
       }
    
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
           // datename.text = formatter.string(from: datepicker.date)
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "record"{
            if let dest = segue.destination as? recordMemberViewController{
                
                dest.name = nametext.text!
                dest.month = (selectyear.text! + "/" + selectmonth.text!)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

}


