//
//  MemberdetailrecordViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/8/15.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MemberdetailrecordViewController: UIViewController {
    
    var name = ""
    var workdays = ""
    var chooseyearmonth = ""
   
    var realworkdays = ""
    var sick = 0
    var absence = 0
    var other = 0
    var sicksum = 0
    var absencesum = 0
    var othersum = 0
    var overtime = 0
    var overtimesum = 0.0
    
    @IBOutlet weak var normal: UILabel!
    @IBOutlet weak var addtime: UILabel!
    @IBOutlet weak var another: UILabel!
    @IBOutlet weak var sum: UILabel!
    
    
    @IBOutlet weak var absencelabel: UILabel!
    @IBOutlet weak var membername: UILabel!
    @IBOutlet weak var realworkday: UILabel!
    @IBOutlet weak var otherlabel: UILabel!
    
    @IBOutlet weak var otherhour: UILabel!
    @IBOutlet weak var otherday: UILabel!
    @IBOutlet weak var overtimehour: UILabel!
    @IBOutlet weak var workoverday: UILabel!
    @IBOutlet weak var absencehour: UILabel!
    @IBOutlet weak var absenceday: UILabel!
    @IBOutlet weak var overtimelabel: UILabel!
    
    @IBOutlet weak var sickhour: UILabel!
    @IBOutlet weak var sickday: UILabel!
    @IBOutlet weak var imagechoose: UIImageView!
    @IBOutlet weak var sicklabel: UILabel!
    @IBOutlet weak var comnum: UILabel!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var memberimage: UIImageView!
    @IBOutlet weak var yearmonth: UILabel!
    @IBOutlet weak var workday: UILabel!
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var roleType: RegisterMode = .PT
    var baseSalary: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let splityearmonth = chooseyearmonth.components(separatedBy: "/")
        
        
        
        membername.text = name
        workday.text = workdays //4
        yearmonth.text = chooseyearmonth
        realworkday.text = realworkdays  //1
        
        let a = Double(realworkdays) //1.0
        let b = Double(workdays)     //4.0
        let c = (a!/b!)*100
        
        let finalpercent = NSString(format:"%.1f",c)
        
        percent.text = "\(finalpercent)"
        
        imagechoose.layer.cornerRadius = imagechoose.frame.size.width/2
        imagechoose.clipsToBounds = true
        
        let uidd = Auth.auth().currentUser?.uid

        ref.child("Members").child(uidd!).observeSingleEvent(of: .value , with:  { (snapshot) in
            // print(snapshot)
            
            if let dataDict = snapshot.value as? [String: String] {
                
                let value = snapshot.value as? NSDictionary
                let username = value?["userName"] as? String ?? ""
                let companynum = value?["companyNum"] as? String ?? ""
                print("dataDict=\(dataDict)")
                if let role = dataDict["role"], role == RegisterMode.FT.rawValue {
                    self.roleType = .FT
                    if let bs = dataDict["baseSalary"], let salary = Int(bs) {
                        self.baseSalary = salary
                        self.normal.text = "\(salary)"
                        print("self.baseSalary=\(self.baseSalary)")
                    }
                } else {
                    print("NO role")
                }
                
                
                self.comnum.text = companynum
                
                
                if let profileImageURL = dataDict["pic"] as? String{
                    let url = URL(string: profileImageURL)
                    if url != nil{
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if  error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async{
                                self.imagechoose?.image = UIImage(data: data!)
                            }
                        }).resume()}
                }
                
                
                
                
                
            }
            
        }
        )
        
        
        
        // Do any additional setup after loading the view.
        
        
        self.ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
            
            //print(snapshot)
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let uid = value?["uid"] as? String ?? ""
                let category = value?["category"] as? String ?? ""
                let startYear = value?["startYear"] as? String ?? ""
                let startMonth = value?["startMonth"] as? String ?? ""
                let startTime = value?["startTime"] as? String ?? ""
                let endYear = value?["endYear"] as? String ?? ""
                let endMonth = value?["endMonth"] as? String ?? ""
                let endTime = value?["endTime"] as? String ?? ""
                let uid2 = Auth.auth().currentUser?.uid

                
                if (uid == uid2) && (splityearmonth[0] == startYear) && (splityearmonth[1] == startMonth){
                    
                    print(startTime)
                    
                    
                    let splitstartTime = startTime.components(separatedBy: ":")
                    let splitendTime = endTime.components(separatedBy: ":")
                    let eh = Int(splitendTime[0]) //09
                    let em = Int(splitendTime[1]) //00
                    let sh = Int(splitstartTime[0])
                    let sm = Int(splitstartTime[1])
                    
                    
                    
                    
                    
                    let summin = (eh!*60 + em!) - (sh!*60 + sm!)  //80min
                    
                    
                    
                    
                    
                    if category == "sick"{
                        self.sick += 1
                        self.sicksum += summin
                    }
                        
                    else if category == "absence"{
                        self.absence += 1
                        self.absencesum += summin
                    }
                    else if category == "other"{
                        self.other += 1
                        self.othersum += summin
                    }
                    
                    self.sicklabel.text = "\(self.sick)"
                    self.absencelabel.text  = "\(self.absence)"
                    self.otherlabel.text = "\(self.other)"
                    
                    let sicksumhour = (self.sicksum)/60
                    let sicksummin = (self.sicksum)%60
                    self.sickday.text = "\(sicksumhour)"
                    self.sickhour.text = "\(sicksummin)"
                    
                    let absencesumhour = (self.absencesum)/60
                    let absencesummin = (self.absencesum)%60
                    self.absenceday.text = "\(absencesumhour)"
                    self.absencehour.text = "\(absencesummin)"
                    
                    let othersumhour = (self.othersum)/60
                    let othersummin = (self.othersum)%60
                    self.otherday.text = "\(othersumhour)"
                    self.otherhour.text = "\(othersummin)"
                    
                    
                    
                    
                }
                
                
                
                
                
            }
        })
        
        
        self.ref.child("Salary").child(uidd!).child(splityearmonth[0]).child(splityearmonth[1]).observeSingleEvent(of: .value , with:  { (snapshot) in            
            //print(snapshot)
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let uid = value?["uid"] as? String ?? ""
               
                let healthInsurance = value?["healthInsurance"] as? String ?? ""
                let holidaySalary = value?["holidaySalary"] as? String ?? ""
                let normalSalary = value?["normalSalary"] as? String ?? ""
                let overtimeSalary = value?["overtimeSalary"] as? String ?? ""
                let totalSalary = value?["totalSalary"] as? String ?? ""
                let workInsurance = value?["workInsurance"] as? String ?? ""
                print(totalSalary)
                
                let uid3 = Auth.auth().currentUser?.uid
                
                if uid == uid3 {
                    if self.roleType == .FT {
                        self.normal.text = "\(self.baseSalary)"
                    } else {
                        self.normal.text = normalSalary
                    }
                    self.addtime.text = overtimeSalary
                    self.another.text = " \(Double(holidaySalary)! - Double(healthInsurance)! - Double(workInsurance)!)"
                    self.sum.text = totalSalary
                
                
                }
                
                
                
                
                
            }
        
        
        
        }
        
        )
        
        
        self.ref.child("Realhourtime").child(uidd!).child(splityearmonth[0]).child(splityearmonth[1]).observe(.childAdded, with: {(snapshot) in
            print(snapshot)
            if let dic = snapshot.value as? [String: AnyObject]{
                let name = dic["name"] as? String
                let uid = dic["uid"] as? String
                let hourlyPaid = dic["hourlyPaid"] as? String
                let realhour = dic["realhour"] as? String
                let year = dic["year"] as? String
                let month = dic["month"] as? String
                let date = dic["date"] as? String
                let holiday = dic["holiday"] as? String
                let overtimeS = dic["overtime"] as? String
                let overtimepaid = dic["overtimepaid"] as? String
                let hourlyPaidInt = Double(hourlyPaid!)
                let realhourInt = Double(realhour!)
                let overtimepaidInt = Double(overtimepaid!)
                let overtimeInt = Double(overtimeS!)
                
                
                
                if overtimeS != "0"{
                    print("uuuu")
                    print(overtimeS )
                    
                    self.overtime += 1
                    
                    self.overtimesum += overtimeInt!
                    
                    
                }
                
                
                let splitovertime = "\(self.overtimesum)".components(separatedBy: ".") //2.5
                
                let oh = splitovertime[0] //2
                let om = Double(splitovertime[1])!/10*60
                let omm = Int(om)
                
                self.overtimelabel.text = "\(self.overtime)"
                self.workoverday.text = "\(oh)"
                self.overtimehour.text = "\(omm)"
                print("ggeeg")
                print(oh)
                print(om)
                print(self.overtimesum)
                print("ggeeg")
                
                
                
                
                
                
                
                
                
                
                
                
            }})
        
        
        
        
    }
    
    
    @IBAction func look(_ sender: Any) {
        
        
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "BossSalaryDetailsViewController") as! BossSalaryDetailsViewController
        
        let splityearmonth = chooseyearmonth.components(separatedBy: "/")
        
        dest.viaYear = splityearmonth[0]
        dest.viaMonth = splityearmonth[1]
        dest.viaName = name
        dest.viaUid = (Auth.auth().currentUser?.uid)!
        
        self.navigationController?.pushViewController(dest, animated: true)
        

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
    
}
