//
//  BossSheetViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/7/4.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

enum BossSheetDisplayMode {
    case boss
    case staff
}

class BossSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var lbStartMonth: UILabel!
    @IBOutlet weak var lbStartYear: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: RoundButton!
    
    var viaYear = ""
    var viaMonth = ""
    var viaDate = ""
    var shows = [showSheet]()
    var ref: DatabaseReference!
    var mode: BossSheetDisplayMode = .boss
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        lbStartYear.text = viaYear
        lbStartMonth.text = viaMonth
        lbStartDate.text = viaDate
        
        if mode == .staff {
            btnAdd.isHidden = true
        }
        
        loadShow()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDate"{
            if let dest = segue.destination as? BossAddSheetViewController{
                dest.viaYear = lbStartYear.text!
                dest.viaMonth = lbStartMonth.text!
                dest.viaDate = lbStartDate.text!
            }
        }
    }
    
    func loadShow(){
        shows.removeAll()
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("WorkDay").observe(.childAdded, with: {(snapshot) in
                    
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let nameText = dic["name"] as? String
                        let starttimeText = dic["startTime"] as? String
                        let endtimeText = dic["endTime"] as? String
                        let yearText = dic["year"] as? String
                        let monthText = dic["month"] as? String
                        let dateText = dic["date"] as? String
                        let uidText = dic["uid"] as? String
                        let keyText = dic["key"] as? String
                        let uid = dic["uid"] as? String
                        let categoryText = dic["category"] as? String

                        self.ref.child("Members").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            if let dataDict = snapshot.value as? [String: AnyObject]{
                                
                                let value = snapshot.value as? NSDictionary
                                let company = value?["companyNum"] as? String
                                
                                if(yearText == self.viaYear && monthText == self.viaMonth && dateText == self.viaDate && company == companyNum){
                                    
                                    let show = showSheet(nameText: nameText, starttimeText: starttimeText, endtimeText: endtimeText, uidText: uidText, yearText: yearText, monthText: monthText, dateText: dateText, keyText: keyText, categoryText: categoryText)

                                    
                                    self.shows.append(show)
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        })
                        
                        
                    }
                })
                
            }
        
        })
        
                
        
        
        
           }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mode == .staff {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        
        let workDay = shows[indexPath.row]
        
        let alertController = UIAlertController(title: workDay.name, message:"Give new values to update work time", preferredStyle:.alert)
        
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let key = workDay.key
            let startTime1 = alertController.textFields?[0].text
            let endTime1 = alertController.textFields?[1].text
            
            self.ref.child("WorkDay").observe(.childAdded, with: {(snapshot) in
                
                if  let dic = snapshot.value as? [String: AnyObject]{
                    let uid = dic["uid"] as? String
                    let key = dic["key"] as? String
                    let year = dic["year"] as? String
                    let month = dic["month"] as? String
                    let date = dic["date"] as? String
                    let startTime = dic["startTime"] as? String
                    let endTime = dic["endTime"] as? String
                    let name = dic["name"] as? String
                    
                    print(snapshot)
                    
                    
                    
                    if key == workDay.key  {
                        
                        print(key)
                        
                        let statusRef = Database.database().reference().child("WorkDay").child(key!)
                        
                        let newValue = [
                            "startTime": startTime1,
                            "endTime": endTime1
                        ]
                        
                        statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                            
                            if error != nil{
                                print(error?.localizedDescription ?? "Failed to set status value")
                            }
                            print("Successful")
                            

                            DispatchQueue.main.async{
                                //self.tableView.reloadData()
                                self.loadShow()
                            }
                            
                            
                            
                        })
                        
                        /*
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let dest = Storyboard.instantiateViewController(withIdentifier: "BossSheetViewController") as! BossSheetViewController
                        dest.viaYear = self.lbStartYear.text!
                        dest.viaMonth = self.lbStartMonth.text!
                        dest.viaDate = self.lbStartDate.text!
                        
                        
                        self.navigationController?.pushViewController(dest, animated: true)
                        */
                    }
                    
                    
                }
                
            })

            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            
            self.ref.child("WorkDay").observe(.childAdded, with: {(snapshot) in
                
                if  let dic = snapshot.value as? [String: AnyObject]{
                    let uid = dic["uid"] as? String
                    let key = dic["key"] as? String
                    let year = dic["year"] as? String
                    let month = dic["month"] as? String
                    let date = dic["date"] as? String
                    let startTime = dic["startTime"] as? String
                    let endTime = dic["endTime"] as? String
                    let name = dic["name"] as? String
                    
                    if key == workDay.key {
                        
                    let deleteRef = Database.database().reference().child("WorkDay").child(key!).setValue(nil)
                        
                        DispatchQueue.main.async{
                            //self.tableView.reloadData()
                            self.loadShow()
                        }
                        
                        
                    }

                }
                
                })
            
        }
        
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addTextField{(textField) in
            textField.text = workDay.startTime
        }
        
        alertController.addTextField{(textField) in
            textField.text = workDay.endTime
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func color(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "顏色小提醒", message:"白色為正常班表時間" + "\n" + "灰色為請假成功時間" + "\n" + "橘色為換班成功時間", preferredStyle:.alert)
        
        let cancelAction = UIAlertAction(title: "關閉", style:.cancel){(_) in}
        
        
        
        alertController.addAction(cancelAction)
        
        
        
        
        present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! sheetCell
        
        
        if shows[indexPath.row].category == "dayoff"{
            cell.name.textColor = UIColor.gray
            cell.startTime.textColor = UIColor.gray
            cell.endTime.textColor = UIColor.gray
        }
        
        if shows[indexPath.row].category == "change"{
            cell.name.textColor = UIColor.orange
            cell.startTime.textColor = UIColor.orange
            cell.endTime.textColor = UIColor.orange
        }
        
        
        cell.name.text = shows[indexPath.row].name
        cell.startTime.text = shows[indexPath.row].startTime
        cell.endTime.text = shows[indexPath.row].endTime

        return cell
        
        
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        let date = Date()
        let cal = Calendar.current
        
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        
        if (Int(viaMonth)! == Int(month) && Int(viaDate)! < Int(day)) || (Int(viaMonth)! < Int(month)) || (Int(viaYear)! < Int(year)){
            
            let alertController = UIAlertController(title:"提醒", message:"日期已過", preferredStyle: .alert )
            
            let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler:{
                action in print("close")
            })
            alertController.addAction(closeAction)
            present(alertController, animated: true, completion: nil)
        }
        else{
            
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dest = Storyboard.instantiateViewController(withIdentifier: "BossAddSheetViewController") as! BossAddSheetViewController
            dest.viaYear = lbStartYear.text!
            dest.viaMonth = lbStartMonth.text!
            dest.viaDate = lbStartDate.text!
            
            
            self.navigationController?.pushViewController(dest, animated: true)
            
        }

    }
    
    
    @IBAction func clickDone(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}



