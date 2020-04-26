//
//  SalaryrecordViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/8/16.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SalaryrecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var ref: DatabaseReference!
    
    
    var year = ""
    var month = ""
    var name = ""
    var chooseuid = ""
    
    @IBOutlet weak var chosename: UILabel!
    @IBOutlet weak var chosemonth: UILabel!
    @IBOutlet weak var choseyear: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
     var salaryrecords = [Salaryrecord]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        chosename.text = name
        choseyear.text = year
        chosemonth.text = month
        print(chooseuid)
        ////////
        
        ref.child("Realhourtime").child(chooseuid).child(year).child(month).observe(.childAdded, with: { (snapshot) in
           
            if let dic = snapshot.value as? [String: AnyObject]{
                let dateText = dic["date"] as? String
                let monthText = dic["month"] as? String
                let yearText = dic["year"] as? String
                let realhourText = dic["realhour"] as? String
                let holiday = dic["holiday"] as? String
                let holidaytext = dic["holiday"] as? String
                let hourlypaidText = dic["hourlyPaid"] as? String
                let overtimeText = dic["overtime"] as? String
                 let overtimepaidText = dic["overtimepaid"] as? String
                let  base = dic["baseSalary"] as? String
                let baseInt = Double(base!)
                let hourlyPaidInt = Double(hourlypaidText!)
                let realhourInt = Double(realhourText!)
                let overtimepaidInt = Double(overtimepaidText!)
                let overtimeInt = Double(overtimeText!)
                var persumText = ""
                var paid2 = ""
                
                if holiday == "no" && (realhourInt! <= 8.0) && (base == "0"){
                 persumText = "\(Double(realhourText!)!*Double(hourlypaidText!)!)"
                 paid2 = hourlypaidText!
                }
                else if holiday == "no" && (realhourInt! <= 8.0) && (base != "0"){
                    persumText = "底薪計"
                    paid2 = "//"
                    
                }
               
                else if holiday == "no" && (realhourInt! > 8.0) && (base == "0"){
                    
                    persumText = String(format:"%.2f", overtimepaidInt!*overtimeInt!*hourlyPaidInt! + hourlyPaidInt!*8)
                    
                    let a = Double(hourlypaidText!)
                    let paidstr = "\(a!*overtimepaidInt!)"
                    paid2 = paidstr
                }
                else if holiday == "no" && (realhourInt! > 8.0) && (base != "0"){
                    
                    persumText = String(format:"%.2f",overtimepaidInt!*overtimeInt!*hourlyPaidInt!)
                    let a = Double(hourlypaidText!)
                    let paidstr = "\(a!*overtimepaidInt!)"
                    paid2 = paidstr
                }
                    
                else if holiday == "yes" && (base == "0"){
                    persumText = String(format:"%.2f", Double(realhourText!)!*Double(hourlypaidText!)!*2)
                    
                    let a = Int(hourlypaidText!)
                    let paidstr = "\(a!*2)"
                    paid2 = paidstr
                    
                    
                    
                    
                } else if holiday == "yes" && (base != "0") && (realhourInt! <= 8.0) {
                    persumText = String(format:"%.2f",8*hourlyPaidInt!*2)
                   
                    paid2 = "國定"
                    
                    
                    
                    
                }
                else if holiday == "yes" && (base != "0") && (realhourInt! > 8.0) {
                    persumText = "\(16*hourlyPaidInt!*2)"
                    
                    paid2 = "國定"
                    
                    
                    
                    
                }
                
                let salaryrecord = Salaryrecord(dateText : dateText, monthText : monthText , realhourText:realhourText, hourlypaidText: paid2, persumText: persumText, holidaytext : holidaytext, overtimeText : overtimeText, overtimepaidText: overtimepaidText)
                self.salaryrecords.append(salaryrecord)
                
                self.tableView.reloadData()
           
                
            }
        
        
        }
        
        
        )

        /////
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salaryrecords.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "salaryrecord", for: indexPath) as! SalaryrecordTableViewCell
        cell.choosemonth.text = salaryrecords[indexPath.row].month
        cell.choosedate.text = salaryrecords[indexPath.row].date
                cell.realhour.text = salaryrecords[indexPath.row].realhour
        cell.persum.text = salaryrecords[indexPath.row].persum
        
        
        ref.child("Realhourtime").child(chooseuid).child(year).child(month).observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                
                let dateText = dic["date"] as? String
                let monthText = dic["month"] as? String
                let yearText = dic["year"] as? String
                let realhourText = dic["realhour"] as? String
                let holiday = dic["holiday"] as? String
                let holidaytext = dic["holiday"] as? String
                let hourlypaidText = dic["hourlyPaid"] as? String
                let overtimeText = dic["overtime"] as? String
                let overtimepaidText = dic["overtimepaid"] as? String
                let hourlyPaidInt = Double(hourlypaidText!)
                let realhourInt = Double(realhourText!)
                let overtimepaidInt = Double(overtimepaidText!)
                let overtimeInt = Double(overtimeText!)
               
                 if self.salaryrecords[indexPath.row].holiday == "yes"{
                    
                    cell.hourlypaid.textColor = UIColor.red
                    cell.hourlypaid.text = self.salaryrecords[indexPath.row].hourlypaid

                }
                 else if self.salaryrecords[indexPath.row].holiday == "no" && self.salaryrecords[indexPath.row].overtime != "0"{
                    cell.hourlypaid.text = "加班"

                    cell.hourlypaid.textColor = UIColor.yellow
                    
                }
                else if self.salaryrecords[indexPath.row].holiday == "no" && self.salaryrecords[indexPath.row].overtime == "0" {
                    cell.hourlypaid.text = self.salaryrecords[indexPath.row].hourlypaid
                    
                    cell.hourlypaid.textColor = UIColor.white
                    
                }
                
            }
            
            
            
        }
            
            
        )


        
        
        return cell
    }

}
