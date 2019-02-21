//
//  UIView+Extension.swift
//  Flash
//
//  Created by Zerui Chen on 21/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit

extension UIView
{
    func addShadow(ofRadius radius: CGFloat)
    {
        layer.masksToBounds = false
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.shadowGrey.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = radius
    }
}
