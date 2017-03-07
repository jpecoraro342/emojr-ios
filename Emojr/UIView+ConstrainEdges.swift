//
//  UIView+ConstrainEdges.swift
//  Emojr
//
//  Created by James on 3/6/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

extension UIView {
    func constrainToEdges(of view: UIView, leftConstant: CGFloat = 0, topConstant: CGFloat = 0, rightConstant: CGFloat = 0, bottomConstant: CGFloat = 0) {
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftConstant).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant).isActive = true
    }
}
