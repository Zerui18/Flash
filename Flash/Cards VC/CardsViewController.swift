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
        let itemWidth = view.bounds.width / 2
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.618)
        return layout
    }())

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
        cardsCollectionView.allowsMultipleSelection = true
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
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.animateFlip(isSelected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.animateFlip(isSelected: false)
    }
}
