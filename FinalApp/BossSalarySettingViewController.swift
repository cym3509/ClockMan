//
//  BossSalarySettingViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/19.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class BossSalarySettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BossSetupFulltimeSalaryDelegate {
    
    var ref: DatabaseReference!
    
    var shows = [hourlyPaid]()
    var ftShows = [FullTimeSalaryModel]()
    var mode: RegisterMode = .PT
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSalaryType: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        //loadMembers()
        loadShow()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mode == .FT {
            btnSalaryType.setTitle("目前底薪", for: .normal)
        }
    }
    
   /* func loadMembers(){
        ref.child("Members").observe(.childAdded, with: {(snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let name = dic["userName"] as? String
                let uid = dic["uid"] as? String
                let companyNum = dic["companyNum"] as? String
                
                
                self.ref.child("HourlyPaid").child(uid!).setValue(["name":name,
                                                                   "uid": uid,
                                                                   "companyNum":companyNum])

                
                
            }
            
            
        })
    }*/
    
  
    
    func loadShow(){
        let uid = Auth.auth().currentUser?.uid
        ref.child("Members").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dataDict = snapshot.value as? [String: AnyObject]{
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String ?? ""
                if self.mode == .PT {
                    self.shows.removeAll()
                    self.ref.child("HourlyPaid").observe(.childAdded, with: {(snapshot) in
                        if let dic = snapshot.value as? [String: AnyObject]{
                            let nameText = dic["name"] as? String
                            let uidText = dic["uid"] as? String
                            let paidText = dic["hourlyPaid"] as? String
                            let companynumText = dic["companyNum"] as? String
                            let show = hourlyPaid(nameText:nameText, paidText:paidText, uidText:uidText, companynumText:companynumText)
                            print(companynumText)
                            if companynumText == companyNum {
                                self.shows.append(show)
                                self.tableView.reloadData()
                            }
                        }
                    })
                } else if self.mode == .FT {
                    self.ftShows.removeAll()
                    self.ref.child("Members").observe(.childAdded, with: { (snapshot) in
                        print(snapshot)
                        if let dic = snapshot.value as? [String: AnyObject]{
                            let nameText = dic["userName"] as? String
                            let uidText = dic["uid"] as? String
                            let role = dic["role"] as? String
                            let baseSalary = dic["baseSalary"] as? String
                            let workInsurance = dic["workInsurance"] as? String
                            let healthInsurance = dic["healthInsurance"] as? String
                            let companynumText = dic["companyNum"] as? String
                            let show = FullTimeSalaryModel(nameText: nameText, baseSalaryText: baseSalary, healthInsurance: healthInsurance, workInsurance: workInsurance, uidText: uidText, companynumText: companynumText)
                            if companynumText == companyNum && (role == "F") {
                                self.ftShows.append(show)
                                self.tableView.reloadData()
                            }
                        }
                    })
                    
                }
                
            }
        })

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .PT {
            let setting = shows[indexPath.row]
            let alertController = UIAlertController(title: setting.name, message:"Update new paid", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler: {
                action in print("close")
            })
            let updateAction = UIAlertAction(title:"Update", style:.default){(_) in
                let updatePaid = alertController.textFields?[0].text
                if Int(updatePaid!)! < 133 {
                    let loginFailWarnAlertController = UIAlertController(title: "低於法定薪資", message: "當前法定時薪為 133/hr", preferredStyle: UIAlertControllerStyle.alert)
                    let closeAction1 = UIAlertAction(title: "關閉", style: .cancel, handler: {
                        action in print("close")
                    })
                    let okAlertAction = UIAlertAction(title: "繼續設定", style: UIAlertActionStyle.default, handler: nil)
                    loginFailWarnAlertController.addAction(okAlertAction)
                    loginFailWarnAlertController.addAction(closeAction1)
                    
                    self.present(loginFailWarnAlertController, animated: true, completion: nil)
                }
                
                self.ref.child("HourlyPaid").observe(.childAdded, with: {(snapshot) in
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let uid = dic["uid"] as? String
                        if uid == setting.uid{
                            let statusRef = Database.database().reference().child("HourlyPaid").child(uid!)
                            let newValue = [
                                "hourlyPaid": updatePaid
                            ]
                            statusRef.updateChildValues(newValue)
                            setting.paid = updatePaid
                            self.tableView.reloadData()
                           
                            
                        }
                    }
                })
                //self.loadShow()
            }
             
            alertController.addTextField{(textField) in
                textField.text = setting.paid
            }
            
            alertController.addAction(updateAction)
            alertController.addAction(closeAction)
            
            present(alertController, animated: true, completion: nil)
        } else if mode == .FT {
            ///
            
            let setting = ftShows[indexPath.row]
            let alertController = UIAlertController(title: setting.name, message:"更改員工底薪", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler: {
                action in print("close")
            })
            let updateAction = UIAlertAction(title:"Update", style:.default){(_) in
                let updatePaid = alertController.textFields?[0].text
                
                self.ref.child("Members").observe(.childAdded, with: {(snapshot) in
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let uid = dic["uid"] as? String
                        if uid == setting.uid{
                            let statusRef = Database.database().reference().child("Members").child(uid!)
                            let newValue = [
                                "baseSalary": updatePaid
                            ]
                            statusRef.updateChildValues(newValue)
                            setting.baseSalary = updatePaid
                            self.tableView.reloadData()
                            
                            
                        }
                    }
                })
                //self.loadShow()
            }
            
            alertController.addTextField{(textField) in
                textField.text = setting.baseSalary
            }
            
            alertController.addAction(updateAction)
            alertController.addAction(closeAction)

            present(alertController, animated: true, completion: nil)

            ///
            tableView.deselectRow(at: indexPath, animated: true)
            //let sb = UIStoryboard(name: "BossSetup", bundle: nil)
            //let vc = sb.instantiateViewController(withIdentifier: "BossSetupFulltimeSalaryVC") as! BossSetupFulltimeSalaryVC
            //vc.delegate = self
            //vc.data = ftShows[indexPath.row]
            //self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .PT {
            return shows.count
        } else {
            return ftShows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "salarySettingCell", for: indexPath) as! salarySettingCell
        if mode == .PT {
            cell.name.text = shows[indexPath.row].name
            cell.hourlyPaid.text = shows[indexPath.row].paid
        } else {
            cell.name.text = ftShows[indexPath.row].name
            cell.hourlyPaid.text = ftShows[indexPath.row].baseSalary
        }
        return cell
    }
    
    
    func bossSetupFulltimeSalaryDataChanged(data: FullTimeSalaryModel) {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let yearstr = "\(year)"
        let monthstr = "\(month)"
        
        self.ref.child("Members").observe(.childAdded, with: {(snapshot) in
            if let dic = snapshot.value as? [String: AnyObject]{
                let uid = dic["uid"] as? String
                if uid == data.uid {
                    let statusRef = Database.database().reference().child("Members").child(uid!)
                    let newValue = [
                        "baseSalary": data.baseSalary,
                        "healthInsurance": data.healthInsurance,
                        "workInsurance": data.workInsurance
                    ]
                    statusRef.updateChildValues(newValue)
                    
                    self.ref.child("Realhourtime").child(uid!).child(yearstr).child(monthstr).observe(.childAdded, with: {(snapshot) in
                        if let dic = snapshot.value as? [String: AnyObject]{
                            let uidr = dic["uid"] as? String
                            let yearr = dic["year"] as? String
                            let monthr = dic["month"] as? String
                            let dater = dic["date"] as? String
                            if (uidr == uid && yearr == yearstr && monthr == monthstr)
                            {
                                
                                let statusRef2 = Database.database().reference().child("Realhourtime").child(uid!).child(yearstr).child(monthstr).child(dater!)
                                let newValue2 = [
                                    "baseSalary": data.baseSalary
                                ]
                                statusRef2.updateChildValues(newValue2)
                                
                                
                                
                            }
                            
                            
                        }})
                }
            }
        })
        self.tableView.reloadData()
    }
    
    


    

}
