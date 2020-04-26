//
//  detailpopViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/8.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class detailpopViewController: UIViewController {
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
 var viasegue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.alpha = 1.0;
        ref = Database.database().reference()

     //   self.showAnimate()
        
       
 labelname.text = viasegue
                
        

        // Do any additional setup after loading the view.
        
        
    labelimage.layer.cornerRadius = labelimage.frame.size.width/2
    labelimage.clipsToBounds = true
        
    
        ref.child("Members").observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let usernameText = dic["userName"] as? String
                let emailString = dic["email"] as? String
                  let companynum = dic["companyNum"] as? String ?? ""
                let role = dic["role"] as? String ?? ""
                let pic = dic["pic"] as? String ?? ""
                let phone1 = dic["phone"] as? String
                
                
                if usernameText == self.viasegue{
                //print(emailString)
                self.labelemail.text = emailString
                self.labelcomnum.text = companynum
                    self.labelPhone.text = phone1
                    if role=="B"{
                        self.labelrole.text = "老闆"
                    }else if role=="E"{self.labelrole.text = "員工"}
                    
                
                    if let profileImageURL = dic["pic"] as? String{
                        let url = URL(string: profileImageURL)
                        if url != nil{
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if  error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async{
                                self.labelimage?.image = UIImage(data: data!)
                            }
                        }).resume()}
                    }

                    
                    
                    
                }
            }
            
            
        })

        
        
    }
    @IBOutlet weak var labelname: UILabel!
    
    @IBOutlet weak var labelimage: UIImageView!
    
    @IBOutlet weak var labelemail: UILabel!
    
    @IBOutlet weak var labelcomnum: UILabel!
    
    @IBOutlet weak var labelrole: UILabel!
    
    @IBOutlet weak var labelPhone: UILabel!
   // @IBAction func close(_ sender: UIButton) {
        
        
      //  self.removeAnimate()
  //  }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
