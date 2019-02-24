//
//  CalendarView.swift
//  SIUNCalendarView
//
//  Created by 이혜진 on 2019. 2. 24..
//

import Foundation
import UIKit

// MARK: - CalendarViewDelegate

@objc
public protocol CalendarViewDelegate: class {
    @objc optional func calendar(_ calendar: CalendarView, currentVisibleItem date: Date)
    @objc optional func calendar(_ calendar: CalendarView, didSelectedItem date: Date)
}

// MARK: - CalendarView

public class CalendarView: UIView {
    
    // MARK: - Property
    
    public weak var delegate: CalendarViewDelegate? {
        didSet {
            setPageFirstView()
        }
    }
    
    public var pageContainerView: UIView?
    public var pageController: UIPageViewController?
    public var currentVisibleDate: Date = .init()
    
    public var style: CalendarViewStyle = .init()
    
    // MARK: - Initialization
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        pageController?.view.frame = bounds
        setPageFirstView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: style.scrollOrientation,
                                              options: nil)
        guard let pageController = pageController else { return }
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.frame = bounds
        pageController.delegate = self; pageController.dataSource = self
        setPageFirstView()
        addSubview(pageController.view)
        
        findParentViewController(self)?.addChild(pageController)
    }
    
    // MAKR: - Method
    
    private func setPageFirstView() {
        guard let pageController = pageController else { return }
        if let firstPageController = pageViewController(date: currentVisibleDate) {
            pageController.setViewControllers(
                [firstPageController],
                direction: .forward,
                animated: false,
                completion: nil
            )
            
            delegate?.calendar?(self, currentVisibleItem: currentVisibleDate)
        }
    }
    
    public func movePage(to date: Date?,
                         shouldSelectedDay: Bool = false) {
        if let viewController = pageController?
            .viewControllers?.first as? CalendarMonthViewController {
            guard let toDate = date,
                let fromDate = viewController.visibleMonthFirstDay else { return }
            setNextPageView(fromDate: fromDate, toDate: toDate,
                            shouldSelectedDay: shouldSelectedDay)
        }
    }
    
    public func movePage(addMonth count: Int) {
        if let viewController = pageController?
            .viewControllers?.first as? CalendarMonthViewController {
            guard let toDate = viewController.getDate(addMonth: count),
                let fromDate = viewController.visibleMonthFirstDay else { return }
            setNextPageView(fromDate: fromDate, toDate: toDate)
        }
    }
    
    private func setNextPageView(fromDate: Date, toDate: Date,
                                 shouldSelectedDay: Bool = false) {
        let direction: UIPageViewController.NavigationDirection = fromDate > toDate ? .reverse : .forward
        let visibleDateString = fromDate.toString(of: .noDay)
        let dateToMoveString = toDate.toString(of: .noDay)
        
        guard let nextPageController = pageViewController(date: toDate,
                                                          shouldSelectedDay: shouldSelectedDay) else { return }
        pageController?.setViewControllers(
            [nextPageController],
            direction: direction,
            animated: visibleDateString != dateToMoveString,
            completion: nil
        )
        delegate?.calendar?(self, currentVisibleItem: toDate)
    }
    
    private func findParentViewController(_ view: UIView) -> UIViewController? {
        if let nextResponder = view.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = view.next as? UIView {
            return findParentViewController(nextResponder)
        } else {
            return nil
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension CalendarView: UIPageViewControllerDelegate {
    private func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = previousViewControllers
            .first as? CalendarMonthViewController {
            viewController.isVisible = false
        }
        
        if let viewController = pageViewController
            .viewControllers?.first as? CalendarMonthViewController {
            viewController.isVisible = true
            
            guard let date = viewController.visibleMonthFirstDay else { return }
            delegate?.calendar?(self, currentVisibleItem: date)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension CalendarView: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CalendarMonthViewController else { return nil }
        let previousDate = viewController.getDate(addMonth: -1)
        return self.pageViewController(date: previousDate)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CalendarMonthViewController else { return nil }
        let nextDate = viewController.getDate(addMonth: 1)
        return self.pageViewController(date: nextDate)
    }
    
    private func pageViewController(date: Date?, shouldSelectedDay: Bool = false) -> UIViewController? {
        guard let date = date else { return nil }
        
        let viewController = CalendarMonthViewController()
        viewController.delegate = delegate
        viewController.superFrame = bounds
        viewController.style = style
        
        viewController.setCurrentVisibleMonth(date: date, shouldSelectedDay: shouldSelectedDay)
        return viewController
    }
}
