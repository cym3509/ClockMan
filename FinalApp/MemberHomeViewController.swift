import UIKit
import CoreLocation
import MapKit
import Firebase

class MemberHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager = CLLocationManager()
    var manager1 = CLLocationManager()
    var locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var beaconBool = false
    var beaconBool1 = true // beacon test
    
    var clockbool  = true
    
    let uuidString = "B0702880-A295-A8AB-F734-031A98A512DE"
    let identifier = "MacAsBeacon"
    
    @IBOutlet weak var timeLabel: UILabel!
    let clock = Clock()
    var timer: Timer?
    var a = "no"
    var nextwork = "2020-Oct-05 17:00"
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var beacon: UILabel!
    @IBOutlet weak var today: UILabel!
        
    @IBOutlet weak var worktimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        today1()
        
        ref = Database.database().reference()
        locationManager.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MemberHomeViewController.updateTimeLabel), userInfo: nil, repeats: true)
        
        Worktime()
        manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
                locationManager.requestAlwaysAuthorization()
            }
        }
        
        registerBeaconRegionWithUUID(uuidString: uuidString, identifier: identifier, isMonitor: true)
        
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        
    }
    
    func today1(){
        let current = Date()
        var datelabel = current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd EEEE"
        let myString = formatter.string(from: datelabel)
        today.text = myString
        
    }
    
    func timein(){
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print ("\(hour):\(minutes):\(seconds)")
        
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        print ("\(year)/\(month)/\(day)")
        
       
        
        
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("Members").child(uid!).observeSingleEvent(of: .value , with:  { (snapshot) in
            //  print(snapshot)
            
            
            if let dataDict2 = snapshot.value as? [String: AnyObject]{
                
                let value2 = snapshot.value as? NSDictionary
                let username = value2?["userName"] as? String ?? ""
                let uid = value2?["uid"] as? String ?? ""
                
                var Date = ""
                if (month != 11 && month != 12 && month != 10) && (day == 1 || day == 2 || day == 3 || day == 4 || day == 5 || day == 6 || day == 7 || day == 8 || day == 9){
                
                    Date = ("\(year)/0\(month)/0\(day)")

                
                }
                else if (month != 11 && month != 12 && month != 10) && (day != 1 || day != 2 || day != 3 || day != 4 || day != 5 || day != 6 || day != 7 || day != 8 || day != 9){
                    
                    Date = ("\(year)/0\(month)/\(day)")
                    
                    
                }
                else if(month == 11 || month == 12 || month == 10) && (day == 1 || day == 2 || day == 3 || day == 4 || day == 5 || day == 6 || day == 7 || day == 8 || day == 9){
                    
                    Date = ("\(year)/\(month)/0\(day)")
                    
                    
                }else{  Date = ("\(year)/\(month)/\(day)")
}


                
                
                
                
                //    let messID = self.ref.child("Clock").childByAutoId().key
                self.ref.child("Clock").child(uid).child(Date).setValue([
                    
                    
                    "clockDate":Date,
                    "name": username,
                    "clockin":("\(hour):\(minutes):\(seconds)"),
                    "uid":uid,
                    "clockout":"",
                    "latitude":"",
                    "longitude":"",
                    // "key": messID,
                    "judge":""
                    
                    
                    ])
            }
        })
        
    }
    
    
    func timeout(){
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print ("\(hour):\(minutes):\(seconds)")
        
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        
        var Date2 = ""
        if (month != 11 && month != 12 && month != 10) && (day == 1 || day == 2 || day == 3 || day == 4 || day == 5 || day == 6 || day == 7 || day == 8 || day == 9){
            
            Date2 = ("\(year)/0\(month)/0\(day)")
            
            
        }
        else if (month != 11 && month != 12 && month != 10) && (day != 1 || day != 2 || day != 3 || day != 4 || day != 5 || day != 6 || day != 7 || day != 8 || day != 9){
            
            Date2 = ("\(year)/0\(month)/\(day)")
            
            
        }
        else if(month == 11 || month == 12 || month == 10) && (day == 1 || day == 2 || day == 3 || day == 4 || day == 5 || day == 6 || day == 7 || day == 8 || day == 9){
            
            Date2 = ("\(year)/\(month)/0\(day)")
            
            
        }else{  Date2 = ("\(year)/\(month)/\(day)")
        }

        
        let uid = Auth.auth().currentUser?.uid
        ref.child("Clock").child(uid!).child(Date2).observeSingleEvent(of: .value , with:  { (snapshot) in
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let uid2 = value?["uid"] as? String
                let clockdate = value?["clockDate"] as? String
                
                if clockdate == Date2{
                    
                    
                    let statusRef = Database.database().reference().child("Clock").child(uid!).child(Date2)
                    let newValue = [ "clockout":("\(hour):\(minutes):\(seconds)")] as [String: Any]
                    
                    statusRef.updateChildValues(newValue, withCompletionBlock: { (error, _) in
                        print("Successfully set status value")
                        // Update your UI
                        DispatchQueue.main.async {
                            // Do anything with your UI
                        }
                    })
                    
                }
            }
        })
        
            
        let alertController = UIAlertController(title: "打卡成功", message: "下班時間：" + "\(hour):\(minutes):\(seconds)", preferredStyle:.alert)
        
        let okAction = UIAlertAction(title: "OK", style:.default){(_) in
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    //clockin
    @IBAction func clockin(_ sender: UIButton) {
        let currenttime = Date()
        
        
        
        if beaconBool1 == true {
            //上班時間
            print("global nextwork")
            print(nextwork)
            let n = nextwork
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MMM-dd HH:mm"
            //let myString = formatter.string(from: n)
            let yourDate: Date? = formatter.date(from: n)
            print("nextwork")
            print(yourDate)
            
            
            let d = yourDate
            let current = currenttime+(8 * 60 * 60)
            let d1 = d!+(7.5*60*60)
            let d2 = d!+(10*60*60)
            
            let date1 = d1
            let date2 = d2
            
            print("time over here")
            print(date1)
            print(date2)
            print(current)
            
            let fallsBetween = (date1 ... date2).contains(current) //Bool
            
            
            
            if fallsBetween == true {
                
                if clockbool == true{
                    clockbool = false
                    clockinfunc()
                }else{
                    let loginFailWarnAlertController = UIAlertController(title: "上班中", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    loginFailWarnAlertController.addAction(okAlertAction)
                    
                    self.present(loginFailWarnAlertController, animated: true, completion: nil)
                    
                }
                
                
            }else{
                print("上班時間未到")
                let loginFailWarnAlertController = UIAlertController(title: "上班時間未到", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                loginFailWarnAlertController.addAction(okAlertAction)
                
                self.present(loginFailWarnAlertController, animated: true, completion: nil)
                
                
            }
            
            
            
            
            
            
            
        }else{
            let loginFailWarnAlertController = UIAlertController(title: "不在店內", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            loginFailWarnAlertController.addAction(okAlertAction)
            
            self.present(loginFailWarnAlertController, animated: true, completion: nil)
        }


        
        
    }
    
    func clockinfunc(){
        
        
        timein()
        //        manager.delegate = self
        //        manager.requestLocation()
        
        print("clockin successful")
        
        let currentUid = Auth.auth().currentUser?.uid
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        
        let nowyear = calendar.component(.year, from: date)
        let nowday = calendar.component(.day, from: date)
        let nowmonth = calendar.component(.month, from: date)
        let nowyearstr = "\(nowyear)"
        var nowmonthstr = ""
        var nowdaystr = ""
        
        if nowmonth == 11 || nowmonth == 12 || nowmonth == 10{
            nowmonthstr = "\(nowmonth)"
        }
        else{
            nowmonthstr = "0"+"\(nowmonth)"
        }
        
        if nowday == 1 || nowday == 2 || nowday == 3 || nowday == 4 || nowday == 5 || nowday == 6 || nowday == 7 || nowday == 8 || nowday == 9 {
            nowdaystr = "0"+"\(nowday)"
        }
        else{
            nowdaystr = "\(nowday)"
        }
        
        
        
        
        
        
        
        ref.child("WorkDay").observe(.childAdded, with: {(snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                
                let year = dic["year"] as? String
                let month = dic["month"] as? String
                let date = dic["date"] as? String
                let uid = dic["uid"] as? String
                let key = dic["key"] as? String
                
                
                
                if year == nowyearstr && month == nowmonthstr && date == nowdaystr && uid == currentUid {
                    
                    self.ref.child("WorkDay").child(key!).updateChildValues(
                        ["clockin": "\(hour):\(minutes)",
                        ], withCompletionBlock:{ (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                    })
                }
                
                
                
                
            }
            
            
        })
        
        let loginFailWarnAlertController = UIAlertController(title: "上班打卡成功", message: "上班時間 ："+"\(nowyear)/\(nowmonth)/\(nowday)"+" "+"\(hour):\(minutes):\(seconds)", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        loginFailWarnAlertController.addAction(okAlertAction)
        
        self.present(loginFailWarnAlertController, animated: true, completion: nil)
        
        
        
    }
    
    //clockout
    @IBAction func clockout(_ sender: UIButton) {
        if clockbool == false {
            clockbool = true
            
            if beaconBool1 == true {
                clockoutfunc()
            }else{
                let loginFailWarnAlertController = UIAlertController(title: "不在店內!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAlertAction = UIAlertAction(title: "好吧", style: UIAlertActionStyle.default, handler: nil)
                loginFailWarnAlertController.addAction(okAlertAction)
                
                self.present(loginFailWarnAlertController, animated: true, completion: nil)
            }
        }else{
            let loginFailWarnAlertController = UIAlertController(title: "請先打上班卡", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAlertAction = UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil)
            loginFailWarnAlertController.addAction(okAlertAction)
            
            self.present(loginFailWarnAlertController, animated: true, completion: nil)
        }
        
    }
    
    func clockoutfunc(){
        timeout()
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowyear = calendar.component(.year, from: date)
        let nowday = calendar.component(.day, from: date)
        let nowmonth = calendar.component(.month, from: date)
        let nowyearstr = "\(nowyear)"
        var nowmonthstr = ""
        var nowdaystr = ""
        
        
        if nowmonth == 11 || nowmonth == 12 || nowmonth == 10{
            nowmonthstr = "\(nowmonth)"
        }
        else{
            nowmonthstr = "0"+"\(nowmonth)"
        }
        
        if nowday == 1 || nowday == 2 || nowday == 3 || nowday == 4 || nowday == 5 || nowday == 6 || nowday == 7 || nowday == 8 || nowday == 9 {
            nowdaystr = "0"+"\(nowday)"
        }
        else{
            nowdaystr = "\(nowday)"
        }
        
        let uids = Auth.auth().currentUser?.uid
        
        ref.child("Holiday").child(nowyearstr).child(nowmonthstr).child(nowdaystr).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dic4 = snapshot.value as? [String: AnyObject]{
                
                let holiday_year = dic4["year"] as? String
                let holiday_month = dic4["month"] as? String
                let holiday_date = dic4["date"] as? String
                
                if(nowyearstr == holiday_year && nowmonthstr == holiday_month && nowdaystr == holiday_date){
                    self.a = "yes"
                }
                
                print("aaaaaa",self.a)
            }
        })
        
        var new1 = ""
        
        ref.child("WorkDay").observe(.childAdded, with: {(snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let year = dic["year"] as? String
                let month = dic["month"] as? String
                let date = dic["date"] as? String
                
                let s_time = dic["startTime"] as? String
                let e_time = dic["endTime"] as? String
                
                
                
                
                if(year == nowyearstr && month == nowmonthstr && date == nowdaystr){
                    
                    let splitS = s_time?.components(separatedBy: ":")
                    let splitE = e_time?.components(separatedBy: ":")
                    
                    let s_hour = Double(splitS![0])
                    let s_min = Double(splitS![1])
                    let e_hour = Double(splitE![0])
                    let e_min = Double(splitE![1])
                    
                    let x = ((e_hour!*60 + e_min!)-(s_hour!*60 + s_min!))/60
                    
                    let a = Double(x)
                    let b = Int(x)
                    let c = Double(b)
                    var new : Double?
                    let temp = Double(a-c)
                    
                    
                    
                    
                    if (temp != 0 && temp <= 0.5){
                        new = Double(c + 0.5)
                        new1 = "\(new!)"
                        
                        
                    }
                        
                        
                    else if (temp != 0 && temp > 0.5){
                        
                        new = Double(c + 1.0)
                        new1 = "\(new!)"
                        
                        
                    }
                    else if (temp == 0){
                        
                        new = Double(c)
                        
                        new1 = "\(new!)"
                        
                    }
                    
                    
                    
                    print("aaaaaa   ",new1 )
                    
                }
                
            }
            
        })
        
        
        var overtime = ""
        var overtimepaid = ""
        let currentuid = Auth.auth().currentUser?.uid
        
        ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let usernameText = dic["name"] as? String
                let year = dic["year"] as? String
                let month = dic["month"] as? String
                let date = dic["date"] as? String
                let uid = dic["uid"] as? String
                
                
                
                self.ref.child("Clock").child(uids!).child(year!).child(month!).child(date!).observeSingleEvent(of: .value , with:  { (snapshot) in
                    
                    if let dic2 = snapshot.value as? [String: AnyObject]{
                        let uid2 = dic2["uid"] as? String
                        let clockDate = dic2["clockDate"] as? String
                        
                        self.ref.child("Members").observe(.childAdded, with:{(snapshot) in
                            
                            if let dic4 = snapshot.value as? [String: AnyObject]{
                                let role = dic4["role"] as? String
                                let baseSalary = dic4["baseSalary"] as? String
                                if(role == "E"){
                                    
                                    self.ref.child("HourlyPaid").observe(.childAdded, with: { (snapshot) in
                                        
                                        if let dic3 = snapshot.value as? [String: AnyObject]{
                                            let uid3 = dic3["uid"] as? String
                                            let hourlypaid = dic3["hourlyPaid"] as? String
                                            
                                            
                                            let real = Double(new1)
                                            if (real! > 8.0){
                                                overtime = "\(real! - 8.0)"
                                                if (Double(overtime)! <= 2.0 ){
                                                    
                                                    overtimepaid = "1.33"
                                                    
                                                }else if (Double(overtime)! > 2.0 ){
                                                    
                                                    overtimepaid = "1,67"
                                                    
                                                }
                                                
                                            }else if (real! <= 8.0){
                                                overtime = "0"
                                                overtimepaid = "0"
                                                
                                                
                                                
                                            }
                                            
                                            if (currentuid == uid && uid == uid3 && uid == uid2){
                                                self.ref.child("Realhourtime").child(uid!).child(nowyearstr).child(nowmonthstr).child(nowdaystr).setValue(
                                                    
                                                    [
                                                        "name": usernameText,
                                                        "uid": uid,
                                                        "year": nowyearstr,
                                                        "month": nowmonthstr,
                                                        "date": nowdaystr,
                                                        "holiday":self.a,
                                                        "hourlyPaid": hourlypaid,
                                                        "realhour": new1,
                                                        "overtime": overtime,
                                                        "baseSalary":"0",
                                                        "overtimepaid" : overtimepaid
                                                    ]
                                                    
                                                )
                                            }
                                            
                                        }
                                    })
                                    
                                }
                                
                                else if(role == "F"){
                                    
                                    let real = Double(new1)
                                    if (real! > 8.0){
                                        overtime = "\(real! - 8.0)"
                                        if (Double(overtime)! <= 2.0 ){
                                            
                                            overtimepaid = "1.33"
                                            
                                        }else if (Double(overtime)! > 2.0 ){
                                            
                                            overtimepaid = "1.67"
                                            
                                        }
                                        
                                    }else if (real! <= 8.0){
                                        overtime = "0"
                                        overtimepaid = "0"
                                        
                                        
                                        
                                    }
                                    self.ref.child("Realhourtime").child(currentuid!).child(nowyearstr).child(nowmonthstr).child(nowdaystr).setValue(
                                        
                                        [
                                            "name": usernameText,
                                            "uid": uid,
                                            "year": nowyearstr,
                                            "month": nowmonthstr,
                                            "date": nowdaystr,
                                            "holiday":self.a,
                                            "hourlyPaid": "0",
                                            "realhour": new1,
                                            "baseSalary": baseSalary,
                                            "overtime":  overtime,
                                            "overtimepaid" : overtimepaid
                                            ]
                                        
                                    )
                                    
                                }
                            }
                            
                        })
                        
                        
                    }
                })
            }
        })
        
        
        
        print("Cloock out successful")
        
        
        
        ref.child("WorkDay").observe(.childAdded, with: {(snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                
                let year = dic["year"] as? String
                let month = dic["month"] as? String
                let date = dic["date"] as? String
                let uid = dic["uid"] as? String
                let key = dic["key"] as? String
                
                
                
                if year == nowyearstr && month == nowmonthstr && date == nowdaystr && uid == uids {
                    
                    self.ref.child("WorkDay").child(key!).updateChildValues(
                        ["clockout": "\(hour):\(minutes)",
                        ], withCompletionBlock:{ (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                    })
                }
                
                
                
                
            }
            
            
        })
        
        
    }
    
    //===worktime
    func Worktime() {
        let currentdate = Date()
        let dateformatter = DateFormatter()
        var dateComponents = DateComponents()
        let userCalendar = Calendar.current
        
        dateformatter.dateStyle = .full
        dateformatter.timeStyle = .long
        
        //------------------------------------
        let uid = Auth.auth().currentUser?.uid
        
        var datelist: [Date] = []
        
        
        
        
        ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
            if let dic = snapshot.value as? [String: AnyObject]{
                //let nameText = dic["name"] as? String
                let stime = dic["startTime"] as? String
                let offString = dic["endTime"] as? String
                let wyear = dic["year"] as? String
                let wmonth = dic["month"] as? String
                let wdate = dic["date"] as? String
                let uidText = dic["uid"] as? String
                //let inString = dic["clockin"] as? String
                
                //let outString = dic["clockout"] as? String
                
                //let str = viaDate
                
                if uid == uidText {
                    let spliton = stime?.components(separatedBy: ":")
                    let shour = String((spliton?[0])!)
                    let smin = String((spliton?[1])!)
                    
                    dateComponents.year = Int(wyear!)
                    dateComponents.month = Int(wmonth!)
                    dateComponents.day = Int(wdate!)
                    dateComponents.timeZone = TimeZone.current
                    dateComponents.hour = Int(shour!)
                    dateComponents.minute = Int(smin!)
                    
                    let date1 = userCalendar.date(from: dateComponents)
                    let date2 = currentdate
                    
                    if Calendar.current.isDateInToday(date1!){
                        
                        dateformatter.dateFormat = "yyyy-MMM-dd HH:mm"
                        let updatedString = dateformatter.string(from: date1!)
                        
                        //self.nextwork = updatedString
                    }
                    
                    
                    if (date1?.timeIntervalSinceReferenceDate)! - (date2.timeIntervalSinceReferenceDate) >= -(8*60*60) {
                        
                        
                        print("date1 over here")
                        print(date1)
                        
                        datelist.append(date1!)
                        
                        
                    }else{
                        let work1 = "尚未排班"
                        self.worktimeLabel.text = String(describing: work1)
                    }
                    
                    
                }
                
                
            }
            //===============
            //            print("datelist")
            //            print(datelist)
            
            let a = datelist.min()
            
            if let t = a {
                
                var datelabel = t
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let myString = formatter.string(from: datelabel)
                let yourDate: Date? = formatter.date(from: myString)
                formatter.dateFormat = "yyyy-MMM-dd HH:mm"
                let updatedString = formatter.string(from: yourDate!)
                
                
                
                
                self.worktimeLabel.text = String(describing: updatedString)
                self.nextwork = updatedString
                
            }
            
        })
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentUid = Auth.auth().currentUser?.uid
        
        let date = Date()
        let calendar = Calendar.current
        let nowyear = calendar.component(.year, from: date)
        let nowday = calendar.component(.day, from: date)
        let nowmonth = calendar.component(.month, from: date)
        let nowyearstr = "\(nowyear)"
        var nowmonthstr = ""
        var nowdaystr = ""
        
        if nowmonth == 11 || nowmonth == 12 || nowmonth == 10{
            nowmonthstr = "\(nowmonth)"
        }
        else{
            nowmonthstr = "0"+"\(nowmonth)"
        }
        
        if nowday == 1 || nowday == 2 || nowday == 3 || nowday == 4 || nowday == 5 || nowday == 6 || nowday == 7 || nowday == 8 || nowday == 9 {
            nowdaystr = "0"+"\(nowday)"
        }
        else{
            nowdaystr = "\(nowday)"
        }

        
        
        self.ref.child("Members").observe(.childAdded, with: {(snapshot) in
            
            let uid = Auth.auth().currentUser?.uid  //staff
            
            
            if let dataDict = snapshot.value as? [String: AnyObject]{
                
                let value = snapshot.value as? NSDictionary
                let key = value?["key"] as? String ?? ""
                let bossuid = value?["uid"] as? String ?? ""
                let comnum = value?["companyNum"] as? String ?? ""
                let bosslatitude = value?["latitude"] as? String ?? ""
                let bosslongitude = value?["longitude"] as? String ?? ""
                let bossrole = value?["role"] as? String ?? ""
                
                
                self.ref.child("Members").child(uid!).observeSingleEvent(of: .value , with:  { (snapshot) in
                    
                    if let dataDict2 = snapshot.value as? [String: AnyObject]{
                        
                        let value2 = snapshot.value as? NSDictionary
                        let staffcomnum = value2?["companyNum"] as? String ?? ""
                        
                        if comnum == staffcomnum && bossrole == "B" {
                            
                            
                            let coordinate = locations[0].coordinate//get location
                            
                            if let location = locations.first {
                                
                                print("Found user's location: \(location)")
                                print("緯度：\(coordinate.latitude)")
                                print("經度：\(coordinate.longitude)")
                                print(" ")
                                
                                //distance
                                let coordinate0 = CLLocation(latitude:coordinate.latitude, longitude: coordinate.longitude)
                                let coordinate1 = CLLocation(latitude: Double(bosslatitude)!, longitude: Double(bosslongitude)!)
                                
                                let distanceInMeters = coordinate0.distance(from: coordinate1)
                                print("distance = ")
                                print(distanceInMeters)
                                
                                
                                if distanceInMeters <= 20 {
                                    
                                    ////
                                    
                                    let date = Date()
                                    let calendar = Calendar.current
                                    
                                    let hour = calendar.component(.hour, from: date)
                                    let minutes = calendar.component(.minute, from: date)
                                    let seconds = calendar.component(.second, from: date)
                                    print ("\(hour):\(minutes):\(seconds)")
                                    
                                    let year = calendar.component(.year, from: date)
                                    let day = calendar.component(.day, from: date)
                                    let month = calendar.component(.month, from: date)
                                    
                                    
                                    let Date2 = ("\(year)/\(month)/\(day)")
                                    
                                    let uid = Auth.auth().currentUser?.uid
                                    self.ref.child("Clock").child(uid!).child(Date2).observeSingleEvent(of: .value , with:  { (snapshot) in
                                        
                                        
                                        
                                        if let dataDict = snapshot.value as? [String: AnyObject]{
                                            
                                            let value = snapshot.value as? NSDictionary
                                            //  let key = value?["key"] as? String ?? ""
                                            let uid2 = value?["uid"] as? String ?? ""
                                            
                                            if uid == uid2 {
                                                
                                                
                                                let statusRef = Database.database().reference().child("Clock").child(uid!).child(Date2)
                                                let newValue = [ "latitude":"\(coordinate.latitude)"] as [String: Any]
                                                let newValue2 = [ "longitude":"\(coordinate.longitude)"] as [String: Any]
                                                let newValue3 = [ "judge":"success"] as [String: Any]
                                                
                                                
                                                
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
                                                
                                                statusRef.updateChildValues(newValue3, withCompletionBlock: { (error, _) in
                                                    print("Successfully set status value")
                                                    // Update your UI
                                                    DispatchQueue.main.async {
                                                        // Do anything with your UI
                                                    }
                                                })
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    })
                                    
                                    self.ref.child("Clock").child(currentUid!).child(nowyearstr).child(nowmonthstr).child(nowdaystr).observeSingleEvent(of: .value, with: {(snapshot) in
                                        
                                        if let dataDict = snapshot.value as? [String: AnyObject]{
                                            let value = snapshot.value as? NSDictionary
                                            let clockin = value?["clockin"] as? String
                                            
                                            
                                            let alertController = UIAlertController(title: "打卡成功", message: "打卡時間" + clockin!, preferredStyle:.alert)
                                            
                                            let okAction = UIAlertAction(title: "OK", style:.default){(_) in
                                                
                                            }
                                            
                                            alertController.addAction(okAction)
                                            self.present(alertController, animated: true, completion: nil)
                                            
                                            
                                        }
                                        
                                    })

                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                else if distanceInMeters > 20 {
                                    
                                 /*   let alertController = UIAlertController(title: "打卡失敗", message: "請使用QRcode打卡", preferredStyle:.alert)
                                    
                                    let okAction = UIAlertAction(title: "繼續", style:.default){(_) in
                                        
                                        
                                        
                                    }
                                    
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)*/
                                    
                                    ////
                                    
                                    let date = Date()
                                    let calendar = Calendar.current
                                    
                                    let hour = calendar.component(.hour, from: date)
                                    let minutes = calendar.component(.minute, from: date)
                                    let seconds = calendar.component(.second, from: date)
                                    print ("\(hour):\(minutes):\(seconds)")
                                    
                                    let year = calendar.component(.year, from: date)
                                    let day = calendar.component(.day, from: date)
                                    let month = calendar.component(.month, from: date)
                                    
                                    
                                    let Date2 = ("\(year)/\(month)/\(day)")
                                    
                                    let uid = Auth.auth().currentUser?.uid
                                    self.ref.child("Clock").child(uid!).child(Date2).observeSingleEvent(of: .value , with:  { (snapshot) in
                                        
                                        if let dataDict = snapshot.value as? [String: AnyObject]{
                                            
                                            let value = snapshot.value as? NSDictionary
                                            //  let key = value?["key"] as? String ?? ""
                                            let uid2 = value?["uid"] as? String ?? ""
                                            if uid == uid2 {
                                                
                                                
                                                let statusRef = Database.database().reference().child("Clock").child(uid!).child(Date2)
                                                let newValue = [ "latitude":"\(coordinate.latitude)"] as [String: Any]
                                                let newValue2 = [ "longitude":"\(coordinate.longitude)"] as [String: Any]
                                                let newValue3 = [ "judge":"failed"] as [String: Any]
                                                
                                                
                                                
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
                                                
                                                statusRef.updateChildValues(newValue3, withCompletionBlock: { (error, _) in
                                                    print("Successfully set status value")
                                                    // Update your UI
                                                    DispatchQueue.main.async {
                                                        // Do anything with your UI
                                                    }
                                                })
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    })
                                    
                                    
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "clockinfailed")
                                    self.present(vc!, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                        
                    }
                })
            }
        })
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        timeLabel.text = formatter.string(from: clock.currentTime as Date)
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //=======iBeacon=======
    
    func registerBeaconRegionWithUUID(uuidString: String, identifier: String, isMonitor: Bool){
        
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuidString)!, identifier: identifier)
        region.notifyOnEntry = true //預設就是true
        region.notifyOnExit = true //預設就是true
        
        if isMonitor{
            locationManager.startMonitoring(for: region) //建立region後，開始monitor region
            print("ibeacon isMonitor")
        }else{
            locationManager.stopMonitoring(for: region)
            locationManager.stopRangingBeacons(in: region)
            //view.backgroundColor = UIColor.white
            //beaconInformationLabel.text = "Beacon狀態"
            
            //print("Beacon狀態")
            //beacon.text = "是否在region內?"
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        //To check whether the user is already inside the boundary of a region
        //delivers the results to the location manager’s delegate "didDetermineState"
        manager.requestState(for: region)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == CLRegionState.inside{
            if CLLocationManager.isRangingAvailable(){
                manager.startRangingBeacons(in: (region as! CLBeaconRegion))
                beacon.textColor = UIColor.green
                beacon.text = "在範圍內"
                beaconBool = true
            }else{
                print("不支援ranging")
            }
        }else{
            manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
            //view.backgroundColor = UIColor.white
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if CLLocationManager.isRangingAvailable(){
            manager.startRangingBeacons(in: (region as! CLBeaconRegion))
        }else{
            print("不支援ranging")
        }
        beacon.textColor = UIColor.green
        beacon.text = "在範圍內"
        beaconBool = true
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
        //view.backgroundColor = UIColor.white
        beacon.textColor = UIColor.red
        beacon.text = "不在範圍內"
        beaconBool = false
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if (beacons.count > 0){
            if let nearstBeacon = beacons.first{
                
                var proximity = ""
                
                switch nearstBeacon.proximity {
                case CLProximity.immediate:
                    proximity = "Very close"
                    beacon.textColor = UIColor.green
                    beacon.text = "在範圍內"
                    beaconBool = true
                    
                case CLProximity.near:
                    proximity = "Near"
                    beacon.textColor = UIColor.green
                    beacon.text = "在範圍內"
                    beaconBool = true
                    
                case CLProximity.far:
                    proximity = "Far"
                    beacon.textColor = UIColor.red
                    beacon.text = "不在範圍內"
                    beaconBool = false
                default:
                    proximity = "unknow"
                    beacon.textColor = UIColor.red
                    beacon.text = "不在範圍內"
                    beaconBool = false
                    
                }
                
                print("Proximity: \(proximity)\n Accuracy: \(nearstBeacon.accuracy) meter \n RSSI: \(nearstBeacon.rssi)")
                //view.backgroundColor = UIColor.blue
            }
        }
    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error.localizedDescription)
    }
//========
    
    
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
        
    }
}
