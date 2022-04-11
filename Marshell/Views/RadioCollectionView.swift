//
//  RadioCollectionView.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/6.
//

import AppKit

class RadioCollectionView: NSCollectionView {
    
    func config() {
        
    }
    
    private var flow: NSCollectionViewFlowLayout {
        let flow = NSCollectionViewFlowLayout()
        let itemSize = CGFloat(50)
        flow.itemSize = CGSize(width: itemSize, height: itemSize)
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 10
        return flow
    }
}

class RadioCollectionViewItem: NSCollectionViewItem {
    
}
