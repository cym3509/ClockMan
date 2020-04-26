import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase




class menuTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var dayoffs = [Dayoff]()
     var daterecords = [daterecord]()
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var companynumLabel: UILabel!
    
     @IBOutlet weak var dayoffCell: bossdayoffcountTableViewCell!
    @IBOutlet weak var menuimage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuimage.layer.cornerRadius = menuimage.frame.size.width/2
        menuimage.clipsToBounds = true
        
        ref = Database.database().reference()
      loaddayoff()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(uid!).observeSingleEvent(of: .value, with:  { (snapshot) in
            if let dataDict = snapshot.value as? [String: AnyObject]{
                let value = snapshot.value as? NSDictionary
                let username = value?["userName"] as? String ?? ""
                let companynum = value?["companyNum"] as? String ?? ""
                let pic = value?["pic"] as? String ?? ""
                print(username)
                print(companynum)
                self.usernameLabel.text = username
                self.companynumLabel.text = companynum
                
                
                
                if let profileImageURL = dataDict["pic"] as? String{
                    let url = URL(string: profileImageURL)
                    if url != nil{

                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if  error != nil{
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async{
                            self.menuimage?.image = UIImage(data: data!)
                        }
                    }).resume()
                    
                    }
                }
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    
    func loaddayoff(){
        
        let currentUser = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let companyNum = value?["companyNum"] as? String
                
                self.ref.child("DayOff").observe(.childAdded, with: { (snapshot) in
                    
                    
                    if let dic = snapshot.value as? [String: AnyObject]{
                        let dayoffnameText = dic["sendName"] as? String
                        let applyday = dic["Applyday"] as? String
                        let dstarttimeString = dic["startTime"] as? String
                        let dendtimeString = dic["endTime"] as? String
                        let dayoffsy = dic["startYear"] as? String
                        let dayoffsm = dic["startMonth"] as? String
                        let dayoffsd = dic["startDate"] as? String
                        let dayoffuid = dic["uid"] as? String
                        let audit = dic["audit"] as? String
                        let dayoffey = dic["endYear"] as? String
                        let dayoffem = dic["endMonth"] as? String
                        let dayoffed = dic["endDate"] as? String
                        let changemember = dic["changemember"] as? String
                        let dauditText = dic["changeaudit"] as? String
                        let keyText = dic["key"] as? String
                        
                        
                        let dstartString = dayoffsy! + "/" + dayoffsm! + "/" + dayoffsd!
                        let dendString = dayoffey! + "/" + dayoffem! + "/" + dayoffed!
                        let uid = dic["uid"] as? String
                        self.ref.child("Members").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            
                            if let dataDict2 = snapshot.value as? [String: AnyObject]{
                                
                                let value = snapshot.value as? NSDictionary
                                let company = value?["companyNum"] as? String
                                
                                if(company == companyNum) && (dauditText == "yes") && (audit == "nil"){
                                    let dayoff = Dayoff(dayoffnameText:  dayoffnameText , dstartString  : dstartString  ,  dstarttimeString: dstarttimeString , dendString  : dendString , dendtimeString : dendtimeString, auditText : audit,
                                                        keyText : keyText)
                                    self.dayoffs.insert(dayoff, at: 0)
                                    
                                    self.tableView.reloadData()
                                    
                                    let dayoffcount = self.dayoffs.count
                                    
                                    self.dayoffCell.count.setTitle("\(dayoffcount)", for: .normal)
                                    self.dayoffCell.count.backgroundColor = UIColor.red
                                    self.dayoffCell.count.layer.borderColor = UIColor.red.cgColor
                                    
                                    

                                }
                            }
                            
                        })
                        
                        
                    }
                    
                    
                    
                })
                
                
            }
        })
        
        
    }

    
}
