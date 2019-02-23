//
//  OpCardViewController.swift
//  Flash
//
//  Created by Zerui Chen on 23/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit
import SMV

class OpCardViewController: UIViewController
{
    
    var item: SMVItem!
    weak var cardsVC: CardsViewController!
    
    let cardView = UIView()
    let topTextView = UITextView()
    let bottomTextView = UITextView()
    let editButton = UIButton()
    let deleteButton = UIButton()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss)))
        setupUI()
    }
    
    func setupUI()
    {
        view.backgroundColor = nil
        // start from bottom, the edit & delete buttons
        let sCenter: [CGFloat] = [-32, 32]
        let images = [#imageLiteral(resourceName: "ic_edit"), #imageLiteral(resourceName: "ic_delete")]
        let tints = [UIColor.pBlue, .pRed]
        for (i, button) in [editButton, deleteButton].enumerated()
        {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 64 / 2
            button.backgroundColor = .white
            button.tintColor = tints[i]
            button.setImage(images[i], for: .normal)
            view.addSubview(button)
            button.widthAnchor.constraint(equalToConstant: 64).isActive = true
            button.heightAnchor.constraint(equalToConstant: 64).isActive = true
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48).isActive = true
            let displacement = sCenter[i]
            let tAnchor = displacement < 0 ? button.trailingAnchor:button.leadingAnchor
            tAnchor.constraint(equalTo: view.centerXAnchor, constant: sCenter[i]).isActive = true
            button.addShadow(ofRadius: 15)
        }
        // now the card, takes up most horizontal space
        cardView.isUserInteractionEnabled = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.addShadow(ofRadius: 15)
        view.addSubview(cardView)
        cardView.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -32).isActive = true
        cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        cardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 1.618).isActive = true
        cardView.addShadow(ofRadius: 15)
        // finally, card contents, top to bottom
        topTextView.translatesAutoresizingMaskIntoConstraints = false
        topTextView.font = .systemFont(ofSize: 42, weight: .medium)
        topTextView.textColor = .pBlue
        topTextView.textAlignment = .center
        topTextView.isEditable = false
        topTextView.isScrollEnabled = false
        cardView.addSubview(topTextView)
        topTextView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        topTextView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        topTextView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        topTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        // card contents - seperator
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0.61, alpha: 1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(separatorView)
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: topTextView.bottomAnchor, constant: 16).isActive = true
        // card contents - bottomTextView
        bottomTextView.translatesAutoresizingMaskIntoConstraints = false
        bottomTextView.font = .systemFont(ofSize: 24, weight: .regular)
        bottomTextView.textColor = .pBlue
        bottomTextView.textAlignment = .natural
        bottomTextView.isEditable = false
        cardView.addSubview(bottomTextView)
        bottomTextView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16).isActive = true
        bottomTextView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
        bottomTextView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        bottomTextView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        // lastly, fill contents
        topTextView.text = item.front
        bottomTextView.text = item.back
    }
    
    @objc func tapToDismiss()
    {
        cardsVC.fadeOutOverlay()
        dismiss(animated: true)
    }

}
