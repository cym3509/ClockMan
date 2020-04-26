import UIKit
import Firebase



class BossHolidaySettingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK:- Property
    
    
    
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var lbMonthYearTitle: UILabel!
    
    
    
    @IBOutlet weak var btnOK: UIButton!
    
     var ref: DatabaseReference!
    

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
    
    
    @IBAction func actionOK(_ sender: UIButton) {
        
        var year = ""
        var month = ""
        var date = ""
        
        year = ("\(mySelectStartDate!.year)")
        
        
        if ("\(mySelectStartDate!.month)") == "10" || ("\(mySelectStartDate!.month)") == "11" || ("\(mySelectStartDate!.month)") == "12"{
            month = ("\(mySelectStartDate!.month)")
        }
        else
        {
            month = ("0"+"\(mySelectStartDate!.month)")
        }
        
        
        if ("\(mySelectStartDate!.day)") == "1" || ("\(mySelectStartDate!.day)") == "2" || ("\(mySelectStartDate!.day)") == "3" || ("\(mySelectStartDate!.day)") == "4" || ("\(mySelectStartDate!.day)") == "5" || ("\(mySelectStartDate!.day)") == "6" || ("\(mySelectStartDate!.day)") == "7" || ("\(mySelectStartDate!.day)") == "8" || ("\(mySelectStartDate!.day)") == "9"{
            
            date = ("0"+"\(mySelectStartDate!.day)")
            
        }
            
        else
        {
            date = ("\(mySelectStartDate!.day)")
        }
        
        let alertController = UIAlertController(title: year+"年"+month+"月"+date+"日", message:"設定/刪除國定假日", preferredStyle:.alert)
        
        let updateAction = UIAlertAction(title: "設定", style: .default){(_) in
            
            let key = self.ref.child("Holiday").childByAutoId().key
            
            self.ref.child("Holiday").child(year).child(month).child(date).setValue(
                [
                    "year": year,
                    "month": month,
                    "date": date
                ])
        }
        
        let deleteAction = UIAlertAction(title: "刪除", style: .default){(_) in
            
            let deleteRef = Database.database().reference().child("Holiday").child(year).child(month).child(date).setValue(nil)
            
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dest = Storyboard.instantiateViewController(withIdentifier: "BossHolidaySettingViewController") as! BossHolidaySettingViewController
            
            
            self.navigationController?.pushViewController(dest, animated: true)
            
            
        }
        
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        
        
        present(alertController, animated: true, completion: nil)
        
    
        
       /* var year = ""
        var month = ""
        var date = ""
        
        year = ("\(mySelectStartDate!.year)")
        
        
        if ("\(mySelectStartDate!.month)") == "10" || ("\(mySelectStartDate!.month)") == "11" || ("\(mySelectStartDate!.month)") == "12"{
            
            
            month = ("\(mySelectStartDate!.month)")
            
            
        }
        else
        {
            month = ("0"+"\(mySelectStartDate!.month)")
        }
        
        
        if ("\(mySelectStartDate!.day)") == "1" || ("\(mySelectStartDate!.day)") == "2" || ("\(mySelectStartDate!.day)") == "3" || ("\(mySelectStartDate!.day)") == "4" || ("\(mySelectStartDate!.day)") == "5" || ("\(mySelectStartDate!.day)") == "6" || ("\(mySelectStartDate!.day)") == "7" || ("\(mySelectStartDate!.day)") == "8" || ("\(mySelectStartDate!.day)") == "9"{
            
            date = ("0"+"\(mySelectStartDate!.day)")
            
        }
            
        else
        {
            date = ("\(mySelectStartDate!.day)")
        }
        
        let key = ref.child("Holiday").childByAutoId().key

        ref.child("Holiday").child(year).child(month).child(date).setValue(
            [
              "year": year,
              "month": month,
              "date": date
            ])
        
        let alertController = UIAlertController(title:year+"年"+month+"月"+date+"日", message:"已設定為國定假日", preferredStyle: .alert )
        let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler:{
            action in print("close")
        })
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
        
        */
    }
  
    
    
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
        } else {
            return kNumOfDaysInAWeek*(kMaxRowNum-1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "holidaycell", for: indexPath) as! HolidaySettingCollectionViewCell
        
        if indexPath.section == 0 {
            cell.lbDate.text = weekMapping(arrayWeek[indexPath.item])
            cell.viSeparator.isHidden = false
            cell.viCellBackground.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.lbDate.textColor = UIColor.black
        } else {
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
            
            
            
            ref.child("Holiday").child(year1).child(monthInt).observe(.childAdded, with: {(snapshot) in
                
                
                
                if let dic = snapshot.value as? [String: AnyObject]{
                    
                    let yearText = dic["year"] as? String
                    let monthText = dic["month"] as? String
                    let dateText = dic["date"] as? String
                   
                    
                    if (yearText == year1 && monthText == monthInt ){
                        
                        
                        
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
                            cell.viCellBackground.layer.cornerRadius = 19
                            cell.viCellBackground.backgroundColor = UIColor.yellow
                            
                            /*if(self.displayMonthDayArray[indexPath.item-self.displayMonthFirstWeekDay].isChosen){
                                
                                cell.viCellBackground.isHidden = false
                                cell.viCellBackground.layer.cornerRadius = 19
                                cell.viCellBackground.backgroundColor = UIColor.blue
                                
                            }*/
                            
                            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
}
