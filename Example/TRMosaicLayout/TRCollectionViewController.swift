//
//  TRCollectionViewController.swift
//  TRMosaicLayout
//
//  Created by Vincent Le on 7/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import TRMosaicLayout
import AFNetworking

private let reuseIdentifier = "TRMosaicCell"

class TRCollectionViewController: UICollectionViewController {
    
//     let books = ["norwegianwood", "norwegianwood2", "windupbird", "windupbird2", "running"]
    
    var books = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        
        mosaicLayout.delegate = self
        fetchBooks()
    }
    
    func fetchBooks() {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=subject:science%20fiction")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let _ = data,
                let responseDictionary = try! JSONSerialization.jsonObject( with: data!, options:[]) as? NSDictionary {
                let items = responseDictionary["items"] as! [NSDictionary]
                self.books = items.flatMap {
                    $0.value(forKeyPath: "volumeInfo.imageLinks.thumbnail") as? String
                }
                self.collectionView?.reloadData()
            }
        });
        task.resume()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if !books.isEmpty {
            let imageView = UIImageView()
            imageView.setImageWith(URL(string: books[indexPath.item % books.count])!, placeholderImage: nil)
            imageView.frame = cell.frame
            cell.backgroundView = imageView
        }
        
        return cell
    }
}

extension TRCollectionViewController: TRMosaicLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }
}
