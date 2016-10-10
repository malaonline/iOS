//
//  SubjectFilterView.swift
//  mala-ios
//
//  Created by Elors on 1/16/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class SubjectFilterView: BaseFilterView {

    // MARK: - Property
    var subjects: [GradeModel]? = nil {
        didSet {
            self.reloadData()
        }
    }
    
    
    // MARK: - Constructed
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, didTapCallBack: @escaping FilterDidTapCallBack) {
        super.init(frame: frame, collectionViewLayout: layout, didTapCallBack: didTapCallBack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        MalaFilterIndexObject.subjectIndexPath = indexPath
        didTapCallBack?(self.subjects![(indexPath as NSIndexPath).row])
    }
    
    
    // MARK: - DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subjects?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FilterViewSectionFooterReusedId, for: indexPath)
        return sectionFooterView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterViewCellReusedId, for: indexPath) as! FilterViewCell
        cell.model = subjects![(indexPath as NSIndexPath).row]
        
        if indexPath == MalaFilterIndexObject.subjectIndexPath as IndexPath {
            cell.isSelected = true
        }
        
        return cell
    }
}
