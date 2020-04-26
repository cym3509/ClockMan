import UIKit
import Firebase

protocol ScheduleCalendarPickDelegate {
    func scheduleCalendarPickOK(_ startDate: Date)
}

class ScheduleCalendarPickDialogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK:- Property
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var lbMonthYearTitle: UILabel!
    
    
    
    @IBOutlet weak var btnOK: UIButton!
    
    
    
    
    
    
    
    
    
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
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
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
        print("selectStartDate = \(mySelectStartDate)")
        if currentTab == .start {
            if mySelectStartDate != nil {
                currentTab = .end
                clearDisplayMonthChosenState()
                calendarCollectionView.reloadData()
            } else {
                showAlert("Please select start date.", sec: 1)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(mySelectStartDate == nil){
            
            let alertController = UIAlertController(title: "Error", message:"請選擇日期", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler: {
                action in print("close")
            })
            
            alertController.addAction(closeAction)

            
        }
        else if (mySelectStartDate != nil){
        print("segue.identifier=\(segue.identifier)")
        if segue.identifier == "send"{
            if let dest = segue.destination as? BossSheetViewController{
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScheduleCalendarPickDialogCollectionViewCell
        
        if indexPath.section == 0 {
            cell.lbDate.text = weekMapping(arrayWeek[indexPath.item])
            cell.viSeparator.isHidden = false
            cell.viCellBackground.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.lbDate.textColor = UIColor.black
        } else {
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
            } else {
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
                    cell.viCellBackground.layer.cornerRadius = 5
                } else {
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
