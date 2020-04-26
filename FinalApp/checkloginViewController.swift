
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth


class checkloginViewController: UIViewController{
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

       
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (FBSDKAccessToken.current()) != nil{
            print("fbsdkhere")
            print(FBSDKAccessToken.current())
            fetchProfile()
            
        }else{
            //go to login viewcontroller
            print("go to viewcontroller")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(vc!, animated: true, completion: nil)
            
        }
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
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
                            //self.doRegisterUser()
                            //go to login viewcontroller
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                            self.present(vc!, animated: true, completion: nil)

                            
                        }
                    })
                    

                    
                    
                }
                
                
            })
            
        })
    }
    

}
