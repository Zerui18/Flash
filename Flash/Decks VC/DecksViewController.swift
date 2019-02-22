//
//  ViewController.swift
//  Flash
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit
import SMV

/// View Controller that displays all the decks of the user in a list of cards.
class DecksViewController: UIViewController
{
    
    lazy var decksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (332 / 375) * view.bounds.width
        let itemHeight = (136 / 332) * itemWidth
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = itemHeight / 4
        layout.sectionInset = UIEdgeInsets(top: layout.minimumLineSpacing, left: 0, bottom: 0, right: 0)
        return layout
    }())
    let addButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout()
    {
        title = "Decks"
        decksCollectionView.alwaysBounceVertical = true
        decksCollectionView.backgroundColor = .bgGrey
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        decksCollectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        decksCollectionView.register(DeckCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(decksCollectionView)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 64 / 2
        addButton.backgroundColor = .pBlue
        addButton.tintColor = .white
        addButton.setImage(#imageLiteral(resourceName: "baseline_add_white_48pt"), for: .normal)
        addButton.layer.masksToBounds = false
        addButton.addShadow(ofRadius: 15)
        view.addSubview(addButton)
        addButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }

}

extension DecksViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return SMVEngine.shared.sets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DeckCell
        cell.set = SMVEngine.shared.sets[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardsVC = CardsViewController()
        cardsVC.set = SMVEngine.shared.sets[indexPath.item]
        navigationController!.pushViewController(cardsVC, animated: true)
    }
}
