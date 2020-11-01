//
//  ProductTableViewCell.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 09/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    static let identifier: String = "test_cell_identifier"
    
    var idLabel: UILabel!
    var typeLabel: UILabel!
    var dateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    func configure() {
        idLabel = UILabel(frame: .zero)
        self.contentView.addSubview(idLabel)
        idLabel.textAlignment = .left
        idLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(23)
        }
        
        typeLabel = UILabel(frame: .zero)
        self.contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(idLabel.snp.bottom)
            make.height.equalTo(23)
        }
        
        
        dateLabel = UILabel(frame: .zero)
        self.contentView.addSubview(dateLabel)
        dateLabel.textAlignment = .left
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(typeLabel.snp.bottom)
            make.height.equalTo(23)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(product:Product)  {
        idLabel.text =   "ID:   \(product.id)"
        typeLabel.text = "Type: \(product.type ?? "")"
        dateLabel.text = "Date: \(product.date ?? "")"
    }
}

