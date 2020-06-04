//
//  CheckBox+States.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

enum CheckBoxState {
    case none
    case indeterminate
    case checked
}

extension CheckBox {
    
    func setCheckedBorderColor(state: CheckBoxState) {
        switch state {
        case .checked:
            checkedBorderColor = UIColor.systemGreen
            checkmarkColor = UIColor.systemGreen
        case .indeterminate:
            tintColor = UIColor.systemYellow
            checkmarkColor = UIColor.systemYellow
        case .none:
            tintColor = UIColor.systemRed
            checkmarkColor = UIColor.systemRed
        }
    }
}
