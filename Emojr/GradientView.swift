//
//  GradientView.swift
//  Emojr
//
//  Created by James on 3/24/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension UIView {
    struct Constants {
        static let gradientStartColor: UIColor = .clear // #00000 .red
        static let gradientEndColor: UIColor = .darkGray // #00000
    }
    
    func gradientMeSon() {
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [Constants.gradientStartColor.cgColor, Constants.gradientEndColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
