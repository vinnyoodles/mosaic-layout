//
//  TRCollectionViewController.swift
//  TRMosaicLayout
//
//  Created by Vincent Le on 7/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import TRMosaicLayout

private let reuseIdentifier = "TRMosaicCell"

class TRCollectionViewController: UICollectionViewController {
    
    let books = ["norwegianwood", "norwegianwood2", "windupbird", "windupbird2", "running"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        
        mosaicLayout.delegate = self
        
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
       return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let image = UIImage(named: books[indexPath.item % books.count])
        let imageView = UIImageView(image: image)
        
        imageView.frame = cell.frame
        
        cell.backgroundView = imageView
        
        return cell
    }
}

extension TRCollectionViewController: TRMosaicLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:NSIndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.Big : TRMosaicCellType.Small
    }
    
    func collectionView(collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }
}
