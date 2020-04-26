//
//  MemberDayoffDetailsViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/8/8.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class MemberDayoffDetailsViewController: UIViewController {
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var applyday: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var s_year: UILabel!
    @IBOutlet weak var s_month: UILabel!
    @IBOutlet weak var s_date: UILabel!
    @IBOutlet weak var s_time: UILabel!
    @IBOutlet weak var e_year: UILabel!
    @IBOutlet weak var e_month: UILabel!
    @IBOutlet weak var e_date: UILabel!
    @IBOutlet weak var e_time: UILabel!
    @IBOutlet weak var reason: UILabel!
    
    
    var viaKey = ""
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadDetails()
        
        pic.layer.cornerRadius = pic.frame.size.width/2
        pic.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func loadDetails(){
     
     
        
        
        ref.child("DayOff").child(viaKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                let value = snapshot.value as? NSDictionary
                
                
                let applydayText = value?["Applyday"] as? String ?? ""
                let auditText = value?["audit"] as? String ?? ""
                let categoryText = value?["category"] as? String ?? ""
                let enddateText = value?["endDate"] as? String ?? ""
                let endmonthText = value?["endMonth"] as? String ?? ""
                let endtimeText = value?["endTime"] as? String ?? ""
                let endyearText = value?["endYear"] as? String ?? ""
                let reasonText = value?["reason"] as? String ?? ""
                let nameText = value?["sendName"] as? String ?? ""
                let startdateText = value?["startDate"] as? String ?? ""
                let startmonthText = value?["startMonth"] as? String ?? ""
                let starttimeText = value?["startTime"] as? String ?? ""
                let startyearText = value?["startYear"] as? String ?? ""
                let uidText = value?["uid"] as? String ?? ""
                
                if categoryText == "sick"{
                    self.category.text = "病假"
                }
                
                else if categoryText == "absence"{
                    self.category.text = "事假"
                    
                }
                else if categoryText == "other"{
                    self.category.text = "其他"
                    
                }

                self.reason.text = reasonText
                self.name.text = nameText
                self.applyday.text = applydayText
                
                self.s_date.text = startdateText
                self.s_month.text = startmonthText
                self.s_year.text = startyearText
                self.s_time.text = starttimeText
                self.e_year.text = endyearText
                self.e_month.text = endmonthText
                self.e_date.text = enddateText
                self.e_time.text = endtimeText
                
                self.ref.child("Members").child(uidText).observeSingleEvent(of: .value, with: {(snapshot) in
                    
                    if let dataDict = snapshot.value as? [String: AnyObject]{
                        let value = snapshot.value as? NSDictionary
                        
                        let picture = value?["pic"] as? String ?? ""
                        
                        let url = URL(string: picture)
                        
                        
                        
                        if url != nil{
                            
                            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    self.pic?.image = UIImage(data: data!)
                                }
                                
                            }).resume()
                            
                        }
                        
                        
                    }
                    
                })

                
            }
            
            
            
        })

     
     }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "sendDayoff"{
            if let dest = segue.destination as? MemberEditDayoffViewController{
                
                dest.vianame = name.text!
                dest.viaapply = applyday.text!
                dest.viacategory = category.text!
                dest.viasyear = s_year.text!
                dest.viasmonth = s_month.text!
                dest.viasdate = s_date.text!
                dest.viaeyear = e_year.text!
                dest.viaemonth = e_month.text!
                dest.viaedate = e_date.text!
                dest.viareason = reason.text!
                dest.viaEditKey = viaKey
                dest.viastime = s_time.text!
                dest.viaetime = e_time.text!
                
            }
        }
    }*/
    
    @IBAction func clickEdit(_ sender: UIBarButtonItem) {
        
        ref.child("DayOff").child(viaKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                let value = snapshot.value as? NSDictionary
                let auditText = value?["audit"] as? String
                
                if auditText == "yes" || auditText == "no"{
                    let alertController = UIAlertController(title:"提醒", message:"此假單已審核", preferredStyle: .alert )
                    
                    let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler:{
                        action in print("close")
                    })
                    alertController.addAction(closeAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                else{
                    
                    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let dest = Storyboard.instantiateViewController(withIdentifier: "MemberEditDayoffViewController") as! MemberEditDayoffViewController
                    
                    dest.vianame = self.name.text!
                    dest.viaapply = self.applyday.text!
                    dest.viacategory = self.category.text!
                    dest.viasyear = self.s_year.text!
                    dest.viasmonth = self.s_month.text!
                    dest.viasdate = self.s_date.text!
                    dest.viaeyear = self.e_year.text!
                    dest.viaemonth = self.e_month.text!
                    dest.viaedate = self.e_date.text!
                    dest.viareason = self.reason.text!
                    dest.viaEditKey = self.viaKey
                    dest.viastime = self.s_time.text!
                    dest.viaetime = self.e_time.text!
                    
                    
                    self.navigationController?.pushViewController(dest, animated: true)
                    
                }
                
            }
        })
        
        
        
       
    }
    
    
}
