//
//  BossHomeViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/8/1.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class BossHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
     var collections = [collection]()
    
    var ref: DatabaseReference!

    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var year = Int()
    var month = Int()
    var day = Int()
    var hour = Int()
    var min = Int()
    
    var hour1 = String()
    var min1 = String()
    
    var startHour = Int()
    var startMin = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 
        }
 
        ref = Database.database().reference()
       
        let date = Date()
        let cal = Calendar.current
        year = cal.component(.year, from: date)
        month = cal.component(.month, from: date)
        day = cal.component(.day, from: date)
        hour = cal.component(.hour, from: date)
        min = cal.component(.minute, from: date)
        
        hour1 = ("\(hour)")
        min1 = ("\(min)")
        
        let year1 = ("\(year)")
        var month1 = ""
        var day1 = ""
        
        
        
        if ("\(month)") == "10" || ("\(month)") == "11" || ("\(month)") == "12"{
            month1 = ("\(month)")
        }
        else {
            month1 = ("0"+"\(month)")
        }
        
        
        if ("\(day)") == "1" || ("\(day)") == "2" || ("\(day)") == "3" || ("\(day)") == "4" || ("\(day)") == "5" || ("\(day)") == "6" || ("\(day)") == "7" || ("\(day)") == "8" || ("\(day)") == "9"{
            day1 = ("0"+"\(day)")
        }
            
        else {
            day1 = ("\(day)")
        }
        
        today.text = "\(year) / \(month1) / \(day1) "

        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        
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
                    let clockinText = dic["clockin"] as? String
                    let clockoutText = dic["clockout"] as? String
                    let imageUrl = dic["pic"] as? String
                    let uid = dic["uid"] as? String
                    
                    self.ref.child("Members").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                        
                        if let dataDict = snapshot.value as? [String: AnyObject]{
                            
                            let value = snapshot.value as? NSDictionary
                            let company = value?["companyNum"] as? String
                            
                            if(yearText == year1 && monthText == month1 && dateText == day1 && company == companyNum){
                                
                                let Collection = collection(usernameText: nameText, imageString: imageUrl, clockinText: clockinText, starttimeText: starttimeText, endtimeText: endtimeText, keyText: keyText)
                                self.collections.append(Collection)
                                self.CollectionView.reloadData()
                                
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let workTime = collections[indexPath.row]
        
        let alertController = UIAlertController(title: workTime.username, message: "上班時間" + workTime.starttime! + "\n" + "下班時間" + workTime.endtime!, preferredStyle:.alert)
        
        let okAction = UIAlertAction(title: "OK", style:.default){(_) in

        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! BossHomeCollectionViewCell
        
        
        
        cell.colleclabel.text = collections[indexPath.row].username
        
        cell.collecimage.image = UIImage(named: "photo")
        cell.collecimage.layer.cornerRadius = (cell.collecimage.frame.size.width)/2
        cell.collecimage.clipsToBounds = true
        
        
                
        if let s_time = collections[indexPath.row].starttime{
            
            let start = (s_time.components(separatedBy: ":"))
            self.startHour = Int(start[0])!
            self.startMin = Int(start[1])!
            
        }
        
        if let clock1 = collections[indexPath.row].clockin{
            
            
            
            cell.lightButton.layer.cornerRadius = 8.0
            
            if (clock1 != "未打卡"){
                
                cell.lightButton.backgroundColor = UIColor.green
            }
                
            else if ((clock1 == "未打卡") && ((hour >= startHour && min > startMin) || (hour >= startHour && min < startMin))){
                cell.lightButton.backgroundColor = UIColor.red
            }
                
            else{
                cell.lightButton.backgroundColor = UIColor.gray
            }
            
            
        }

        
        
        if let imageString = collections[indexPath.row].imageUrl{
            
            
            let url = URL(string : imageString)
            
            if url != nil{
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if  error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async{
                        cell.collecimage.image = UIImage(data: data!)
                    }
                }).resume()
            }
            else {
                cell.collecimage.image = UIImage(named: "photo")
            }
            return cell
        }
        
        
        
        
        return cell
        
    }

    

}
