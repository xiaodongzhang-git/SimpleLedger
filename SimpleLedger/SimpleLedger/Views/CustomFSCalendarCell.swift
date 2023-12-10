//
//  CustomFSCalendarCell.swift
//  SimpleLedger
//
//  Created by xiaodong zhang on 2023/12/10.
//

import SwiftUI
import FSCalendar

class CustomFSCalendarCell: FSCalendarCell {
    let amountLabel = UILabel()

    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        setupAmountLabel()
    }

    override init!(frame: CGRect) {
        super.init(frame: frame)
        setupAmountLabel()
    }

    private func setupAmountLabel() {
        contentView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            amountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        amountLabel.font = UIFont.systemFont(ofSize: 10)
    }

    func setAmount(_ amount: Double) {
        amountLabel.text = String(format: "%.2f", amount)
    }
}

