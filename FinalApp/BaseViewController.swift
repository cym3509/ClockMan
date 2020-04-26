//
//  BaseViewController.swift
//  FinalApp
//
//  Created by Hello Kitty on 2017/10/21.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        if self.revealViewController() != nil{
            menuButtom.target = self.revealViewController()
            menuButtom.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        ref = Database.database().reference()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loaddayoff()
        */
        
        
        
    }
    
    func showMessage(title: String, msg: String? = nil) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert )
        let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler:{ action in
            print("close")
        })
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    

}
