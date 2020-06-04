//
//  LayerTwoSectionHeaderView.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LayerTwoSectionHeaderView: UITableViewHeaderFooterView {
    
    static var reuseIdentifier = "LayerTwoSectionHeaderView"
    
    var checkbox: CheckBox = {
        let view = CheckBox()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .tick
        view.borderStyle = .square
        return view
    }()
    
    var titleButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.setTitle("Label", for: .normal)
        view.contentHorizontalAlignment = .left
        return view
    }()
    
    var expandImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(checkbox)
        addSubview(expandImageView)
        addSubview(titleButton)
        
        NSLayoutConstraint.activate([
            checkbox.widthAnchor.constraint(equalToConstant: 20),
            checkbox.heightAnchor.constraint(equalToConstant: 20),
            checkbox.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            checkbox.centerYAnchor.constraint(equalTo: titleButton.centerYAnchor),
            
            titleButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleButton.leftAnchor.constraint(equalTo: checkbox.rightAnchor, constant: 12),
            titleButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            titleButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            expandImageView.widthAnchor.constraint(equalToConstant: 20),
            expandImageView.heightAnchor.constraint(equalToConstant: 20),
            expandImageView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            expandImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
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
