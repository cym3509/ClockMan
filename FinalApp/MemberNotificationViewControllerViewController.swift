//
//  MemberNotificationViewControllerViewController.swift
//  FinalApp
//
//  Created by 米娜 on 2017/7/18.
//  Copyright © 2017年 Orla. All rights reserved.
//

import UIKit

class MemberNotificationViewControllerViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
}
