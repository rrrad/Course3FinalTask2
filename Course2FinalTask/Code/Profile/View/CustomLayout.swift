//
//  CustomLayout.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22.08.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    
    var attributes = [UICollectionViewLayoutAttributes]()
    var side: CGFloat = 0.0
    var contentWeight:CGFloat = 0.0
    var y:CGFloat = 0.0

    
    override func prepare() {
        contentWeight = collectionView!.bounds.size.width
        side = contentWeight/3
        var countX:Int = 1
        var x:CGFloat = 0.0
        
        let ii = collectionView!.numberOfItems(inSection: 0)
        for i in 0..<ii {
            let att = UICollectionViewLayoutAttributes(forCellWith: IndexPath.init(item: i, section: 0))

            if i == 0 {
                att.frame = CGRect.init(x: x, y: 0.0, width: contentWeight, height: 86.0)
                y = 86.0
            }else{
                att.frame = CGRect.init(x: x, y: y, width: side, height: side)

                if countX <= 2 {
                    x = x + side
                    countX += 1
                } else {
                    x = 0.0
                    countX = 1
                    if i != ii - 1 {
                        y = y + side
                    }
                }
            }
            attributes.append(att)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize.init(width: contentWeight, height: y + side)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttribute = [UICollectionViewLayoutAttributes]()
        for att in self.attributes {
            if att.frame.intersects(rect){
                visibleAttribute.append(att)
            }
        }
    
        return visibleAttribute
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributes[indexPath.row]
    }
    
}
