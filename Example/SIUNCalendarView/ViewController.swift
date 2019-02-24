//
//  ViewController.swift
//  SIUNCalendarView
//
//  Created by l-hyejin on 02/24/2019.
//  Copyright (c) 2019 l-hyejin. All rights reserved.
//

import UIKit
import SIUNCalendarView

class ViewController: UIViewController {
    
    @IBOutlet var calendarView: CalendarView!
    @IBOutlet var monthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        
        var calendarStyle: CalendarViewStyle = .init()
        calendarStyle.todayColor = .blue
        calendarStyle.dayColor = .black
        calendarStyle.weekColor = .gray
        calendarStyle.weekendColor = .red
        calendarStyle.selectedColor = .yellow
        
        calendarView.style = calendarStyle
        calendarView.style.weekType = .korean // long short normal korean
        calendarView.style.firstWeekType = .sunday
    }
    
    @IBAction func touchUpPreviousMonthButton(_ sender: Any) {
        calendarView.movePage(addMonth: -1)
    }
    
    @IBAction func touchUpNextMonthButton(_ sender: Any) {
        calendarView.movePage(addMonth: 1)
    }
}

extension ViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, currentVisibleItem date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        monthLabel.text = formatter.string(from: date)
    }
    
    func calendar(_ calendar: CalendarView, didSelectedItem date: Date) {
        print(date)
    }
}

