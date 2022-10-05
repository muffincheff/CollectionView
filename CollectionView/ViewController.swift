//
//  ViewController.swift
//  CollectionView
//
//  Created by orca on 2020/06/14.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndcator: UIActivityIndicatorView!
    
    // MARK: Properties
    var images = [UIImage(named: "image-1"), UIImage(named: "image-2"), UIImage(named: "image-3"), UIImage(named: "image-4"), UIImage(named: "image-5"), UIImage(named: "image-6"), UIImage(named: "image-7")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test!
        testFn()
        
        if let layout = self.collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func testFn() {
        let imgur: ImgurAPI = ImgurAPI()
        //imgur.athenticate()
        imgur.authorization()
    }
}


// MARK:- Flow Layout
//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        // item width
//        let viewWidth: CGFloat = collectionView.frame.size.width
//        let columCount: CGFloat = 2
//        let xInsets: CGFloat = 10
//        let cellSpacing: CGFloat = 5
//        let itemWidth = (viewWidth / columCount) - (xInsets + cellSpacing)
//
//        // item height
//        let imgHeight = images[indexPath.item]!.size.height
//        let imgWidth = images[indexPath.item]!.size.width
//        // itemWidth : imgWidth =    ?     : imgHeight
//        //     2     :    10    =    20    :    100
//        // imgHeight / imgWidth * itemWidth = ?
//        let itemHeight = imgHeight / imgWidth * itemWidth
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//}

extension ViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {

//        let image = images[indexPath.item]
//        guard let itemHeight = image?.size.height else { return 0 }
        
        let itemHeight = getItemSize(columnCount: 2, itemIndex: indexPath.item).height
        return itemHeight
    }
    
    func getItemSize(columnCount: CGFloat, itemIndex: Int) -> CGSize {
        // item width
        let viewWidth: CGFloat = collectionView.frame.size.width
        let xInsets: CGFloat = 10
        let cellSpacing: CGFloat = 5
        let itemWidth = (viewWidth / columnCount) - (xInsets + cellSpacing)
    
        // item height
        let imgHeight = images[itemIndex]!.size.height
        let imgWidth = images[itemIndex]!.size.width
        // itemWidth : imgWidth =    ?     : imgHeight
        //     2     :    10    =    20    :    100
        // imgHeight / imgWidth * itemWidth = ?
        let itemHeight = imgHeight / imgWidth * itemWidth
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}


// MARK:- CollectionView DataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    
    
}

// MARK:- CollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped \(indexPath.item) cell")
        
//        RequestToImgur.shared.requestBlizzardAuth()
//        RequestToImgur.shared.getCards()
        
        
        self.performSegue(withIdentifier: "segue_webview", sender: self)
        self.collectionView.snapshotView(afterScreenUpdates: true)
          
        
        /*
        guard let url = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=0078dd924520584&response_type=token"), UIApplication.shared.canOpenURL(url)
            else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        */
    }
    
    
}

