//
//  recordDateViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/16.
//  Copyright © 2017年 Orla. All rights reserved.
//
import Foundation
import UIKit
import Firebase
class recordDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
var viaDate = ""

    var year = ""
    var month = ""
    var date = ""
    
    var viadate = ""
    var viaon = ""
    var viaoff = ""
    var viain = ""
    var viaout = ""
    var vianame = ""
 
    var daterecords = [daterecord]()
    let storageRef = Storage.storage().reference()
    @IBOutlet weak var choosedate: UILabel!

    
    
  //  @IBOutlet weak var menuButton: UIBarButtonItem!
     @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
 ref = Database.database().reference()
        
      /*  if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }*/
        
        tableView.delegate = self
        tableView.dataSource = self
        choosedate.text = viaDate
        
        let currentUser = Auth.auth().currentUser?.uid

        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let nameText = dic["name"] as? String
                        let onString = dic["startTime"] as? String
                        let offString = dic["endTime"] as? String
                        let chooseyear = dic["year"] as? String
                        let choosemonth = dic["month"] as? String
                        let choosedate = dic["date"] as? String
                        let imageString = dic["pic"] as? String
                        let inString = dic["clockin"] as? String
                        let uid = dic["uid"] as? String
                        let outString = dic["clockout"] as? String
                       
                        let splitdate = self.viaDate.components(separatedBy: "/")
                        let year = splitdate[0]
                        let month = splitdate[1]
                        let date = splitdate[2]
                        
                        self.ref.child("Members").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            if let dataDict = snapshot.value as? [String: AnyObject]{
                                
                                let value = snapshot.value as? NSDictionary
                                let company = value?["companyNum"] as? String
                                
                                if (chooseyear == year && choosemonth == month && choosedate == date && company == companyNum){
                                    
                                    
                                    let Daterecord = daterecord(nameText : nameText, onString : onString , offString: offString, imageString: imageString, inString: inString, outString: outString )
                                    self.daterecords.append(Daterecord)
                                    
                                    self.tableView.reloadData()
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
        return daterecords.count
           }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "recorddate", for: indexPath) as! recorddateTableViewCell
 
        cell.datename.text = daterecords[indexPath.row].datename
        cell.dateon.text = daterecords[indexPath.row].dateon
        cell.dateoff.text = daterecords[indexPath.row].dateoff
       
        cell.dateimage.image = UIImage(named: "photo")
        cell.dateimage.layer.cornerRadius = (cell.dateimage.frame.size.width)/2
        cell.dateimage.clipsToBounds = true
        
        
        ///
  
        
        
        ///
        
        
     cell.datecome.text = daterecords[indexPath.row].clockin
     cell.dateover.text = daterecords[indexPath.row].clockout
        
        
        
        if let imageString = daterecords[indexPath.row].imageUrl{
            
            
            let url = URL(string : imageString)
            
            if url != nil{
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if  error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async{
                        cell.dateimage.image = UIImage(data: data!)
                        //cell.image.layer.cornerRadius = (cell.image.frame.size.width)/2
                        //cell.image.clipsToBounds = true
                        
                    }
                }).resume()
                
                
                
            }
            else {
                cell.dateimage.image = UIImage(named: "photo")
                //    cell.image.layer.cornerRadius = (cell.image.frame.size.width)/2
                //  cell.image.clipsToBounds = true
                
            }
            
            return cell
            
            
        }; return cell

        
        
        

        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showdetail"{
            if let dest = segue.destination as? recordDatedetailViewController{
                
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRow(at: path!) as? recorddateTableViewCell
                
                
                guard let nameLb = cell?.datename.text else {return}
                 dest.vianame = nameLb
                
                guard let onLb = cell?.dateon.text else {return}
               dest.viaon = onLb
                
                
                guard let offLb = cell?.dateoff.text else {return}
                dest.viaoff = offLb
                
            
                guard let inLb = cell?.datecome.text else {return}
                dest.viain = inLb
                
                
                guard let outLb = cell?.dateover.text else {return}
                dest.viaout = outLb
                
                guard let dateLb = choosedate.text else {return}
                dest.viadate = dateLb
                
                
                
                
                
            }
        }
    }
    
   

}
