//
//  dayoff2ViewController.swift
//  FinalApp
//
//  Created by Apple on 2017/10/27.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class dayoff2ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var dayoffs = [Dayoff]()
    var key1 = ""
    var viayear = ""
    var viamonth = ""
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var choosemonth: UITextField!
    @IBOutlet weak var chooseyear: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            
        }
        
        
        ref = Database.database().reference()
        
        
        print(viamonth)
        
        if viamonth == "1" || viamonth == "2" || viamonth == "3" || viamonth == "4" || viamonth == "5" || viamonth == "6" || viamonth == "7" || viamonth == "8" || viamonth == "9"  {
            choosemonth.text = "0" + viamonth
            
        }else{ choosemonth.text = viamonth}
        
        
        chooseyear.text = ("\(viayear)")
        
        tableView.delegate = self
        tableView.dataSource = self
        loaddayoff()
        // Do any additional setup after loading the view.
    }
    func loaddayoff(){
        
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
                    
                    
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let dayoffnameText = dic["sendName"] as? String
                        let applyday = dic["Applyday"] as? String
                        let dstarttimeString = dic["startTime"] as? String
                        let dendtimeString = dic["endTime"] as? String
                        let dayoffsy = dic["startYear"] as? String
                        let dayoffsm = dic["startMonth"] as? String
                        let dayoffsd = dic["startDate"] as? String
                        let dayoffuid = dic["uid"] as? String
                        let audit = dic["audit"] as? String
                        let dayoffey = dic["endYear"] as? String
                        let dayoffem = dic["endMonth"] as? String
                        let dayoffed = dic["endDate"] as? String
                        let changemember = dic["changemember"] as? String
                        let dauditText = dic["changeaudit"] as? String
                        let keyText = dic["key"] as? String
                        
                        
                        let dstartString = dayoffsy! + "/" + dayoffsm! + "/" + dayoffsd!
                        let dendString = dayoffey! + "/" + dayoffem! + "/" + dayoffed!
                        let uid = dic["uid"] as? String
                        self.ref.child("Members").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            
                            if let dataDict2 = snapshot.value as? [String: AnyObject]{
                                
                                let value = snapshot.value as? NSDictionary
                                let company = value?["companyNum"] as? String
                                
                                if(company == companyNum) && (dauditText == "yes") && (dayoffsy ==
                                    self.chooseyear.text) && (dayoffsm == self.choosemonth.text) {
                                    let dayoff = Dayoff(dayoffnameText:  dayoffnameText , dstartString  : dstartString  ,  dstarttimeString: dstarttimeString , dendString  : dendString , dendtimeString : dendtimeString, auditText : audit,
                                                        keyText : keyText)
                                    self.dayoffs.insert(dayoff, at: 0)
                                    
                                    self.tableView.reloadData()
                                }
                            }
                            
                        })
                        
                        
                    }
                    
                    
                    
                })
                
                
            }
        })
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayoffs.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayoff", for: indexPath) as! dayoffTableViewCell
        
        // Configure the cell...
        
        cell.keys = dayoffs[indexPath.row].key!
        cell.dayoffmember.text = dayoffs[indexPath.row].dayoffname!
        cell.dend.text = dayoffs[indexPath.row].dend!
        
        cell.dendtime.text = dayoffs[indexPath.row].dendtime!
        cell.dstart.text = dayoffs[indexPath.row].dstart!
        cell.dstarttime.text = dayoffs[indexPath.row].dstarttime!
        
        if dayoffs[indexPath.row].audit == "nil"{
            
            cell.audit.image = UIImage(named: "mail")
        } else { cell.audit.image = UIImage(named: "Mailopen")}
        
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showemail" {
            if let destination = segue.destination as? detailmailViewController{
                
                
                
                let path = tableView.indexPathForSelectedRow
                
                //print(path)
                
                let cell = tableView.cellForRow(at: path!) as? dayoffTableViewCell
                
                
                guard let nameLbl = cell?.dayoffmember.text
                    
                    
                    else {return}
                
                
                
                
                guard let  choosekey = cell?.keys
                    else {return}
                
                
                destination.vianame = nameLbl
                
                destination.viakey = choosekey
                print("aaaa", choosekey)
            }
            
        }
    }
    @IBAction func chooseym(_ sender: Any) {
        
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "dayoff2ViewController") as!  dayoff2ViewController
        dest.viayear = chooseyear.text!
        dest.viamonth = choosemonth.text!
        
        self.navigationController?.pushViewController(dest, animated: true)
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

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

