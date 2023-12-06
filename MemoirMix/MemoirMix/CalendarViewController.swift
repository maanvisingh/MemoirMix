//
//  CalendarViewController.swift
//  MemoirMix
//
//  Created by student1 on 22/11/23.
//

import UIKit
class CalendarViewController: UIViewController,UICalendarSelectionSingleDateDelegate   {
    var tempDate:Date?
    var receivedUser:String?
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        guard let dateComponents = dateComponents,
                  let date = Calendar.current.date(from: dateComponents) else { return }
        tempDate=date
        self.performSegue(withIdentifier: "goToEntry", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendarView = UICalendarView(frame: UIScreen.main.bounds)
        let greCalendar = Calendar (identifier: .gregorian)
        let selection=UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior=selection
        calendarView.calendar = greCalendar
        self.view.addSubview (calendarView)
        calendarView.tintColor = .red
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToEntry"{
            if let navigationVC = segue.destination as? UINavigationController,
               let destinationVC = navigationVC.topViewController as? NoteTableView{
                destinationVC.receivedDate=tempDate
                
                if let navigationVC = segue.destination as? UINavigationController,
                   let destinationVC = navigationVC.topViewController as? NoteTableView{
                    destinationVC.receivedUser=receivedUser
                }
            }
            }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
