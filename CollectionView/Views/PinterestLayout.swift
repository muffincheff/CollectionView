/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    //1. Pinterest Layout Delegate
    weak var delegate: PinterestLayoutDelegate!
    
    //2. Configurable properties
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 5
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        //print("PinterestLayout::collectionViewContentSize")
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // 1. Only calculate once
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        //print("PinterestLayout::prepare")
        
        // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        // 2. ?????? ?????? ?????? X ???????????? ?????? ???????????? ??? ?????? ?????? ?????? ?????? Y ???????????? ??????????????? ?????? ????????? ???????????????
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // 3. Iterates through the list of items in the first section
        // 3. ??? ?????? ????????? ?????? ????????? ???????????????.
        var i = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            // 4. ??????????????? ????????? ????????? ????????? ???????????? ??? ???????????? ???????????????.
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            // 5. ?????????????????? UICollectionViewLayoutItem??? ????????? ????????? ???????????????.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6. Updates the collection view content height
            // 6. ????????? ??? ????????? ????????? ?????????????????????
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
            
            //print("PinterestLayout::prepare - item count in first section : \(i)")
            i += 1
        }
        
        i = 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        //print("PinterestLayout::layoutAttributesForElements")
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
//                print("PinterestLayout::layoutAttributesForElements - intersect!")
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    /*
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //print("PinterestLayout::layoutAttributesForItem")
        return cache[indexPath.item]
    }
    */
}

