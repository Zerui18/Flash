//
//  DeckCell.swift
//  Flash
//
//  Created by Zerui Chen on 20/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit
import SMV

class DeckCell: UICollectionViewCell
{
    
    var set: SMVSet!
    {
        didSet
        {
            nameLabel.text = set.name
            descriptionLabel.text = set.detail
            statusIndicator.backgroundColor = set.urgency.color
        }
    }
    
    private let nameLabel = UILabel()
    private let descriptionLabel = TopAlignedLabel()
    private let statusIndicator = UIView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        // round corners
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.shadowGrey.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.35
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
        // setup nameLabel
        nameLabel.font = .systemFont(ofSize: 27, weight: .medium)
        nameLabel.textColor = .pBlue
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        // setup descriptionLabel
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = .textGrey
        descriptionLabel.numberOfLines = 3
        descriptionLabel.contentMode = .topLeft
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        
        // setup statusIndicator
        statusIndicator.layer.cornerRadius = 7.5
        statusIndicator.backgroundColor = .pBlue
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusIndicator)
        statusIndicator.widthAnchor.constraint(equalToConstant: 15).isActive = true
        statusIndicator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        statusIndicator.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8).isActive = true
        statusIndicator.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        statusIndicator.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError()
    }
}

extension SMVSet.Urgency
{
    var color: UIColor?
    {
        switch self
        {
        case .high:
            return .pRed
        case .medium:
            return .pOrange
        case .low:
            return nil
        }
    }
}

class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: textRect)
    }
}
