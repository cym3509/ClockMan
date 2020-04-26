//
//  changedetailViewController.swift
//  FinalApp
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 Orla. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class changedetailViewController: UIViewController {

      var ref: DatabaseReference!
    
    let storageRef = Storage.storage().reference()

    @IBOutlet weak var dayoffpic: UIImageView!
    
    
    @IBOutlet weak var dayoffname: UILabel!
    
    @IBOutlet weak var check: UILabel!
    @IBOutlet weak var changes: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var changeet: UILabel!
    @IBOutlet weak var changee: UILabel!
    @IBOutlet weak var changest: UILabel!
    @IBOutlet weak var applyday: UILabel!
    var viakey = ""
    var vianame = ""
    var dayoffs = ""
    var dayoffst = ""
    var dayoffe = ""
    var dayoffet = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            
        }

            ref = Database.database().reference()
dayoffname.text = vianame
        changeet.text = dayoffet
        changee.text = dayoffe
        changest.text = dayoffst
        changes.text = dayoffs
        dayoffpic.layer.cornerRadius = dayoffpic.frame.size.width/2
        dayoffpic.clipsToBounds = true
        
        ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let usernameText = dic["sendName"] as? String
                let applyday = dic["Applyday"] as? String
                let category = dic["category"] as? String
                let startyear = dic["startYear"] as? String
                let startmonth = dic["startMonth"] as? String
                let startdate = dic["startDate"] as? String
                let starttime = dic["startTime"] as? String
                let endyear = dic["endYear"] as? String
                let endmonth = dic["endMonth"] as? String
                let enddate = dic["endDate"] as? String
                let endtime = dic["endTime"] as? String
                let uid = dic["uid"] as? String
                let key = dic["key"] as? String
                let changeaudit = dic["changeaudit"] as? String
                let reason = dic["reason"] as? String
                
                if  key == self.viakey{
                    
                    
                    if changeaudit == "yes"{
                        self.check.text = "此假單已核准！"
                        self.check.textColor = UIColor.white
                    } else if changeaudit == "no"{
                        self.check.text = "此假單已否決！"
                        self.check.textColor = UIColor.red
                        
                    }

                    
                    if category == "sick"{
                        self.category.text =
                        "病假"
                        
                    }
                    else if category == "absence"{
                        self.category.text = "事假"
                        
                    }
                    else if category == "other"{
                        self.category.text = "其他"
                        
                    }
                    
            self.reason.text = reason
                self.applyday.text = applyday
                    
                    
                    let statusRef = Database.database().reference().child("Members").child(uid!)
                    statusRef.observeSingleEvent(of: .value , with:  { (snapshot) in
                        
                        
                        print(snapshot)
                        
                        if let dataDict = snapshot.value as? [String: AnyObject]{
                            
                            let value = snapshot.value as? NSDictionary
                            let username = value?["userName"] as? String ?? ""
                            
                            print(username)
                            if let profileImageURL = dataDict["pic"] as? String{
                                let url = URL(string: profileImageURL)
                                if url != nil{
                                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                        if  error != nil{
                                            print(error!)
                                            return
                                        }
                                        DispatchQueue.main.async{
                                            self.dayoffpic?.image = UIImage(data: data!)
                                        }
                                    }).resume()
                                }
                            }
                            
                        }
                        
                    })
                    
                    
                    
                }
           
                
                
                
            }
            
        } )
        

        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkchange(_ sender: Any) {
        
         let alertActionSheet = UIAlertController(title: "審核", message: nil ,preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "確認", style: .default, handler: {
            action in print("yes")
            
            self.ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String: AnyObject]{
                    let usernameText = dic["sendName"] as? String
                    let applyday = dic["Applyday"] as? String
                    let key = dic["key"] as? String
                    let uid = dic["uid"] as? String
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    if key == self.viakey{
                        
                        
                        
                        //  let senderKey = key
                        let statusRef = Database.database().reference().child("DayOff").child(key!)
                        let newValue = ["changeaudit": "yes"] as [String: Any]
                        
                        statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                            
                            
                            
                            
                            if error != nil {
                                print(error?.localizedDescription ?? "Failed to set status value")
                            }
                            print("Successfully set status value")
                            // Update your UI
                            DispatchQueue.main.async {
                                // Do anything with your UI
                            }
                            
                            
                            
                        })
                        
                        
                    
                        
                        
                        
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let dest = Storyboard.instantiateViewController(withIdentifier: "changedetailViewController") as! changedetailViewController
                        dest.vianame = self.dayoffname.text!
                        dest.viakey = self.viakey
                        
                        dest.dayoffs = self.changes.text!

                        dest.dayoffst = self.changest.text!
                        dest.dayoffe = self.changee.text!
                        dest.dayoffet = self.changeet.text!
                        self.navigationController?.pushViewController(dest, animated: true)
                        
                    }
                    
                    
                    
                    
                }
            })
            
            
            
            
            
            
            
            
            
        })

        let noAction = UIAlertAction(title: "否決", style: .destructive, handler: {
            action in print("no")
            
            
            self.ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String: AnyObject]{
                    let usernameText = dic["sendName"] as? String
                    let applyday = dic["Applyday"] as? String
                    let key = dic["key"] as? String
                    
                    
                    
                    if key == self.viakey{
                        
                        
                        
                        //  let senderKey = key
                        let statusRef = Database.database().reference().child("DayOff").child(key!)
                        let newValue = ["changeaudit": "no"] as [String: Any]
                        
                        statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                            
                            
                            
                            
                            if error != nil {
                                print(error?.localizedDescription ?? "Failed to set status value")
                            }
                            print("Successfully set status value")
                            // Update your UI
                            DispatchQueue.main.async {
                                // Do anything with your UI
                            }
                            
                            
                            
                        })
                        
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let dest = Storyboard.instantiateViewController(withIdentifier: "changedetailViewController") as! changedetailViewController
                        dest.vianame = self.dayoffname.text!
                        dest.viakey = self.viakey
                        
                        dest.dayoffs = self.changes.text!
                        
                        
                        
                        
                        dest.dayoffst = self.changest.text!
                        dest.dayoffe = self.changee.text!
                        dest.dayoffet = self.changeet.text!
                        self.navigationController?.pushViewController(dest, animated: true)
                    }
                    
                    
                    
                    
                }
            })
            
            
            
            
            
            
        })
        let closAction = UIAlertAction(title: "關閉", style: .cancel, handler: {
            action in print("close")
            
            
        })
        
        
        
        alertActionSheet.addAction(yesAction)
        alertActionSheet.addAction(noAction)
        alertActionSheet.addAction(closAction)
        
        self.present(alertActionSheet, animated: true, completion: nil)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
