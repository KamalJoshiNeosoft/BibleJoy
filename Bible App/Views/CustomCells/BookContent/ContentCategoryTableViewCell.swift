//
//  ContentCategoryTableViewCell.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 13/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit

protocol BonusContentDelegate: class {
   func didPressContentButton(book: LockedBook)
}

class ContentCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var sectionHeaderLabel: UILabel!

    weak var bonusContentDelegate: BonusContentDelegate?
    private var lockedBookList : [LockedBook] = []


    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        setupCollectioView()
    }
    
    func setupCollectioView() {
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        booksCollectionView.setCollectionViewLayout(layout, animated: true)
        booksCollectionView.register(UINib.init(nibName: "BonusAllContentCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BonusAllContentCollectionCell")
        booksCollectionView.collectionViewLayout.invalidateLayout()
        booksCollectionView.showsHorizontalScrollIndicator = false
    }

    func setupData(headerTitle: String, bookList :[LockedBook]) {
        sectionHeaderLabel.text = headerTitle
        lockedBookList = bookList
        booksCollectionView.reloadData()
    }
    
}


extension ContentCategoryTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lockedBookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BonusAllContentCollectionCell", for: indexPath) as? BonusAllContentCollectionCell else {  return UICollectionViewCell()  }
        let book = lockedBookList[indexPath.item]
        collectionViewCell.contentImage.image = UIImage(named: book.imageName)
        collectionViewCell.setupData(buttonText: "Read")
        collectionViewCell.layoutIfNeeded()
        collectionViewCell.setNeedsLayout()
        collectionViewCell.contentButton.tag = indexPath.row
        collectionViewCell.contentButton.addTarget(self, action: #selector(contentButtonClicked(_:)), for: .touchUpInside)
        
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.booksCollectionView.frame.size.width / 3)
        return CGSize(width: width, height: 200)
    }
}

extension ContentCategoryTableViewCell {
    
    @objc func contentButtonClicked(_ sender: UIButton) {
        let book = lockedBookList[sender.tag]
        bonusContentDelegate?.didPressContentButton(book: book)
    }
    
}
