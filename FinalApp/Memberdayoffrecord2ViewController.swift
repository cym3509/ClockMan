//
//  Memberdayoffrecord2ViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/8/8.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import UIKit
import Firebase
class Memberdayoffrecord2ViewController: UIViewController  ,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    var ref: DatabaseReference!
    var viayear = ""
    var viamonth = ""
    var memberdayoffs = [Memeberdayoff]()
    var passKey = ""
    
    @IBOutlet weak var chooseyear: UITextField!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var choosemonth: UITextField!
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseyear.returnKeyType = .done
        choosemonth.returnKeyType = .done
        
        ref = Database.database().reference()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.delegate = self
        tableView.dataSource = self
       
        
        
        if viamonth == "1" || viamonth == "2" || viamonth == "3" || viamonth == "4" || viamonth == "5" || viamonth == "6" || viamonth == "7" || viamonth == "8" || viamonth == "9"  {
            choosemonth.text = "0" + viamonth
            
        }else{ choosemonth.text = viamonth}
        
        
        chooseyear.text = ("\(viayear)")
        
        
        
        
        
        
        let uid = Auth.auth().currentUser?.uid
        ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
            
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let uid2 = dic["uid"] as? String
                let dateText = dic["startDate"] as? String
                let cateString = dic["category"] as? String
                let auditText = dic["audit"] as? String
                let monthText = dic["startMonth"] as? String
                let year = dic["startYear"] as? String
                let month = dic["startMonth"] as? String
                let key = dic["key"] as? String
                // print(dateText)
                if uid == uid2 && year == self.chooseyear.text! && month == self.choosemonth.text!{
                    
                    //  print(dateText)
                    let memberdayoff = Memeberdayoff(dateText : dateText, monthText : monthText  ,  cateString:  cateString , auditText: auditText, keyText: key)
                   
                    self.memberdayoffs.insert(memberdayoff, at: 0)
                    
                    self.tableView.reloadData()
                    
                }
            }
            
            
            
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func enter(_ sender: Any) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "MemberdayoffrecordViewController") as!  Memberdayoffrecord2ViewController
           dest.viayear = chooseyear.text!
           dest.viamonth = choosemonth.text!
        
        self.navigationController?.pushViewController(dest, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberdayoffs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "dayoff", for: indexPath) as! memberdayoffTableViewCell
        
        
        
        cell.monthchoose.text = memberdayoffs[indexPath.row].month
        cell.datechoose.text = memberdayoffs[indexPath.row].date
        
        cell.detailsButton.tag = indexPath.row
        cell.detailsButton.addTarget(self, action:#selector(detailsAction(sender:)), for: .touchUpInside)
        
        
        if memberdayoffs[indexPath.row].audit == "yes"{
            cell.audit.setTitle("核准", for: .normal)
            cell.audit.setTitleColor(UIColor(red: 0.1843, green: 0.7176, blue: 0.2392, alpha: 1.0), for: UIControlState.normal)
            cell.audit.backgroundColor = UIColor(red: 0, green: 0.0627, blue: 0.349, alpha: 1.0)
            cell.audit.layer.borderColor = UIColor(red: 0, green: 0.0627, blue: 0.349, alpha: 1.0).cgColor
        }
        else if memberdayoffs[indexPath.row].audit == "no"{
            cell.audit.setTitle("否決", for: .normal)
            cell.audit.setTitleColor(UIColor(red: 1, green: 0.3294, blue: 0.3961, alpha: 1.0), for: UIControlState.normal)
            cell.audit.backgroundColor = UIColor(red: 0, green: 0.0627, blue: 0.349, alpha: 1.0)
            cell.audit.layer.borderColor = UIColor(red: 0, green: 0.0627, blue: 0.349, alpha: 1.0).cgColor
            
        }
        
        
        
        if memberdayoffs[indexPath.row].category == "sick"{
            cell.category.text = "病假"
            
        }
        else if memberdayoffs[indexPath.row].category == "absence"{
            cell.category.text = "事假"
            
        }
        else if memberdayoffs[indexPath.row].category == "other"{
            cell.category.text = "其他"
            
        }
        
        return cell
        
    }
    
    func detailsAction(sender: UIButton){
        
        passKey = memberdayoffs[sender.tag].key!
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "MemberDayoffDetailsViewController") as! MemberDayoffDetailsViewController
        dest.viaKey = passKey
        
        self.navigationController?.pushViewController(dest, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
