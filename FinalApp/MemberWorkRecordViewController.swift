//
//  recordMemberViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/19.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import UIKit
import Firebase
class MemberWorkRecordViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    var ref: DatabaseReference!
    
    @IBOutlet weak var choosemonth: UITextField!
  
    @IBOutlet weak var latetime: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var chooseyear: UITextField!
    
    @IBOutlet weak var membername: UILabel!
  //  var name = ""
    var month = ""
   var uid = ""
    var totallate = 0
    
    var realworkday = 0
    @IBOutlet weak var tableView: UITableView!
    
    var memberrecords = [memberrecord]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

       // membername.text = name
        let date = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        if ("\(month)") == "11" || ("\(month)") == "12" || ("\(month)") == "10" {
            choosemonth.text = ("\(month)")
        }else{ choosemonth.text = "0" + ("\(month)")}
        chooseyear.text = ("\(year)")
        tableView.delegate = self
        tableView.dataSource = self
      //  choosemonth.text = month
      
        
        /////////
        load()
        ////////////
        
        // Do any additional setup after loading the view.
        
    }
    func load(){
        let uid = Auth.auth().currentUser?.uid
        ref.child("Members").child(uid!).observeSingleEvent(of: .value, with:  { (snapshot) in
            if let value = snapshot.value as? [String: String]{
                //let value = snapshot.value as? NSDictionary
                let username = value["userName"] ?? ""
                //let companynum = value?["companyNum"] as? String ?? ""
                //let pic = value?["pic"] as? String ?? ""
                print(username)
                //print(companynum)
                self.membername.text = username
            }
        })
        
        ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
            if let dic = snapshot.value as? [String: AnyObject]{
                let nameText = dic["name"] as? String
                let onString = dic["startTime"] as? String
                let offString = dic["endTime"] as? String
                let chooseyear = dic["year"] as? String
                let monthString = dic["month"] as? String
                let dateString = dic["date"] as? String
                let uidText = dic["uid"] as? String
                let inString = dic["clockin"] as? String
                
                let outString = dic["clockout"] as? String
                
                // let str = viaDate
                
                
                
                if uid == uidText && chooseyear == self.chooseyear.text! && monthString == self.choosemonth.text!{
                     self.membername.text = nameText
                    
                    let Memberrecord = memberrecord(nameText : nameText, onString : onString , offString: offString, monthString: monthString, dateString: dateString,inString: inString, outString: outString , uidText: uidText)
                    
                    
                    
                    
                    self.memberrecords.append(Memberrecord)
                    
                    self.tableView.reloadData()
                }
                
                
                
                
                
                
                
                
                
                
                
            }
            
            
            
        })
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberrecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "recordmember", for: indexPath) as! recordMemberTableViewCell
        
        
        
        cell.monthlabel.text =  memberrecords[indexPath.row].month
        cell.datelabel.text = memberrecords[indexPath.row].date
        cell.dateon.text = memberrecords[indexPath.row].dateon
        cell.dateoff.text = memberrecords[indexPath.row].dateoff
        cell.datecome.text = memberrecords[indexPath.row].clockin
        cell.dateover.text = memberrecords[indexPath.row].clockout
        uid = memberrecords[indexPath.row].uid!
        
        
        
        let a = memberrecords[indexPath.row].clockin
        let b = memberrecords[indexPath.row].clockout
        
        if a != nil && b != nil && a != "未打卡" && b != "未打卡" && a != "請假" && b != "請假" {
            
            realworkday += 1
            
            
            
        }
        // print(realworkday)
        
        
        
        
        //print("yyy" + uid! )
        /////
        
        
        if (cell.dateover.text != nil) && (cell.datecome.text != nil) && (cell.dateover.text != "未打卡") && (cell.datecome.text != "未打卡") && (cell.dateover.text != "請假") && (cell.datecome.text != "請假") {
            
            
            ///早退///
            let splitover = cell.dateover.text?.components(separatedBy: ":")
            //   print(splitover![0]) //09
            //  print(splitover![1]) //50
            
            let splitoff = cell.dateoff.text?.components(separatedBy: ":")
            //   print(splitoff?[0]) //12
            //  print(splitoff?[1]) //55
            
            
            
            let overhour = Int((splitover?[0])!)
            
            let overmin = Int((splitover?[1])!)
            
            let offhour = Int((splitoff?[0])!)
            let offmin = Int((splitoff?[1])!)
            
            
            
            let x = ((offhour!*60 + offmin!) - (overhour!*60 + overmin!))
            let finalout = Int(x)
            
            ////
            if finalout >= 10 {
                cell.showrecord.setTitle("早退", for: .normal)
                cell.showrecord.setTitleColor(UIColor.yellow, for: UIControlState.normal)}
            
            ///早退///
            
            ///遲到///
            let splitcome = cell.datecome.text?.components(separatedBy: ":")
            //  print(splitcome![0]) //09
            //print(splitcome![1]) //50
            
            let spliton = cell.dateon.text?.components(separatedBy: ":")
            //   print(spliton?[0]) //12
            // print(spliton?[1]) //55
            
            
            
            let comehour = Int((splitcome?[0])!)
            
            let comemin = Int((splitcome?[1])!)
            
            let onhour = Int((spliton?[0])!)
            let onmin = Int((spliton?[1])!)
            
            
            
            let y = ((comehour!*60 + comemin!) - (onhour!*60 + onmin!))
            let finalcome = Int(y)
            
            totallate += finalcome
            latetime.text = "\(totallate) 分鐘"
            
            
            
            ////
            if finalcome >= 5 {
                cell.showrecord.setTitle("遲到\(finalcome)分鐘", for: .normal)
                cell.showrecord.setTitleColor(UIColor(red: 0.9765, green: 0.3412, blue: 0.8078, alpha: 1.0), for: UIControlState.normal)}
            
            
            
            
            
            if finalcome >= 5 && finalout >= 10 {
                cell.showrecord.setTitle("遲到早退", for: .normal)
                cell.showrecord.setTitleColor(UIColor(red: 0.9686, green: 0.1922, blue: 0, alpha: 1.0), for: UIControlState.normal)}
            
            
            
        }else {
            
            cell.showrecord.setTitle("未打卡", for: .normal)
            cell.showrecord.setTitleColor(UIColor(red: 0.549, green: 0.4941, blue: 0.698, alpha: 1.0), for: UIControlState.normal)}
        
        
        
        
        
        
        ///遲到///
        
        
        
        
        return cell
        
        
        
    }
 
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            if let dest = segue.destination as? MemberdetailrecordViewController{
                
                dest.name =  membername.text!
                dest.workdays = "\(memberrecords.count)"
                dest.chooseyearmonth = chooseyear.text! + "/" + choosemonth.text!
               // dest.chooseuid = uid
                dest.realworkdays = "\(realworkday)"
            }
        }

        
        if segue.identifier == "choose"{
            if let dest = segue.destination as? MemberWorkRecord2ViewController{
                
                dest.viayear =  chooseyear.text!
              dest.viamonth =  choosemonth.text!
            }
        }
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
