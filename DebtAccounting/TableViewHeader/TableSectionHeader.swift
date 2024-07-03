//
//  TableSectionHeader.swift
//  DebtAccounting
//
//  Created by Никита Цепляев on 03.07.2024.
//

import UIKit

final class TableSectionHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = "CellHeader"
    
    private let tittleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        tittleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.addSubview(tittleLabel)
        tittleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tittleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func setDataInHeader(text: String) {
        tittleLabel.text = text
    }
}
