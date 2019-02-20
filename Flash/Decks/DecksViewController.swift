//
//  ViewController.swift
//  Flash
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit

/// View Controller that displays all the decks of the user in a list of cards.
class DecksViewController: UIViewController
{
    
    lazy var decksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (332 / 375) * view.bounds.width
        let itemHeight = (136 / 332) * itemWidth
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = itemWidth / 3.5
        layout.sectionInset = UIEdgeInsets(top: layout.minimumLineSpacing, left: 0, bottom: 0, right: 0)
        return layout
    }())

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout()
    {
        title = "Decks"
        view.backgroundColor = UIColor(named: "BgGrey")!
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        decksCollectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        view.addSubview(decksCollectionView)
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = Deck
    }
}
