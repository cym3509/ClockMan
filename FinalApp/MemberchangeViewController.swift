//
//  MemberchangeViewController.swift
//  FinalApp
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import UIKit
import Firebase
class MemberchangeViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    var ref: DatabaseReference!
var changes = [Change]()
    
    @IBOutlet weak var choosemonth: UITextField!
    @IBOutlet weak var chooseyear: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            
        }

        
         ref = Database.database().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        
      
        
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                let name = value?["userName"] as? String
                
                self.ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
                    
                    
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let dayoffnameText = dic["sendName"] as? String
                        let applyday = dic["Applyday"] as? String
                        let changestarttimeString = dic["startTime"] as? String
                        let changeendtimeString = dic["endTime"] as? String
                        let dayoffsy = dic["startYear"] as? String
                        let dayoffsm = dic["startMonth"] as? String
                        let dayoffsd = dic["startDate"] as? String
                        let dayoffuid = dic["uid"] as? String
                        let audit = dic["audit"] as? String
                        let dayoffey = dic["endYear"] as? String
                        let dayoffem = dic["endMonth"] as? String
                        let dayoffed = dic["endDate"] as? String
                        let changemember = dic["changemember"] as? String
                        let changeauditText = dic["changeaudit"] as? String
                        let keyText = dic["key"] as? String
                        
                        
                        let changestartString = dayoffsy! + "/" + dayoffsm! + "/" + dayoffsd!
                        let changeendString = dayoffey! + "/" + dayoffem! + "/" + dayoffed!
                        let uid = dic["uid"] as? String
                        
                        
                        self.ref.child("Members").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            
                            if let dataDict2 = snapshot.value as? [String: AnyObject]{
                                
                                let value = snapshot.value as? NSDictionary
                                let company = value?["companyNum"] as? String
                                
                                if(company == companyNum) && (changemember == name ){
                                    let change = Change(dayoffnameText:  dayoffnameText , changestartString  : changestartString  ,  changestarttimeString: changestarttimeString , changeendString  : changeendString , changeendtimeString : changeendtimeString, changeauditText : changeauditText,
                                                        keyText : keyText)
                                    self.changes.insert(change, at: 0)
                                    
                                    self.tableView.reloadData()
                                    
                                     let changecount = self.changes.count
                                    
                                    
                                /*    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let dest = Storyboard.instantiateViewController(withIdentifier: "MembermenuTableViewController") as!  MembermenuTableViewController
                                    dest.viachangecount = "\(changecount)"
                                    print("\(changecount)" + "aaaaa") */
                                    
                                }
                            }
                            
                        })
                        
                        
                    }
                    
                    
                    
                })
                
                
            }
        })
        

        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "change", for: indexPath) as! changeTableViewCell
        
        
         cell.keys = changes[indexPath.row].key!
         cell.dayoffmember.text = changes[indexPath.row].dayoffname!
        cell.changeend.text = changes[indexPath.row].changeend!
        
        cell.changeendtime.text = changes[indexPath.row].changeendtime!
        cell.changestart.text = changes[indexPath.row].changestart!
        cell.changestarttime.text = changes[indexPath.row].changestarttime!

        if changes[indexPath.row].changeaudit == "nil"{
            
            cell.audit.image = UIImage(named: "mail")
        } else { cell.audit.image = UIImage(named: "Mailopen")}

        
        
        
     return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changedetail" {
            if let destination = segue.destination as? changedetailViewController{
                
                
                
                let path = tableView.indexPathForSelectedRow
                
                //print(path)
                
                let cell = tableView.cellForRow(at: path!) as? changeTableViewCell
                
                
                guard let nameLbl = cell?.dayoffmember.text
                    
                    
                    else {return}
                
                guard let changes = cell?.changestart.text
                    else {return}
                
                
                guard let  changest = cell?.changestarttime.text
                    else {return}
                guard let  changeet = cell?.changeendtime.text

                    else {return}
                guard let  changee = cell?.changeend.text

                    else {return}
                guard let  choosekey = cell?.keys
                    
                    else {return}
                
                destination.vianame = nameLbl
                destination.dayoffs = changes
               destination.dayoffst = changest
                destination.dayoffe = changee
                destination.dayoffet = changeet
                destination.viakey = choosekey
            }
            
        }
        if segue.identifier == "search"{
            if let dest = segue.destination as? Memberchange2ViewController{
                
                dest.viayear =  chooseyear.text!
                dest.viamonth =  choosemonth.text!
                
                print(chooseyear.text)
                print(choosemonth.text)
            }
        }

        
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath){
            self.performSegue(withIdentifier: "changedetail", sender: self)
        }
    }*/
    
    
    
    


}
