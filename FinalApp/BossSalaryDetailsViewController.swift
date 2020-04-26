//
//  BossSalaryDetailsViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/27.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class BossSalaryDetailsViewController: UIViewController {
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    var viaYear = String()
    var viaMonth = String()
    var viaName = String()
    var viaUid = String()
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var regSalary: UILabel!
    
    @IBOutlet weak var addSalary: UILabel!
    
    @IBOutlet weak var doubleSalary: UILabel!
    
    @IBOutlet weak var workInsurance: UILabel!
    
    @IBOutlet weak var healthInsurance: UILabel!
    
    @IBOutlet weak var totalSalary: UILabel!
    
    
    @IBOutlet weak var totallate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        year.text = viaYear
        month.text = viaMonth
        name.text = viaName
        
        pic.layer.cornerRadius = pic.frame.size.width/2
        pic.clipsToBounds = true
        
        loadPic()
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "salary"{
            if let dest = segue.destination as? SalaryrecordViewController{
                
                dest.year = year.text!
                dest.month = month.text!
                dest.name = name.text!
                dest.chooseuid = viaUid
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPic(){
        
        ref.child("Members").child(viaUid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                let value = snapshot.value as? NSDictionary
                
                let picture = value?["pic"] as? String ?? ""
                
                let url = URL(string: picture)
                
                
                
                if url != nil{
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.pic?.image = UIImage(data: data!)
                        }
                        
                    }).resume()
                    
                }
                
                
            }
            
        })
        
    }
    
    
    func loadData(){
        
        ref.child("Salary").child(viaUid).child(viaYear).child(viaMonth).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                let value = snapshot.value as? NSDictionary
                
                let normal = value?["normalSalary"] as? String ?? ""
                let overtime = value?["overtimeSalary"] as? String ?? ""
                let holiday = value?["holidaySalary"] as? String ?? ""
                let workIns = value?["workInsurance"] as? String ?? ""
                let healthIns = value?["healthInsurance"] as? String ?? ""
                let late = value?["totallate"] as? String ?? ""
                
                let total = value?["totalSalary"] as? String ?? ""
                
                self.regSalary.text = normal
                self.addSalary.text = overtime
                self.doubleSalary.text = holiday
                self.workInsurance.text = workIns
                self.healthInsurance.text = healthIns
                self.totallate.text = late
                //遲到
                self.totalSalary.text = total
                
            }
            
        })
        
    }

    
    
    
}
