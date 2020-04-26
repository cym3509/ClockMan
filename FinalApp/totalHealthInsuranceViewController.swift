//
//  totalHealthInsuranceViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/12/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class totalHealthInsuranceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    var ref: DatabaseReference!
    var shows = [healthWorkInsurance]()
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    var viaYear = ""
    var viaMonth = ""
    var healthSum = 0.0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        ref = Database.database().reference()
        
        year.text = viaYear
        month.text = viaMonth
        
        
        loadShow()
        
        tableView.delegate = self 
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            
                            self.ref.child("Salary").child(uid2!).child(self.viaYear).observe(.childAdded, with: {(snapshot) in
                                
                                if let dic = snapshot.value as? [String: AnyObject]{
                                    let name = dic["name"] as? String
                                    let month = dic["month"] as? String
                                    let totalSalary = dic["totalSalary"] as? String
                                    let uid = dic["uid"] as? String
                                    let year = dic["year"] as? String
                                    let work = dic["bossWork"] as? String
                                    let health = dic["bossHealth"] as? String
                                    let retire = dic["bossRetire"] as? String
                                    
                                    
                                    
                                    if year == self.viaYear && month == self.viaMonth{
                                        
                                        
                                        let h = Double(health!)
                                        self.healthSum += h!
                                        
                                        let show = healthWorkInsurance(nameText: name, totalsalaryText: totalSalary, healthText: health, workText: work, retireText: retire)
                                        
                                        //   print(name)
                                        // print(totalSalary)
                                        
                                        self.shows.append(show)
                                        self.tableView.reloadData()
                                        
                                    }
                                    
                                    self.healthLabel.text = "\(Int(self.healthSum))"
                                }
                                
                            })
                    }
                })
            }
        })
        
        

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "healthCell", for: indexPath) as! healthCell
        
        cell.name.text = shows[indexPath.row].name
        cell.salary.text = shows[indexPath.row].totalSalary
        cell.health.text = shows[indexPath.row].health

        return(cell)
        
    }
    
    @IBAction func searchWorkBtn(_ sender: Any) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = Storyboard.instantiateViewController(withIdentifier: "totalWorkInsuranceViewController") as! totalWorkInsuranceViewController
        
        dest.viaYear = viaYear
        dest.viaMonth = viaMonth
        
        
        self.navigationController?.pushViewController(dest, animated: true)
        
        
    }
    

}
