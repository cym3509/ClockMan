//
//  BossShowSalaryViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/23.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class BossShowSalaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var shows = [salary]()
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viaYear = ""
    var viaMonth = ""
    
    var passName = ""
    var passUid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        year.text = viaYear
        month.text = viaMonth
        
        
        
        
        totalSalaryCalculate()
        loadShow()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func totalSalaryCalculate(){
        ref.child("Members").observe(.childAdded, with: {(snapshot) in
            var normalSum = 0.0
            var holidaySum = 0.0
            var overtimeSum = 0.0
            var healthInsurance = 0.0
            var workInsurance = 0.0
            var totalSalary = 0.0
            var bossHealth = 0.0
            var bossWork = 0.0
            var bossRetire = 0.0
            var lateSum = 0.0
        
            var x = 0.0
            
            
            if let dic2 = snapshot.value as? [String: AnyObject]{
                
                let uid2 = dic2["uid"] as? String
                let role = dic2["role"] as? String
                
                if (role == "E"){
                    
                    self.ref.child("Realhourtime").child(uid2!).child(self.viaYear).child(self.viaMonth).observe(.childAdded, with: {(snapshot) in
                        
                        if let dic = snapshot.value as? [String: AnyObject]{
                            let name = dic["name"] as? String
                            let uid = dic["uid"] as? String
                            let hourlyPaid = dic["hourlyPaid"] as? String
                            let realhour = dic["realhour"] as? String
                            let year = dic["year"] as? String
                            let month = dic["month"] as? String
                            let date = dic["date"] as? String
                            let holiday = dic["holiday"] as? String
                            let overtime = dic["overtime"] as? String
                            let overtimepaid = dic["overtimepaid"] as? String
                            let baseSalary = dic["baseSalary"] as! String
                            let late = dic["late"] as! Double
                            let hourlyPaidInt = Double(hourlyPaid!)
                            let realhourInt = Double(realhour!)
                            let overtimepaidInt = Double(overtimepaid!)
                            let overtimeInt = Double(overtime!)
                            let lateInt = late
                            
                            if  (holiday == "yes")
                                
                            {
                                print(snapshot)
                                
                                let holidaySalary = (hourlyPaidInt!*realhourInt!*2)
                                
                                
                                
                                if (uid? .isEqual(uid2))! {
                                    holidaySum += holidaySalary
                                    
                                }
                                
                                
                                print("H_Salary", holidaySalary)
                                
                                
                            }
                            
                            if (holiday == "no")  && (realhourInt! <= 8.0)
                                
                            {
                                
                                print(snapshot)
                                // let hourlyPaidInt = Double(hourlyPaid!)
                                // let realhourInt = Double(realhour!)
                                let normalSalary = (hourlyPaidInt!*realhourInt!)
                                
                                
                                
                                if (uid? .isEqual(uid2))! {
                                    normalSum += normalSalary
                                    
                                }
                                
                                print("N_Salary", normalSalary)
                                
                            }
                            
                            if (holiday == "no") && (realhourInt! > 8.0){
                                
                                
                                
                                
                                let overtimeSalary = (overtimepaidInt!*overtimeInt!*hourlyPaidInt! + hourlyPaidInt!*8)
                                
                                if (uid? .isEqual(uid2))! {
                                    overtimeSum += overtimeSalary
                                    
                                }
                                
                                
                                print("N_overtime", overtimeSalary)
                                
                            }
                            
                            x = normalSum + holidaySum + overtimeSum
                            print("x=",x)
                            
                            switch x{
                            case 0:
                                healthInsurance = 0
                                workInsurance = 0
                                bossHealth = 0
                                bossWork = 0
                                bossRetire = 0
                            case 1 ... 1500:
                                healthInsurance = 296
                                workInsurance = 233
                                bossHealth = 952
                                bossWork = 832
                                bossRetire = 90
                            case 1501 ... 3000:
                                healthInsurance = 296
                                workInsurance = 233
                                bossWork = 832
                                bossHealth = 952
                                bossRetire = 180
                            case 3001 ... 4500:
                                healthInsurance = 296
                                workInsurance = 233
                                bossWork = 832
                                bossHealth = 952
                                bossRetire = 270
                            case 4501 ... 6000:
                                healthInsurance = 296
                                workInsurance = 233
                                bossWork = 832
                                bossHealth = 952
                                bossRetire = 360
                            case 6001 ... 7500:
                                healthInsurance = 296
                                workInsurance = 233
                                bossWork = 832
                                bossHealth = 952
                                bossRetire = 450
                            case 7501 ... 8700:
                                healthInsurance = 296
                                workInsurance = 233
                                bossWork = 832
                                bossHealth = 952
                                bossRetire = 522
                            case 8701 ... 9900:
                                healthInsurance = 296
                                workInsurance = 233
                                bossWork = 832
                                bossHealth = 952
                                bossRetire = 594
                            case 9901 ... 11100:
                                healthInsurance = 296
                                workInsurance = 233
                                bossWork = 832
                                bossHealth = 952
                                bossRetire = 666
                            case 11101 ... 12540:
                                healthInsurance = 296
                                workInsurance = 263
                                bossWork = 940
                                bossHealth = 952
                                bossRetire = 752
                            case 12541 ... 13500:
                                healthInsurance = 296
                                workInsurance = 284
                                bossWork = 1012
                                bossHealth = 952
                                bossRetire = 810
                            case 13501 ... 15840:
                                healthInsurance = 296
                                workInsurance = 333
                                bossWork = 1186
                                bossHealth = 952
                                bossRetire = 950
                            case 15841 ... 16500:
                                healthInsurance = 296
                                workInsurance = 347
                                bossWork = 1237
                                bossHealth = 952
                                bossRetire = 990
                            case 16501 ... 17280:
                                healthInsurance = 296
                                workInsurance = 363
                                bossWork = 1295
                                bossHealth = 952
                                bossRetire = 1037
                            case 17281 ... 17880:
                                healthInsurance = 296
                                workInsurance = 376
                                bossWork = 1339
                                bossHealth = 952
                                bossRetire = 1073
                            case 17881 ... 19047:
                                healthInsurance = 296
                                workInsurance = 400
                                bossWork = 1426
                                bossHealth = 952
                                bossRetire = 1143
                            case 19048 ... 20008:
                                healthInsurance = 296
                                workInsurance = 420
                                bossWork = 1500
                                bossHealth = 952
                                bossRetire = 1200
                            case 20009 ... 21009:
                                healthInsurance = 296
                                workInsurance = 441
                                bossWork = 1574
                                bossHealth = 952
                                bossRetire = 1261
                            case 21010 ... 21900:
                                healthInsurance = 308
                                workInsurance = 460
                                bossWork = 1640
                                bossHealth = 992
                                bossRetire = 1314
                            case 21901 ... 22800:
                                healthInsurance = 321
                                workInsurance = 479
                                bossWork = 1708
                                bossHealth = 1033
                                bossRetire = 1368
                            case 22801 ... 24000:
                                healthInsurance = 338
                                workInsurance = 504
                                bossWork = 1797
                                bossHealth = 1087
                                bossRetire = 1440
                            case 24001 ... 25200:
                                healthInsurance = 355
                                workInsurance = 529
                                bossWork = 1887
                                bossHealth = 1142
                                bossRetire = 1512
                            case 25201 ... 26400:
                                healthInsurance = 371
                                workInsurance = 555
                                bossWork = 1978
                                bossHealth = 1196
                                bossRetire = 1584
                            case 26401 ... 27600:
                                healthInsurance = 388
                                workInsurance = 579
                                bossWork = 2066
                                bossHealth = 1250
                                bossRetire = 1656
                            case 27601 ... 28800:
                                healthInsurance = 405
                                workInsurance = 605
                                bossWork = 2157
                                bossHealth = 1305
                                bossRetire = 1728
                            case 28801 ... 30300:
                                healthInsurance = 426
                                workInsurance = 637
                                bossWork = 2269
                                bossHealth = 1373
                                bossRetire = 1818
                                
                            default:
                                break
                            }

                            lateSum = lateSum + ((lateInt/60) * hourlyPaidInt!)
                            
                            print("latesum = \(lateSum)")
                            
                            
                            let overtimeStr = String(format:"%.2f", overtimeSum)
                            let normalStr = String(format:"%.2f", normalSum)
                            let holidayStr = String(format:"%.2f", holidaySum)
                            let lateStr = String(format:"%.2f", lateSum)
                            let healthStr = "\(healthInsurance)"
                            let workStr = "\(workInsurance)"
                            let bossHealthStr = "\(bossHealth)"
                            let bossWorkStr = "\(bossWork)"
                            let bossRetireStr = "\(bossRetire)"
                            totalSalary = normalSum + holidaySum + overtimeSum - healthInsurance - workInsurance - lateSum//加扣遲到
                            let totalStr = String(format:"%.2f",totalSalary)
                            
                            self.ref.child("Salary").child(uid!).child(year!).child(month!).setValue([
                                "uid": uid,
                                "name": name,
                                "year": year,
                                "month": month,
                                "normalSalary": normalStr,
                                "overtimeSalary": overtimeStr,
                                "holidaySalary": holidayStr,
                                "healthInsurance": healthStr,
                                "workInsurance": workStr,
                                "totalSalary": totalStr,
                                "totallate": lateStr,
                                "bossHealth": bossHealthStr,
                                "bossWork": bossWorkStr,
                                "bossRetire": bossRetireStr
                                
                                ])
                            
                        }
                        
                    })
                    
                }
                
            }
            
        })
        
    }

    
    
    
    func loadShow(){
        
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("Members").observe(.childAdded, with: {(snapshot) in
                    
                    if let dic2 = snapshot.value as? [String: AnyObject]{
                        
                        let uid2 = dic2["uid"] as? String
                        let company = dic2["companyNum"] as? String
                        let role = dic2["role"] as? String
                        
                        if(companyNum == company)&&(role == "E"){
                        
                        self.ref.child("Salary").child(uid2!).child(self.viaYear).observe(.childAdded, with: {(snapshot) in
                            
                            if let dic = snapshot.value as? [String: AnyObject]{
                                let name = dic["name"] as? String
                                let month = dic["month"] as? String
                                let totalSalary = dic["totalSalary"] as? String
                                let uid = dic["uid"] as? String
                                let year = dic["year"] as? String
                                
                                
                                
                                if year == self.viaYear && month == self.viaMonth{
                                    
                                    let show = salary(nameText: name, totalsalaryText: totalSalary, uidText: uid)
                                    
                                    //   print(name)
                                    // print(totalSalary)
                                    
                                    self.shows.append(show)
                                    self.tableView.reloadData()
                                    
                                }
                                
                                
                            }
                            
                        })}
                    }
                })
            }
        })
        
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "salaryCell", for: indexPath) as! salaryCell
        
        cell.name.text = shows[indexPath.row].name
        cell.totalSalary.text = shows[indexPath.row].totalSalary!
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action:#selector(buttonAction(sender:)), for: .touchUpInside)
        
        
        return(cell)
        
    }
    
    func buttonAction(sender: UIButton){
        passName = shows[sender.tag].name!
        passUid = shows[sender.tag].uid!
        
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "BossSalaryDetailsViewController") as! BossSalaryDetailsViewController
        dest.viaYear = year.text!
        dest.viaMonth = month.text!
        dest.viaName = passName
        dest.viaUid = passUid
        
        self.navigationController?.pushViewController(dest, animated: true)
        
    }
     
    
    
}
