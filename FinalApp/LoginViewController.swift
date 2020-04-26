//
//  LoginViewController.swift
//  FinalApp
//
//  Created by ORLA on 2017/5/19.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit



class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate{
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        email.returnKeyType = .done
        email.keyboardType = .emailAddress
        password.returnKeyType = .done

        
        fblogin.readPermissions = ["public_profile", "email"]
        fblogin.delegate = self
        
        if (FBSDKAccessToken.current()) != nil{
            //fetchProfile()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            
            let uid = Auth.auth().currentUser?.uid
            
            ref.child("Members").child(uid!).observeSingleEvent(of: .value , with:  { (snapshot) in
                
                
                if let dataDict = snapshot.value as? [String: AnyObject]{
                    
                    let value = snapshot.value as? NSDictionary
                    let role = value?["role"] as? String ?? ""
                    
                    
                    if role=="B"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bosshome")
                        self.present(vc!, animated: true, completion: nil)

                    } else if role == RegisterMode.PT.rawValue {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "memberhome")
                        self.present(vc!, animated: true, completion: nil)

                    } else if role == RegisterMode.FT.rawValue {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "memberhome")
                        self.present(vc!, animated: true, completion: nil)

                    }
                    
                    
                    
                }
                
                
                
            })

            print ("成功")
        }else{
            print ("失敗")
        }
    }
    
   
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        fetchProfile()
        //onClickLoginWithFacebook()
        print("complete login")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchProfile(){
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credentials = FacebookAuthProvider.credential(withAccessToken:accessTokenString)
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {connection, result, error -> Void in
            
            
            Auth.auth().signIn(with: credentials, completion: {(user, error) in
                if error != nil {
                    print("something wrong", error ?? "")
                    return
                } else {
                    
                    let uid = user?.uid
                    print("========")
                    print(uid!)
                    
                    self.ref.child("Members").observe(DataEventType.value, with: { (snapshot) in
                        
                        if snapshot.hasChild(uid!){
                            
                            print("true it exist")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "memberhome")
                            self.present(vc!, animated: true, completion: nil)
                            
                            
                        }else{
                            
                            print("false it doesn't exist")
                            self.doRegisterUser()
                            
                        }
                    })
                    
                  
                    
                    
                    
                }
                
                
            })
            
        })
    }
    
   
    
    func doRegisterUser() {
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credentials = FacebookAuthProvider.credential(withAccessToken:accessTokenString)
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {connection, result, error -> Void in
            
            
            Auth.auth().signIn(with: credentials, completion: {(user, error) in
                if error != nil {
                    print("something wrong", error ?? "")
                    return
                } else {
                    
                    
                    
                    
                    let uid = user?.uid
                    let email = user?.email
                    var username = ""
                    
                    if let resultNew = result as? [String:Any]{
                        
                        let firstname = resultNew["first_name"] as! String
                        let lastname = resultNew["last_name"] as! String
                        
                        username = lastname+firstname
                        print(username)
                        
                    }
                    
                    
                    self.ref.child("Members").child(user!.uid).setValue(
                        [  "email": email,
                           "userName": username,
                           "companyNum": "",
                           "role": "E",
                           "pic":"",
                           "uid": uid
                        ]
                    )
                        
                }
                
                
                
                
            })
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "companynum")
            self.present(vc!, animated: true, completion: nil)
            
            
        })
        
    }
    
    
    
    
    
    @IBOutlet weak var fblogin: FBSDKLoginButton!
  
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func login(_ sender: AnyObject) {
        
        

        
        if self.email.text == "" || self.password.text == "" {
            
            // 提示用戶是不是忘記輸入 textfield ？
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            
            

            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                
                
                
                if error == nil
                    
                
                {

                    
                    
                    self.ref.child("Members").observe(.childAdded, with: { (snapshot) in

                       
                        if let dic = snapshot.value as? [String: AnyObject]{
                            let emailString = dic["email"] as? String
                            let role = dic["role"] as? String
                            
                            if emailString == self.email.text{
                            
                            print(role)
                                if role == "B"{
                                
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "bosshome")
                                    self.present(vc!, animated: true, completion: nil)

                                }
                                else if role == RegisterMode.PT.rawValue ||  role == RegisterMode.FT.rawValue {
                                
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "memberhome")
                                    self.present(vc!, animated: true, completion: nil)
                                
                                }
                                
                                
                                
                            }
                    
                        }
                        })
                                      
                }
                    
             
                
                
                else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
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
