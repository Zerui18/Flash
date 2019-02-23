//
//  CardCell.swift
//  Flash
//
//  Created by Zerui Chen on 22/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit
import SMV

class CardCell: UICollectionViewCell
{
    
    let frontLabel = UILabel()
    
    /// The item displayed by this card. Only to be set in itemForIndexPath
    var item: SMVItem!
    {
        didSet
        {
            frontLabel.text = item.front
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.backgroundColor = .pBlue
        // round corners
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        // shadow
        layer.shadowColor = UIColor.shadowGrey.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.35
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
        frontLabel.translatesAutoresizingMaskIntoConstraints = false
        frontLabel.textColor = .pBlue
        frontLabel.font = .systemFont(ofSize: 32, weight: .medium)
        frontLabel.textAlignment = .center
        contentView.addSubview(frontLabel)
        frontLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        frontLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        frontLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        frontLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
