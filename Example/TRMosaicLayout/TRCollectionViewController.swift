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

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        
        mosaicLayout.delegate = self
        fetchBooks()
    }
    
    func fetchBooks() {
        let url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=subject:science%20fiction")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if let _ = data,
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData( data!, options:[]) as? NSDictionary {
                let items = responseDictionary["items"] as! [NSDictionary]
                self.books = items.flatMap {
                    $0.valueForKeyPath("volumeInfo.imageLinks.thumbnail") as! String
                }
                self.collectionView?.reloadData()
            }
        });
        task.resume()
    }
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if !books.isEmpty {
            let imageView = UIImageView()
            imageView.setImageWithURL(NSURL(string: books[indexPath.item % books.count])!, placeholderImage: nil)
            imageView.frame = cell.frame
            cell.backgroundView = imageView
        }
        
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
