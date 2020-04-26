//
//  BossSalaryViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/19.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class BossSalaryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectyear: UITextField!
    @IBOutlet weak var selectmonth: UITextField!
    @IBOutlet weak var btnSetPT: RoundButton!
    @IBOutlet weak var btnSetFT: RoundButton!
    
    let year = ["2017", "2018", "2019"]
    let month = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var selectYear = ""
    var selectMonth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let date = Date()
        let cal = Calendar.current
        
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        
        
        if ("\(month)") == "11" || ("\(month)") == "12" || ("\(month)") == "10" {
            selectmonth.text = ("\(month)")
            
        }else{ selectmonth.text = "0" + ("\(month)")}
        selectyear.text = ("\(year)")
        
       //pickerView.setValue(UIColor.white, forKey: "textColor")
        

        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        switch component {
        case 0:
            attributedString = NSAttributedString(string: year[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        case 1:
            attributedString = NSAttributedString(string: month[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        default:
            attributedString = nil
        }
        
        return attributedString
    }

    
    @IBAction func searchButton(_ sender: UIButton) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "BossShowSalaryViewController") as! BossShowSalaryViewController
        dest.viaYear = selectyear.text!
        dest.viaMonth = selectmonth.text!
        
        
        self.navigationController?.pushViewController(dest, animated: true)
        
        

    }
    
    @IBAction func searchFT(_ sender: Any) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "BossShowSalaryFTViewController") as! BossShowSalaryFTViewController
        dest.viaYear = selectyear.text!
        dest.viaMonth = selectmonth.text!
        
        
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return year.count
        }
        
        return month.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return year[row]
        }
        
        return month[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            selectYear = year[row]
            selectyear.text = year[row]
            
        }
        
        else{
            selectMonth = month[row]
            selectmonth.text = month[row]
        }
        
    }
    
    
    @IBAction func clickSetPT(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BossSalarySettingViewController") as! BossSalarySettingViewController
        vc.mode = .PT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func clickSetFT(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BossSalarySettingViewController") as! BossSalarySettingViewController
        vc.mode = .FT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchWorkInsuranceBtn(_ sender: Any) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "totalHealthInsuranceViewController") as! totalHealthInsuranceViewController
        
        dest.viaYear = selectyear.text!
        dest.viaMonth = selectmonth.text!
        
        
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    

}
