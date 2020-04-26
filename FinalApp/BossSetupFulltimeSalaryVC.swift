//
//  BossSetupFulltimeSalaryVC.swift
//  FinalApp
//
//  Created by Hello Kitty on 2017/10/21.
//  Copyright © 2017年 Orla. All rights reserved.
//

import Foundation

protocol BossSetupFulltimeSalaryDelegate {
    func bossSetupFulltimeSalaryDataChanged(data: FullTimeSalaryModel)
}

class BossSetupFulltimeSalaryVC: BaseViewController {
    @IBOutlet weak var textBaseSalary: UITextField!
    @IBOutlet weak var textWorkInsurance: UITextField!
    @IBOutlet weak var textHealthInsurance: UITextField!
    @IBOutlet weak var btnSubmit: RoundButton!

    var delegate: BossSetupFulltimeSalaryDelegate? = nil
    var data: FullTimeSalaryModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let d = data {
            textBaseSalary.text = d.baseSalary
           // textWorkInsurance.text = d.workInsurance
            //textHealthInsurance.text = d.healthInsurance
        }
    }
    
    @IBAction func clickSubmit(_ sender: Any) {
        guard let t1 = textBaseSalary.text, let n1 = Int(t1) else {
            showMessage(title: "資料未填", msg: "請正確填寫底薪")
            return
        }
      /*  guard let t2 = textWorkInsurance.text, let n2 = Int(t2) else {
            showMessage(title: "資料未填", msg: "請正確填寫勞保")
            return
        }
        guard let t3 = textHealthInsurance.text, let n3 = Int(t3) else {
            showMessage(title: "資料未填", msg: "請正確填寫健保")
            return
        }*/
        if let d = data, let dele = delegate {
            d.baseSalary = "\(n1)"
           // d.workInsurance = "\(n2)"
           // d.healthInsurance = "\(n3)"
            dele.bossSetupFulltimeSalaryDataChanged(data: d)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
