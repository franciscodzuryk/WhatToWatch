//
//  UIButton+Extensions.swift
//  WhatToWatch
//
//  Created by Luis Francisco Dzuryk on 28/12/2022.
//  Copyright © 2022 Fran. All rights reserved.
//

import UIKit

extension UIButton {
    static func pickerButton(_ target: Any?, action: Selector) -> UIButton {
        let iconImage = UIImage(named: "picker_icon")?.tinted(with: .white)
        let button = UIButton(type: .custom)
        button.setImage(iconImage, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
