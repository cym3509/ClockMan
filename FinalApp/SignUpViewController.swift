//
//  SignUpViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/5/20.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase

enum RegisterMode: String {
    case PT = "E"
    case FT = "F"
}


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate{
    
    var mode: RegisterMode = .PT
    var refMembers: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        refMembers = Database.database().reference()
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    
    
    
    @IBOutlet weak var Eemail: UITextField!
    
    @IBOutlet weak var Epassword: UITextField!
    
    @IBOutlet weak var Eusername: UITextField!
   
    @IBOutlet weak var Ecompanynum: UITextField!
    
    @IBAction func addPhoto(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
        

    }
    

    
    @IBAction func createEmployeeAccount(_ sender: UIButton) {
        
        Eemail.keyboardType = .emailAddress
        
        Eemail.returnKeyType = .done
        Epassword.returnKeyType = .done
        Eusername.returnKeyType = .done
        Ecompanynum.returnKeyType = .done
        
        
        
        if Eemail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: Eemail.text!, password: Epassword.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: true, completion: nil)
                 //   self.addEmployeeMembers()
                    let uid = Auth.auth().currentUser?.uid
                     self.refMembers.child("Members").child(user!.uid).setValue(
                        [  "email": self.Eemail.text! as String,
                           "userName": self.Eusername.text! as String,
                           "companyNum": self.Ecompanynum.text! as String,
                           "baseSalary": "0",
                           "role": self.mode.rawValue,
                           "pic":"",
                           "uid": uid
                           
                          ]
                    
                    )
                    
                    self.saveChange()
                    
                    if self.mode == .PT {
                        self.refMembers.child("HourlyPaid").child(user!.uid).setValue(
                        [
                            "name": self.Eusername.text! as String,
                            "uid": uid,
                            "companyNum": self.Ecompanynum.text! as String,
                            
                            ])
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }
        }
    }
    
  /*  func addEmployeeMembers(){
        
       // let key = refMembers.childByAutoId().key
        
        let employeeMember=[
                    "email": Eemail.text! as String,
                    "userName": Eusername.text! as String,
                    "companyNum": Ecompanynum.text! as String,
                    "role": "E"
                   ]
        refMembers.child(uid).setValue(employeeMember)
        
    } */
    
    
    @IBOutlet weak var Bemail: UITextField!
    
    @IBOutlet weak var Bpassword: UITextField!
    
    @IBOutlet weak var Busername: UITextField!
    
    @IBOutlet weak var Bcompanynum: UITextField!
    
    
    @IBAction func createBossAccount(_ sender: UIButton) {
        
        Bemail.keyboardType = .emailAddress
        
        
        
        Bemail.returnKeyType = .done
        Bpassword.returnKeyType = .done
        Busername.returnKeyType = .done
        Bcompanynum.returnKeyType = .done
        
        
        if Bemail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: Bemail.text!, password: Bpassword.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: true, completion: nil)
                    let uid = Auth.auth().currentUser?.uid
                    self.refMembers.child("Members").child(user!.uid).setValue(
                        [  "email": self.Bemail.text! as String,
                           "userName": self.Busername.text! as String,
                           "companyNum": self.Bcompanynum.text! as String,
                           "role": "B",
                            "pic":"",
                            "uid": uid
                        ]
                        
                    )
                    
                    self.saveChange()
                    
                    self.refMembers.child("HourlyPaid").child(user!.uid).setValue(
                        [
                            "name": self.Busername.text! as String,
                            "uid": uid,
                            "companyNum": self.Bcompanynum.text! as String,
                            
                            ])

                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

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
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
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
                        self.refMembers.child("Members").child(uid!).updateChildValues(["pic" : urlText], withCompletionBlock:{ (error, ref) in
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickRegFT(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.mode = .FT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickRegPT(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.mode = .PT
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
