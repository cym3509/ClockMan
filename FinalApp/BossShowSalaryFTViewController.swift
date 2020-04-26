import UIKit
import Firebase

class BossShowSalaryFTViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref: DatabaseReference!
    var shows = [salary]()
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viaYear = ""
    var viaMonth = ""
    var passName = ""
    var passUid = ""
    var overtimeSum = 0.0
    var holidaySum = 0.0
    var lateSum = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        year.text = viaYear
        month.text = viaMonth
        
        totalSalaryCalculate1()
        loadShow()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func totalSalaryCalculate1(){
        
        var bossHealth = 0.0
        var bossWork = 0.0
        var bossRetire = 0.0
        
        ref.child("Members").observe(.childAdded, with: {(snapshot) in
          
            
            var overtimepaidInt = 0.0
            var baseSalaryInt = 0.0
            
            
           
       

            if let dic = snapshot.value as? [String: AnyObject]{
                let uid = dic["uid"] as? String
                let role = dic["role"] as? String
                
                
                if(role == "F"){
                   
                    let uidf = dic["uid"] as? String

                    let baseSalary = dic["baseSalary"] as! String
                    self.ref.child("Realhourtime").child(uid!).child(self.viaYear).child(self.viaMonth).observe(.childAdded, with: {(snapshot) in
                        
                        if let dic = snapshot.value as? [String: AnyObject]{
                            let name = dic["name"] as? String
                            let uid = dic["uid"] as? String
                            let realhour = dic["realhour"] as! String
                            let year = dic["year"] as? String
                            let month = dic["month"] as? String
                            let date = dic["date"] as? String
                            let holiday = dic["holiday"] as? String
                            let overtimepaid = dic["overtimepaid"] as! String
                            let basesalary = dic["baseSalary"] as! String
                            let lateInt = dic["late"] as! Double
                            overtimepaidInt = Double(overtimepaid)!
                            baseSalaryInt = Double(basesalary)!
                            print("lateInt = \(lateInt)")
                            
                            let hPaidInt = baseSalaryInt / 160 //160 = 8小時*20天 月工時換時薪
                            

                            
                            //var overtimepay = 0.0
                            var healthInsurance = 0.0
                            var workInsurance = 0.0
                            let baseSalaryDouble = Double(baseSalary)
                          
                            //計算勞健保
                           
                            
                            
                            
                            var perSum = 0.0
                          
 
                                        let hourpay =  Double(baseSalary)!/240 //換算時薪
                                       
                                        let real = Double(realhour)
                            
                            //計算雙半薪水
                            
                            if (holiday == "yes" && real! <= 8){
                                let holidaySalary = hourpay*2*8
                                self.holidaySum += holidaySalary
                                print("H_pay",holidaySalary)
                            }
                            else if (holiday == "yes" && real! > 16){
                                let holidaySalary = hourpay*2*16
                                self.holidaySum += holidaySalary
                                print("H_pay",holidaySalary)
                            }
                            print("HolidaySum",self.holidaySum)
                            
                            //
                                        
                                        
                                        if real! > 8.0 || holiday == "yes"{
                                            

                                            self.ref.child("Realhourtime").child(uid!).child(self.viaYear).child(self.viaMonth).observe(.childAdded, with: {(snapshot) in
                                                
                                                
                                                
                                                if let dic = snapshot.value as? [String: AnyObject]{
                                                    let uidr = dic["uid"] as? String
                                                    let yearr = dic["year"] as? String
                                                    let monthr = dic["month"] as? String
                                                    let dater = dic["date"] as? String
                                                    let realhour = dic["realhour"] as! String
                                                    let real2 = Double(realhour)
                                                    if (uidr == uid && yearr == self.viaYear && monthr == self.viaMonth)
                                                    {
                                                        
                                                        let statusRef2 = Database.database().reference().child("Realhourtime").child(uid!).child(self.viaYear).child(self.viaMonth).child(dater!)
                                                        let newValue = [ "hourlyPaid": "\(hourpay)"] as [String: Any]
                                                        
                                                        
                                                        
                                                        statusRef2.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                                                            print("Successfully set status value")
                                                            // Update your UI
                                                            DispatchQueue.main.async {
                                                                // Do anything with your UI
                                                            }
                                                        })
                                                        
                                                        
                                                    }
                                                   
                                                  
                                                   
                                                    
                                                }})
                                            
                                            let overtime = real!-8.0 //多得加班時數
                                            
                                            let overtimepay = overtime*hourpay*overtimepaidInt

                                            self.overtimeSum += overtimepay

                                        }
                                        
                                        
                                        else if real! <= 8.0{
                                            
                                         //    print("fgg")
                                          //  overtimepay += 0.0
                                        }

                            
                            let x = baseSalaryDouble! + self.holidaySum + self.overtimeSum
                            
                            switch x{
                            case 0:
                                healthInsurance = 0
                                workInsurance = 0
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
                            case 30301 ... 31800:
                                healthInsurance = 447
                                workInsurance = 668
                                bossWork = 2381
                                bossHealth = 1441
                                bossRetire = 1908
                            case 31801 ... 33300:
                                healthInsurance = 469
                                workInsurance = 700
                                bossWork = 2493
                                bossHealth = 1509
                                bossRetire = 1998
                            case 33301 ... 34800:
                                healthInsurance = 490
                                workInsurance = 731
                                bossWork = 2606
                                bossHealth = 1577
                                bossRetire = 2088
                            case 34801 ... 36300:
                                healthInsurance = 511
                                workInsurance = 763
                                bossWork = 2718
                                bossHealth = 1645
                                bossRetire = 2178
                            case 36301 ... 38200:
                                healthInsurance = 537
                                workInsurance = 802
                                bossWork = 2860
                                bossHealth = 1731
                                bossRetire = 2292
                            case 38201 ... 40100:
                                healthInsurance = 564
                                workInsurance = 842
                                bossWork = 3004
                                bossHealth = 1817
                                bossRetire = 2406
                            case 40101 ... 42000:
                                healthInsurance = 591
                                workInsurance = 882
                                bossWork = 3145
                                bossHealth = 1903
                                bossRetire = 2520
 
                                
                            default:
                                break
                            }
                            
                            
                            
                            self.lateSum = self.lateSum + ((lateInt/60)*hPaidInt)  //遲到薪資計算
                            
                            print("paidInt = \(hPaidInt)")
                            print("latesum = \(self.lateSum)")
                            
                            let healthStr = "\(healthInsurance)"
                            let workStr = "\(workInsurance)"
                            let overtimepayStr = String(format:"%.2f", self.overtimeSum)
                            let holidayStr = String(format:"%.2f", self.holidaySum)
                            let lateStr = String(format: "%.2f", self.lateSum)
                            let bossHealthStr = "\(bossHealth)"
                            let bossWorkStr = "\(bossWork)"
                            let bossRetireStr = "\(bossRetire)"
                            var totalSalary = 0.0

                            
                            totalSalary = baseSalaryDouble! + self.holidaySum + self.overtimeSum - healthInsurance - workInsurance - self.lateSum //latesum扣遲到薪資
                           
                            let totalStr = String(format:"%.2f", totalSalary)
                            
                           
                            
                            //print("Total",totalStr)
                            self.ref.child("Salary").child(uid!).child(year!).child(month!).setValue([
                                "uid": uid,
                                "name": name,
                                "year": year,
                                "month": month,
                                "normalSalary": baseSalary,
                                "overtimeSalary": overtimepayStr,
                                "healthInsurance": healthStr,
                                "workInsurance": workStr,
                                "totalSalary": totalStr,
                                "holidaySalary": holidayStr,
                                "totallate":lateStr,
                                "bossHealth": bossHealthStr,
                                "bossWork": bossWorkStr,
                                "bossRetire": bossRetireStr
                                
                                ])
                            
                            
                            
                            //        } }})
                            
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
                        
                        
                        if(companyNum == company && role == "F"){
                            
                            self.ref.child("Salary").child(uid2!).child(self.viaYear).observe(.childAdded, with: {(snapshot) in
                                
                               // print(snapshot)
                                
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
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "salaryCell2", for: indexPath) as! salaryCell
        
        cell.name.text = shows[indexPath.row].name
        cell.totalSalary.text = shows[indexPath.row].totalSalary
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action:#selector(buttonAction(sender:)), for: .touchUpInside)
        
       // print(cell.name.text)
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

