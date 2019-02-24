//
//  CollectionView+SIUNCalendarView.swift
//  SIUNCalendarView
//
//  Created by 이혜진 on 2019. 2. 24..
//

import UIKit

protocol CollectionViewCellType {
    static var identifier: String { get }
}

extension UICollectionViewCell: CollectionViewCellType{
    static var identifier: String {
        return String(describing: self.self)
    }
}

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(_ reusableCell: Cell.Type) {
        let nib = UINib(nibName: reusableCell.identifier, bundle: Bundle(identifier: "org.cocoapods.SIUNCalendarView"))
        register(nib, forCellWithReuseIdentifier: reusableCell.identifier)
    }
    
    func register<Cell: UICollectionViewCell>(_ reuseableCells: [Cell.Type]) {
        reuseableCells.forEach { (cell) in
            register(cell)
        }
    }
    
    func dequeue<Cell: UICollectionViewCell>(_ reusableCell: Cell.Type,
                                             for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reusableCell.identifier,
                                             for: indexPath) as? Cell else {
                                                return Cell()
        }
        return cell
    }
}

