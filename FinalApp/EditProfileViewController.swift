//
//  EditProfileViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/9/4.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UITextField!
    
    @IBOutlet weak var profileEmail: UILabel!
    
    @IBOutlet weak var profileCompanyNum: UITextField!
    
    @IBOutlet weak var profileRole: UILabel!
    
    @IBOutlet weak var profilePhone: UITextField!
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        ref = Database.database().reference()
        
        loaddata()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loaddata(){
        
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
                
                self.profileName.text = username
                self.profileCompanyNum.text = companynum
                self.profileEmail.text = email
                self.profilePhone.text = phone
                
                if role=="B"{
                    self.profileRole.text = "老闆"
                }else if role=="E"{self.profileRole.text = "員工"}
                
                
                
                
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
        
        profileName.returnKeyType = .done

    }
    @IBAction func uploadPhoto(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
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

    @IBAction func E_okBtn(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser?.uid
        
        self.ref.child("Members").child(uid!).updateChildValues(
            ["userName": profileName.text,
             "companyNum": profileCompanyNum.text,
             "phone": profilePhone.text], withCompletionBlock:{ (error, ref) in
                if error != nil{
                    print(error!)
                    return
                }
        })
        
        
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
                        
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let dest = Storyboard.instantiateViewController(withIdentifier: "ESettingViewController") as! BossSettingViewController
                        self.navigationController?.pushViewController(dest, animated: true)

                        
                        
                    }
                })
            })
            
            
        }
        

    }
    
    @IBAction func okBtn(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser?.uid
        
        self.ref.child("Members").child(uid!).updateChildValues(
            ["userName": profileName.text,
             "companyNum": profileCompanyNum.text,
             "phone": profilePhone.text], withCompletionBlock:{ (error, ref) in
            if error != nil{
                print(error!)
                return
            }
        })
        
        
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
                        
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let dest = Storyboard.instantiateViewController(withIdentifier: "BossSettingViewController") as! BossSettingViewController
                        
                        
                        self.navigationController?.pushViewController(dest, animated: true)
                        
                    }
                })
            })
        }

        
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

}
