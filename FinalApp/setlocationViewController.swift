//
//  setlocationViewController.swift
//  Clockin
//
//  Created by LiangYu on 2017/8/1.
//  Copyright © 2017年 LiangYu. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase




class setlocationViewController: UIViewController, UITextFieldDelegate{
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var inputaddress: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        inputaddress.returnKeyType = .done
        
        
        // Do any additional setup after loading the view.
    }
  
    @IBAction func setlocation(_ sender: Any) {
        
        addtolocation()
        
    }
    
    
    func addtolocation() {
        let address = inputaddress.text
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            // Use your location
            print(location)
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            let uid = Auth.auth().currentUser?.uid
            
            ////
            
            
            
            let statusRef = Database.database().reference().child("Members").child(uid!)
            let newValue = [ "latitude":"\(location.coordinate.latitude)"] as [String: Any]
            let newValue2 = [ "longitude":"\(location.coordinate.longitude)"] as [String: Any]
            
            
            
            statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                print("Successfully set status value")
                // Update your UI
                DispatchQueue.main.async {
                    // Do anything with your UI
                }
            })
            
            statusRef.updateChildValues(newValue2, withCompletionBlock: { (error, _) in
                print("Successfully set status value")
                // Update your UI
                DispatchQueue.main.async {
                    // Do anything with your UI
                }
            })
            
            ///
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
