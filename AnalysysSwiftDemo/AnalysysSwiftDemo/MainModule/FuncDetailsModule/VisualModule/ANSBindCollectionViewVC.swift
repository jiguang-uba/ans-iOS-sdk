//
//  ANSBindCollectionViewVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class ANSBindCollectionViewVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var ans_collection: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collection: UICollectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collection.allowsMultipleSelection = true
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib.init(nibName: "ANSBindCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ANSBindCollectionCell")
        collection.register(UINib.init(nibName: "ANSBindCollectionHeaderFooterView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ANSBindCollectionHeaderFooterView")
        
        self.view.addSubview(collection)
        self.ans_collection = collection
        
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView?
        if kind == UICollectionView.elementKindSectionHeader {
            let collectionHeader:ANSBindCollectionHeaderFooterView  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ANSBindCollectionHeaderFooterView", for: indexPath) as! ANSBindCollectionHeaderFooterView
            collectionHeader.sectionLab.text = "Section:\(indexPath.section)"
            reusableView = collectionHeader
        }
        return reusableView!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ANSBindCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ANSBindCollectionCell", for: indexPath) as! ANSBindCollectionCell
        cell.titleLab.text = "section:\(indexPath.section)-row:\(indexPath.row)"
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //
    }
}
