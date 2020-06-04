//
//  LayerThreeCheckBoxTableViewCell.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LayerThreeCheckBoxTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LayerThreeCheckBoxTableViewCell"
    
    var checkbox: CheckBox = {
        let view = CheckBox()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .tick
        view.borderStyle = .square
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Label"
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Label"
        return view
    }()
    
    var countLabel: UILabel = {
       let view = UILabel()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.text = "Label"
       return view
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(checkbox)
        contentView.addSubview(countLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            checkbox.widthAnchor.constraint(equalToConstant: 20),
            checkbox.heightAnchor.constraint(equalToConstant: 20),
            checkbox.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 20),
            checkbox.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            countLabel.topAnchor.constraint(equalTo: checkbox.bottomAnchor, constant: 12),
            countLabel.centerXAnchor.constraint(equalTo: checkbox.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: checkbox.rightAnchor, constant: 12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
