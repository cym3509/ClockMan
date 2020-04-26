
import UIKit
import Firebase
import EventKit



class MemberSheetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK:- Property
   
    
    var savedEventId : String = ""

    var membersheets = [memberSheet]()
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var lbMonthYearTitle: UILabel!
    
    @IBAction func worktime(_ sender: Any) {
        getworktime()
    }
    
    

    var delegate: ScheduleCalendarPickDelegate!
    var currentTab = TabType.start
    var displayComp = DateComponents()
    var displayMonthFirstWeekDay: Int = 0
    var displayMonthTotalDays: Int = 0
    var displayMonthDayArray = [DayInfo]()
    var myCurrentDate: MyDate = MyDate(year: 2000, month: 1, day: 1)
    var myDisplayDate: MyDate = MyDate(year: 2000, month: 1, day: 1)
    var mySelectStartDate: MyDate?
    
    
    let arrayWeek = [Week.sun, Week.mon, Week.tue, Week.wed, Week.thu, Week.fri, Week.sat]
    let kNumOfDaysInAWeek: Int = 7
    let kMaxRowNum: Int = 7
    
    enum TabType {
        case start
        case end
    }
    
    enum MonthType {
        case previous
        case next
    }
    
    enum Week {
        case sun
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
    }
    
    struct MyDate {
        var year: Int
        var month: Int
        var day: Int
        
    }
    
    struct DayInfo {
        var day: Int
        var isChosen: Bool
    }
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        
        ref = Database.database().reference()
       
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        
        

       
        
    }
    
    
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentDateInfo()
        setThisMonthAndYearTitle()
        currentTab = .start
        
        calendarCollectionView.reloadData()

    }
    
    // MARK:- Local method
    fileprivate func clearDisplayMonthChosenState() {
        for i in 0...displayMonthTotalDays-1 {
            displayMonthDayArray[i].isChosen = false
        }
    }
    
    fileprivate func dayBeforeToday(_ displayDate: MyDate, day: Int) -> Bool {
        // Compare two date in integer format, Ex. 2016.5.26 -> 20160526
        let displayDateInt: Int32 = Int32(displayDate.year)*10000 + Int32(displayDate.month)*100 + Int32(day)
        let currentDateInt: Int32 = Int32(myCurrentDate.year)*10000 + Int32(myCurrentDate.month)*100 + Int32(myCurrentDate.day)
        
        if displayDateInt < currentDateInt {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func firstDayOfMonth (_ date: Date) -> Date {
        let calendar = Calendar.current
        var dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: date)
        dateComponent.day = 1
        return calendar.date(from: dateComponent)!
    }
    
    fileprivate func getMonthComponent(_ type: MonthType) -> DateComponents {
        switch type {
        case .previous:
            myDisplayDate.month -= 1
            if myDisplayDate.month <= 0 {
                myDisplayDate.month = 12
                myDisplayDate.year -= 1
            }
        case .next:
            myDisplayDate.month += 1
            if myDisplayDate.month >= 13 {
                myDisplayDate.month = 1
                myDisplayDate.year += 1
            }
        }
        var dateComponent = DateComponents()
        dateComponent.year = myDisplayDate.year
        dateComponent.month = myDisplayDate.month
        dateComponent.day = 1
        return dateComponent
    }
    
    fileprivate func getTotalDaysInThisMonth(_ comp: DateComponents) -> Int {
        let calendar = Calendar.current
        let date = calendar.date(from: comp)!
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: date)
        return range.length
    }
    
    fileprivate func getWeekday(_ date: Date) -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.weekday, from: date)
        return dateComponent.weekday!
    }
    
    fileprivate func getCurrentDateInfo() {
        let currentCalendar = Calendar.current
        var comp = (currentCalendar as NSCalendar).components([.year, .month, .day], from: Date())
        
        myDisplayDate = MyDate(year: comp.year!, month: comp.month!, day: comp.day!)
        myCurrentDate = MyDate(year: comp.year!, month: comp.month!, day: comp.day!)
        
        // Set day to 1 to get the correct data
        comp.day = 1
        displayComp = comp
        getDisplayMonthInfo(comp)
    }
    
    fileprivate func getFirstWeekDayInThisMonth(_ comp: DateComponents) -> Int {
        let calendar = Calendar.current
        let date = Date(timeInterval: 0, since: calendar.date(from: comp)!)
        let weekdayInt = getWeekday(date)
        let firstWeekDay = weekdayInt - calendar.firstWeekday
        return firstWeekDay
    }
    
    fileprivate func getDisplayMonthInfo(_ comp: DateComponents) {
        displayMonthDayArray.removeAll()
        displayMonthFirstWeekDay = getFirstWeekDayInThisMonth(comp)
        displayMonthTotalDays = getTotalDaysInThisMonth(comp)
        for i in 1...displayMonthTotalDays {
            displayMonthDayArray.append(DayInfo(day: i, isChosen: false))
        }
    }
    
    fileprivate func hideDialog() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    
    fileprivate func monthMapping(_ month: Int) -> String {
        var monthString = ""
        
        switch month {
        case 1:
            monthString = "JAN"
        case 2:
            monthString = "FEB"
        case 3:
            monthString = "MAR"
        case 4:
            monthString = "APR"
        case 5:
            monthString = "MAY"
        case 6:
            monthString = "JUN"
        case 7:
            monthString = "JUL"
        case 8:
            monthString = "AUG"
        case 9:
            monthString = "SEP"
        case 10:
            monthString = "OCT"
        case 11:
            monthString = "NOV"
        case 12:
            monthString = "DEC"
        default:
            break
        }
        return monthString
    }
    
    fileprivate func setThisMonthAndYearTitle() {
        lbMonthYearTitle.text = monthMapping(myDisplayDate.month) + " " + String(myDisplayDate.year)
    }
    
    
    
    fileprivate func updateChosenDay(_ day: Int, tab: TabType) {
        clearDisplayMonthChosenState()
        
        displayMonthDayArray[day-1].isChosen = true
        
        if tab == .start {
            mySelectStartDate = MyDate(year: displayComp.year!, month: displayComp.month!, day: day)
        } else if tab == .end {
            
        }
    }
    
    fileprivate func violateEndTabRule(_ chosenDate: MyDate, startDate: MyDate) -> Bool {
        let chosenEndDateInt: Int32 = Int32(chosenDate.year)*10000 + Int32(chosenDate.month)*100 + Int32(chosenDate.day)
        let chosenStartDateInt: Int32 = Int32(startDate.year)*10000 + Int32(startDate.month)*100 + Int32(startDate.day)
        
        if chosenEndDateInt < chosenStartDateInt {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func weekMapping(_ week: Week) -> String{
        var weekString = ""
        
        switch week {
        case .sun:
            weekString = "Sun"
        case .mon:
            weekString = "Mon"
        case .tue:
            weekString = "Tue"
        case .wed:
            weekString = "Wed"
        case .thu:
            weekString = "Thu"
        case .fri:
            weekString = "Fri"
        case .sat:
            weekString = "Sat"
        }
        return weekString
    }
    
    // MARK:- Instance method
    func displayCalendarPickDialog(_ parentViewController: UIViewController) {
        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)
        self.didMove(toParentViewController: parentViewController)
    }
    
    // MARK:- Action
    
    
    
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if mySelectStartDate != nil{
            if segue.identifier == "send2"{
                if let dest = segue.destination as? MemberShowSheetViewController{
                    dest.viaYear = ("\(mySelectStartDate!.year)")
                    
                    
                    if ("\(mySelectStartDate!.month)") == "10" || ("\(mySelectStartDate!.month)") == "11" || ("\(mySelectStartDate!.month)") == "12"{
                        
                        
                        dest.viaMonth = ("\(mySelectStartDate!.month)")
                        
                        
                    }else
                    {dest.viaMonth = ("0"+"\(mySelectStartDate!.month)")}
                    
                    
                    if ("\(mySelectStartDate!.day)") == "1" || ("\(mySelectStartDate!.day)") == "2" || ("\(mySelectStartDate!.day)") == "3" || ("\(mySelectStartDate!.day)") == "4" || ("\(mySelectStartDate!.day)") == "5" || ("\(mySelectStartDate!.day)") == "6" || ("\(mySelectStartDate!.day)") == "7" || ("\(mySelectStartDate!.day)") == "8" || ("\(mySelectStartDate!.day)") == "9"{
                        
                        dest.viaDate = ("0"+"\(mySelectStartDate!.day)")
                        
                    }
                        
                    else
                    {
                        dest.viaDate = ("\(mySelectStartDate!.day)")
                    }
                    
                    
                    
                    
                }
            }
            
        }
            
        else{
            
            let alertController = UIAlertController(title:"提醒", message:"請選擇日期", preferredStyle: .alert )
            
            let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler:{
                action in print("close")
            })
            alertController.addAction(closeAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }*/
    
    
    
    fileprivate func showAlert(_ msg: String, sec: Int64) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC) * sec) / Double(NSEC_PER_SEC), execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
    
    
    @IBAction func actionPreviousMonth(_ sender: UIButton) {
        displayComp = getMonthComponent(.previous)
        getDisplayMonthInfo(displayComp)
        calendarCollectionView.reloadData()
        setThisMonthAndYearTitle()
    }
    @IBAction func actionNextMonth(_ sender: UIButton) {
        displayComp = getMonthComponent(.next)
        getDisplayMonthInfo(displayComp)
        calendarCollectionView.reloadData()
        setThisMonthAndYearTitle()
    }
    
    // MARK:- UICollectionView delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        
        
        if section == 0 {
            return kNumOfDaysInAWeek
        }
        
        
        else {
            
            return 42
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
       
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! MemberSheetCollectionViewCell
       
        
        
        
        

        if indexPath.section == 0 {
            cell.lbDate.text = weekMapping(arrayWeek[indexPath.item])
            cell.viSeparator.isHidden = false
            cell.viCellBackground.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.lbDate.textColor = UIColor.black
            
            
        }
        
        else {
            var yearmonth = lbMonthYearTitle.text
            print(yearmonth)
            
            let split = yearmonth!.components(separatedBy: " ")
            let year1 = split[1]
            let month1 = split[0]
            var monthInt = ""
            
            if(month1 == "JAN"){
                monthInt = "01"
            }
            else if(month1 == "FEB"){
                monthInt = "02"
            }
            else if(month1 == "MAR"){
                monthInt = "03"
            }
            else if(month1 == "APR"){
                monthInt = "04"
            }
            else if(month1 == "MAY"){
                monthInt = "05"
            }
            else if(month1 == "JUN"){
                monthInt = "06"
            }
            else if(month1 == "JUL"){
                monthInt = "07"
            }
            else if(month1 == "AUG"){
                monthInt = "08"
            }
            else if(month1 == "SEP"){
                monthInt = "09"
            }
            else if(month1 == "OCT"){
                monthInt = "10"
            }
            else if(month1 == "NOV"){
                monthInt = "11"
            }
            else {
                monthInt = "12"
            }
            
            print(year1)
            print(monthInt)

            
            var a = ""
            
            let uid1 = Auth.auth().currentUser?.uid
            
            ref.child("WorkDay").observe(.childAdded, with: {(snapshot) in
                
                
                
                if let dic = snapshot.value as? [String: AnyObject]{
                    
                    let yearText = dic["year"] as? String
                    let monthText = dic["month"] as? String
                    let dateText = dic["date"] as? String
                    let uidText = dic["uid"] as? String
                    
                    if (uidText == uid1 && yearText == year1 && monthText == monthInt ){
                        
                        
 
                        if(dateText == "01"){
                            a = "1"
                        }
                        else if(dateText == "02"){
                            a = "2"
                        }
                        
                        else if(dateText == "03"){
                            a = "3"
                        }
                        
                        else if(dateText == "04"){
                            a = "4"
                        }
                        
                        else if(dateText == "05"){
                            a = "5"
                        }
                            
                        else if(dateText == "06"){
                            a = "6"
                        }
                            
                        else if(dateText == "07"){
                            a = "7"
                        }
                        
                        else if(dateText == "08"){
                            a = "8"
                        }
                            
                        else if(dateText == "09"){
                            a = "9"
                        }
                        
                        else{
                           a = dateText!
                        }
                        
                        /* let membersheet = memberSheet(yearText: yearText!, monthText: monthText!, dateText: dateText!)
                         
                         self.membersheets.append(membersheet)
                         
                         self.calendarCollectionView.reloadData()*/
                        print(a)
                        
                        if (cell.lbDate.text == a){
                            cell.viCellBackground.isHidden = false
                            cell.viCellBackground.layer.cornerRadius = 5
                            cell.viCellBackground.backgroundColor = UIColor.yellow
                            
                            if(self.displayMonthDayArray[indexPath.item-self.displayMonthFirstWeekDay].isChosen){
                                
                                cell.viCellBackground.isHidden = false
                                cell.viCellBackground.layer.cornerRadius = 19
                                cell.viCellBackground.backgroundColor = UIColor.blue
                                
                            }
                            
                            
                        }
                    }
                    
                    

                    
                }
                
            })

            
           
            
            if indexPath.item < displayMonthFirstWeekDay {
                cell.lbDate.text = ""
                cell.viSeparator.isHidden = true
                cell.viCellBackground.isHidden = true
                cell.isUserInteractionEnabled = false
            } else if indexPath.item > displayMonthFirstWeekDay + displayMonthTotalDays - 1 {
                cell.lbDate.text = ""
                cell.viSeparator.isHidden = true
                cell.viCellBackground.isHidden = true
                cell.isUserInteractionEnabled = false
            }
            
            
            else {
                
                
                let day: Int = indexPath.item - displayMonthFirstWeekDay + 1
                cell.lbDate.text = String(day)
                cell.viSeparator.isHidden = false
                if dayBeforeToday(myDisplayDate, day: day) {
                    cell.isUserInteractionEnabled = true
                    cell.lbDate.textColor = UIColor.lightGray
                } else {
                    cell.isUserInteractionEnabled = true
                    cell.lbDate.textColor = UIColor.black
                }
                
               if displayMonthDayArray[indexPath.item-displayMonthFirstWeekDay].isChosen {
                    cell.viCellBackground.isHidden = false
                    cell.viCellBackground.layer.cornerRadius = 19
                    cell.viCellBackground.backgroundColor = UIColor.blue
                }
                    
                else {
                    cell.viCellBackground.isHidden = true
                }

           }
            
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = (calendarCollectionView.frame.size.width-1) / CGFloat(kNumOfDaysInAWeek)
        let collectionViewHeight = (calendarCollectionView.frame.size.height-1) / CGFloat(kMaxRowNum)
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        
        
        let chosenDay = indexPath.item - displayMonthFirstWeekDay + 1
        if currentTab == .start {
            updateChosenDay(chosenDay, tab: .start)
        } else if currentTab == .end {
            let chosenDate = MyDate(year: myDisplayDate.year, month: myDisplayDate.month, day: chosenDay)
            if violateEndTabRule(chosenDate, startDate: mySelectStartDate!) {
                showAlert("Can not earlier than start date", sec: 1)
            } else {
                updateChosenDay(chosenDay, tab: .end)
            }
        }
        
        
        collectionView.reloadData()
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        
        if (mySelectStartDate != nil ){
            // changed 2017-11-09
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "BossSheetViewController") as! BossSheetViewController
            vc.viaYear = ("\(mySelectStartDate!.year)")
            vc.viaMonth = String(format: "%02d", mySelectStartDate!.month)
            vc.viaDate = String(format: "%02d", mySelectStartDate!.day)
            vc.mode = .staff
            self.navigationController?.pushViewController(vc, animated: true)
            return
            
        /*  changed 2017-11-09
        let uid = Auth.auth().currentUser?.uid
        
        
        ref?.child("WorkDay").observe(.childAdded, with: {(snapshot) in
            
            
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let nameText = dic["name"] as? String
                let starttimeText = dic["startTime"] as? String
                let endtimeText = dic["endTime"] as? String
                let yearText = dic["year"] as? String
                let monthText = dic["month"] as? String
                let dateText = dic["date"] as? String
                let uidText = dic["uid"] as? String
                let keyText = dic["key"] as? String
                
                
                
                
                
                var viaYear = ("\(self.mySelectStartDate!.year)")
                var viaMonth = ""
                var viaDate = ""
                
                if ("\(self.mySelectStartDate!.month)") == "10" || ("\(self.mySelectStartDate!.month)") == "11" || ("\(self.mySelectStartDate!.month)") == "12"{
                    
                    
                    viaMonth = ("\(self.mySelectStartDate!.month)")
                    
                    
                }else
                {
                    viaMonth = ("0"+"\(self.mySelectStartDate!.month)")
                }
                
                
                if ("\(self.mySelectStartDate!.day)") == "1" || ("\(self.mySelectStartDate!.day)") == "2" || ("\(self.mySelectStartDate!.day)") == "3" || ("\(self.mySelectStartDate!.day)") == "4" || ("\(self.mySelectStartDate!.day)") == "5" || ("\(self.mySelectStartDate!.day)") == "6" || ("\(self.mySelectStartDate!.day)") == "7" || ("\(self.mySelectStartDate!.day)") == "8" || ("\(self.mySelectStartDate!.day)") == "9"{
                    
                    viaDate = ("0"+"\(self.mySelectStartDate!.day)")
                    
                }
                    
                else
                {
                    viaDate = ("\(self.mySelectStartDate!.day)")
                }
                
                
                
                
                
                
                
                if(uidText == uid && yearText == viaYear && monthText == viaMonth && dateText == viaDate ){
                

                
                let alertController = UIAlertController(title: viaMonth + "月" + viaDate + "日", message: "上班時間" + starttimeText! + "\n" + "下班時間" + endtimeText!, preferredStyle: .alert )
                let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler:{
                    action in print("close")
                })
                    
                   

                alertController.addAction(closeAction)
                
                self.present(alertController, animated: true, completion: nil)

                }
                
                
            }
        })
            */
        }
        
        else{
            
                
                let alertController = UIAlertController(title:"提醒", message:"請選擇日期", preferredStyle: .alert )
                
                let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler:{
                    action in print("close")
                })
            
                alertController.addAction(closeAction)
            
                self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func monthWork(){
        
        
       var yearmonth = lbMonthYearTitle.text
        print(yearmonth)
        
        let split = yearmonth!.components(separatedBy: " ")
        let year1 = split[1]
        let month1 = split[0]
        var monthInt = ""
        
        if(month1 == "JAN"){
            monthInt = "01"
        }
        else if(month1 == "FEB"){
            monthInt = "02"
        }
        else if(month1 == "MAR"){
            monthInt = "03"
        }
        else if(month1 == "APR"){
            monthInt = "04"
        }
        else if(month1 == "MAY"){
            monthInt = "05"
        }
        else if(month1 == "JUN"){
            monthInt = "06"
        }
        else if(month1 == "JUL"){
            monthInt = "07"
        }
        else if(month1 == "AUG"){
            monthInt = "08"
        }
        else if(month1 == "SEP"){
            monthInt = "09"
        }
        else if(month1 == "OCT"){
            monthInt = "10"
        }
        else if(month1 == "NOV"){
            monthInt = "11"
        }
        else {
            monthInt = "12"
        }
        
        
        
       
        let uid1 = Auth.auth().currentUser?.uid

        
        ref?.child("WorkDay").observe(.childAdded, with: {(snapshot) in
        
            if let dic = snapshot.value as? [String: AnyObject]{
            
                let yearText = dic["year"] as? String
                let monthText = dic["month"] as? String
                let dateText = dic["date"] as? String
                let uidText = dic["uid"] as? String

                if(uidText == uid1 && yearText == year1 && monthText == monthInt){
                    
                    print(snapshot)
                    
                    let membersheet = memberSheet(yearText: yearText!, monthText: monthText!, dateText: dateText!)
                    
                    self.membersheets.append(membersheet)
                    self.calendarCollectionView.reloadData()
                }
                
            }
        })
    }
    
    //notification
    
    func getworktime() {
        
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("WorkDay").observe(.childAdded, with: { (snapshot) in
            if let dic = snapshot.value as? [String: AnyObject]{
                let nameText = dic["name"] as? String
                let onString = dic["startTime"] as? String
                let offString = dic["endTime"] as? String
                let chooseyear = dic["year"] as? String
                let monthString = dic["month"] as? String
                let dateString = dic["date"] as? String
                let uidText = dic["uid"] as? String
                let inString = dic["clockin"] as? String
                
                let outString = dic["clockout"] as? String
                
                // let str = viaDate
                
                if uid == uidText {
                    
                    
                    let spliton = onString?.components(separatedBy: ":")
                    print(spliton?[0]) //09
                    print(spliton?[1]) //50
                    
                    let onhour = String((spliton?[0])!)
                    let onmin = String((spliton?[1])!)
                    
                    
                    
                    let splitoff = offString?.components(separatedBy: ":")
                    print(splitoff?[0]) //12
                    print(splitoff?[1]) //55
                    
                    let offhour = String((splitoff?[0])!)
                    let offmin = String((splitoff?[1])!)
                    
                    
                    
                    self.addwork(year: chooseyear!, month: monthString!, day: dateString!, shour: onhour!, smin: onmin! , ehour: offhour! , emin: offmin!)
                    
                    
                    let alertController = UIAlertController(title: "成功匯入行事曆", message: "", preferredStyle:.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style:.default){(_) in
                        
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                }
                
            }
            
            
            
            
            
        })
        
        
        addwork(year: "2017", month: "9", day: "24", shour: "12", smin: "00", ehour: "19", emin: "00")
        
        
        
        
    }
    
    
    
    func addwork(year: String, month: String, day: String, shour: String, smin: String, ehour: String, emin: String){
        let eventStore = EKEventStore()
        
        
        //======
        var dateComponents = DateComponents()
        let userCalendar = Calendar.current
        
        
        
        //===========StartTime===========
        dateComponents.year = Int(year)
        dateComponents.month = Int(month)
        dateComponents.day = Int(day)
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = Int(shour)
        dateComponents.minute = Int(smin)
        
        let start = userCalendar.date(from: dateComponents)
        
        
        //==========EndTime==========
        dateComponents.year = Int(year)
        dateComponents.month = Int(month)
        dateComponents.day = Int(day)
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = Int(ehour)
        dateComponents.minute = Int(emin)
        
        let end = userCalendar.date(from: dateComponents)
        
        
        
        let startDate = start
        let endDate = end
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore, title: "work!", startDate: startDate!, endDate: endDate!)
            })
        } else {
            createEvent(eventStore, title: "work!", startDate: startDate!, endDate: endDate!)
        }
        
        
        
        
    }
    
    
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "time to work"
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }
    
    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }
    
    
    
    
    
    
    
    // Responds to button to remove event. This checks that we have permission first, before removing the event responds
    // event
    @IBAction func removeEvent(_ sender: UIButton) {
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
            })
        } else {
            deleteEvent(eventStore, eventIdentifier: savedEventId)
        }
        
    }
    
    
}

