//
//  OurViewController5.swift
//  sidebar
//
//  Created by 米娜 on 2017/6/4.
//  Copyright © 2017年 米娜. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit
import FBSDKCoreKit

class BossSettingViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profilename: UILabel!
    @IBOutlet weak var profileemail: UILabel!
    @IBOutlet weak var profilerole: UILabel!
    @IBOutlet weak var profilecompanynum: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
             }
            
            
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        ref = Database.database().reference()

        let uid = Auth.auth().currentUser?.uid
        
        
    
        ref.child("Members").child(uid!).observeSingleEvent(of: .value , with:  { (snapshot) in
           
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let username = value?["userName"] as? String ?? ""
                let companynum = value?["companyNum"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let role = value?["role"] as? String ?? ""
                let pic = value?["pic"] as? String ?? ""
                let phone = value?["phone"] as? String

                self.profilename.text = username
                self.profilecompanynum.text = companynum
                self.profileemail.text = email
                self.phone.text = phone
                if role=="B"{
                    self.profilerole.text = "老闆"
                }else if role=="E"{self.profilerole.text = "員工"}

                
                
                
                if let profileImageURL = dataDict["pic"] as? String{
                    let url = URL(string: profileImageURL)
                    if url != nil{
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if  error != nil{
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async{
                            self.profileImage?.image = UIImage(data: data!)
                        }
                    }).resume()}
                }
                
            }
            
            
            
        })
    }
    
  
    
    

    
    @IBAction func logoutbutton(_ sender: Any) {
        
        let accessToken = FBSDKAccessToken.current()
        let loginManager = FBSDKLoginManager()

        
        
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        if Auth.auth().currentUser != nil{
            do{
            try? Auth.auth().signOut()
                if Auth.auth().currentUser == nil{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "Login")as! LoginViewController
                    
                        self.present(storyboard, animated: true, completion: nil)
                }
            }
        }
        
        loginManager.logOut()
           }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]){
    
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
        selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
        profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveChange(){
         let uid = Auth.auth().currentUser?.uid
        let imageName = NSUUID().uuidString
        let storedImage = storageRef.child("profileImage").child(imageName)
        if let uploadData = UIImagePNGRepresentation(self.profileImage.image!)
        {
           
            storedImage.putData(uploadData, metadata: nil, completion:{ (metadata, error) in
                if error != nil{
                print(error!)
                    return
                }
                storedImage.downloadURL(completion: {(url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.ref.child("Members").child(uid!).updateChildValues(["pic" : urlText], withCompletionBlock:{ (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })
                        
                    }
                })
            })
        }
    
    }
    
    
    }
