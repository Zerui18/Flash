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
    
    class CardView: UIView
    {
        let frontLabel = UILabel()
        let backLabel = UILabel()
        
        init()
        {
            super.init(frame: .zero)
            backgroundColor = .white
            layer.cornerRadius = 5
            addShadow(ofRadius: 5)
            for label in [frontLabel, backLabel]
            {
                label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 10
                addSubview(label)
                label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
                label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
            frontLabel.font = .systemFont(ofSize: 32, weight: .medium)
            frontLabel.textAlignment = .center
            frontLabel.textColor = .pBlue
            backLabel.font = .systemFont(ofSize: 18, weight: .medium)
            backLabel.textAlignment = .left
            backLabel.textColor = .textBlue
            backLabel.isHidden = true
        }
        
        required init?(coder aDecoder: NSCoder)
        {
            fatalError("init(coder:) has not been implemented")
        }
        
        func add(to superView: UIView)
        {
            translatesAutoresizingMaskIntoConstraints = false
            superView.addSubview(self)
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 16).isActive = true
            topAnchor.constraint(equalTo: superView.topAnchor, constant: 16).isActive = true
            centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        }
    }
    
    /// The item displayed by this card. Only to be set in itemForIndexPath
    var item: SMVItem!
    {
        didSet
        {
            card.frontLabel.text = item.front
            card.backLabel.text = item.back
        }
    }
    
    override var isSelected: Bool
    {
        didSet
        {
            if isSelected
            {
                card.frontLabel.isHidden = true
                card.backLabel.isHidden = false
            }
            else
            {
                card.frontLabel.isHidden = false
                card.backLabel.isHidden = true
            }
        }
    }
    
    let card = CardView()
    
    /// Animate 'flipping' the card, given the new isSelected value caused by the same event that calls this function.
    func animateFlip(isSelected: Bool)
    {
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.backgroundColor = .pBlue
        card.add(to: self)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
