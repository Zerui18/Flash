//
//  CardsViewController.swift
//  Flash
//
//  Created by Zerui Chen on 21/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit
import SMV

class CardsViewController: UIViewController
{
    
    var set: SMVSet!
    lazy var cardsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let layout = UICollectionViewFlowLayout()
        // calculate dimensions to layout 2 cards per row, with equal spacing
        let spacing: CGFloat = 20
        let itemWidth = (view.bounds.width - spacing * 3) / 2
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        // golden ratio :) hope this looks better
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.618)
        return layout
    }())
    /// Add card button.
    let addButton = UIButton()
    /// Overlay to be shown when card is 'opened'
    lazy var darkenOverlay: UIView = {
        let v = UIView()
        v.frame = view.bounds
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        return v
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI()
    {
        view.backgroundColor = .pBlue
        navigationItem.title = set.name
        navigationController!.navigationBar.shadowImage = UIImage()
        // setup collectionView
        cardsCollectionView.register(CardCell.self, forCellWithReuseIdentifier: "cell")
        cardsCollectionView.alwaysBounceVertical = true
        cardsCollectionView.backgroundColor = .pBlue
        cardsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        cardsCollectionView.indicatorStyle = .white
        view.addSubview(cardsCollectionView)
        cardsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cardsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cardsCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        cardsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 64 / 2
        addButton.backgroundColor = .white
        addButton.tintColor = .pBlue
        addButton.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
        addButton.layer.masksToBounds = false
        addButton.addShadow(ofRadius: 15)
        view.addSubview(addButton)
        addButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        // keeps overlay in front of navbar
        navigationController!.view.addSubview(darkenOverlay)
    }
    
    func fadeOutOverlay()
    {
        UIView.animate(withDuration: 0.5) {
            self.darkenOverlay.alpha = 0
        }
    }

}

extension CardsViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return set.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
        cell.item = set[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: false)
        // init OpCardVC with item
        let item = set[indexPath.item]
        let opCardVC = OpCardViewController()
        opCardVC.modalPresentationStyle = .overCurrentContext
        opCardVC.item = item
        opCardVC.cardsVC = self
        // fade-in darkenOverlay
        UIView.animate(withDuration: 0.5) {
            self.darkenOverlay.alpha = 1
        }
        // present OpCardVC
        present(opCardVC, animated: true)
    }
}
