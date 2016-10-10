//
//  GradeFilterView.swift
//  mala-ios
//
//  Created by Elors on 1/16/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class GradeFilterView: BaseFilterView {

    // MARK: - Property
    override var grades: [GradeModel]? {
        didSet {
            reloadData()
        }
    }
    
    
    // MARK: - Constructed
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, didTapCallBack: @escaping FilterDidTapCallBack) {
        super.init(frame: frame, collectionViewLayout: layout, didTapCallBack: didTapCallBack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        if indexPath == MalaFilterIndexObject.gradeIndexPath as IndexPath {
            cell.isSelected = true
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        MalaFilterIndexObject.gradeIndexPath = indexPath
        didTapCallBack?(self.gradeModel((indexPath as NSIndexPath).section, row: (indexPath as NSIndexPath).row)!)
    }
}
