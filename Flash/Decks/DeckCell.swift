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
    private let descriptionLabel = UILabel()
    private let statusIndicator = UIView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        // setup nameLabel
        nameLabel.font = .systemFont(ofSize: 27, weight: .medium)
        nameLabel.textColor = UIColor(named: "PrimaryBlue")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        // setup descriptionLabel
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = UIColor(named: "PrimaryGrey")
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        // setup statusIndicator
        statusIndicator.layer.cornerRadius = 7.5
        statusIndicator.backgroundColor = UIColor(named: "PrimaryBlue")
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
    var color: UIColor
    {
        switch self
        {
        case .high:
            return UIColor(named: "PrimaryRed")!
        case .medium:
            return UIColor(named: "PrimaryOrange")!
        case .low:
            return UIColor(named: "PrimaryBlue")!
        }
    }
}
