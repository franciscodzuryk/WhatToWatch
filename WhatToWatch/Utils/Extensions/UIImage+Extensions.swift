//
//  UIImage+Extensions.swift
//  WhatToWatch
//
//  Created by Luis Francisco Dzuryk on 28/12/2022.
//  Copyright © 2022 Fran. All rights reserved.
//

import UIKit

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
}
