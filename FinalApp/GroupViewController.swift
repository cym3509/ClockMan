//
//  GroupViewController.swift
//  FinalApp
//
//  Created by Apple on 2017/9/10.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class GroupViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    var ref: DatabaseReference!
     let storageRef = Storage.storage().reference()
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var bossname: UILabel!
    
    @IBOutlet weak var bossnum: UILabel!
    @IBOutlet weak var bossemail: UILabel!
    @IBOutlet weak var bosspic: UIImageView!
    
     var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        
        bosspic.layer.cornerRadius = bosspic.frame.size.width/2
        bosspic.clipsToBounds = true

        
        tableView.delegate = self
        tableView.dataSource = self
 ref = Database.database().reference()
        
         loadUsers()
        // Do any additional setup after loading the view.
        
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("Members").observe(.childAdded, with: { (snapshot) in
                    print(snapshot)
                    
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let usernameText = dic["userName"] as? String
                        let emailString = dic["email"] as? String
                        let imageString = dic["pic"] as? String
                        let role = dic["role"] as? String
                        let phone = dic["phone"] as? String
                     let pic = dic["pic"] as? String
                        let company = dic["companyNum"] as? String
                        
                        if (company == companyNum) && (role == "B"){
                            
                            self.code.text = company
                            self.bossname.text = usernameText
                            self.bossnum.text = phone
                            self.bossemail.text = emailString
                            
                            
                            
                                let url = URL(string: pic!)
                                if url != nil {
                                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                        if  error != nil{
                                            print(error!)
                                            return
                                        }
                                        DispatchQueue.main.async{
                                            self.bosspic?.image = UIImage(data: data!)
                                        }
                                    }).resume()}
                            

                            
                            
                                                   }
                    }
                    
                    
                    
                })
                
            }
        })
        
        

        
    }

    
    func loadUsers() {
        
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("Members").observe(.childAdded, with: { (snapshot) in
                    print(snapshot)
                    
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let usernameText = dic["userName"] as? String
                        let emailString = dic["email"] as? String
                        let imageString = dic["pic"] as? String
                        let company = dic["companyNum"] as? String
                          let phoneString = dic["phone"] as? String
                        let role = dic["role"] as? String
                        
                        if (company == companyNum) && (role != "B") {
                            
                            let user = User(usernameText : usernameText, emailString : emailString , imageString: imageString , phoneString: phoneString )
                            self.users.append(user)
                            self.tableView.reloadData()
                            
                        }
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
        
    return users.count
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! groupleTableViewCell
        
        
        
       
        // Configure the cell...
        cell.phonelabel.text = users[indexPath.row].phone
        cell.namelabel.text = users[indexPath.row].username
        //print(users[indexPath.row].username)
        cell.emaillabel.text = users[indexPath.row].email
        cell.photo.image = UIImage(named: "photo")
        cell.photo.layer.cornerRadius = (cell.photo.frame.size.width)/2
        cell.photo.clipsToBounds = true
        
        //  cell.delegate = self
        
        //return cell
        //    cell.image.image = UIImage(named: "photo")
        //cell.image.layer.cornerRadius = (cell.image.frame.size.width)/2
        //cell.image.clipsToBounds = true
        
        
        
        
        if let imageString = users[indexPath.row].imageUrl{
            
            
            let url = URL(string : imageString)
            
            if url != nil{
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if  error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async{
                        cell.photo.image = UIImage(data: data!)
                        //cell.image.layer.cornerRadius = (cell.image.frame.size.width)/2
                        //cell.image.clipsToBounds = true
                        
                    }
                }).resume()
                
                
                
            }
            else {
                cell.photo.image = UIImage(named: "photo")
                //    cell.image.layer.cornerRadius = (cell.image.frame.size.width)/2
                //  cell.image.clipsToBounds = true
                
            }
            
            return cell
            
            
 
 
 
        }; 

 
 return cell
        
    }
    
       

}
