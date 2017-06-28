//
//  CommonFlowLayout.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class CommonFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Property
    enum FlowLayoutType {
        case findTeacherView
        case filterView
        case subjectView
        case gradeSelection
        case profileItem
        case detailPhotoView
        case `default`
        case featureView
        case liveCourseService
    }
    
    
    // MARK: - Constructed
    init(type layoutType: FlowLayoutType, frame: CGRect? = nil) {
        super.init()
        
        // 根据Type来应用对应的布局样式
        switch layoutType {
        case .findTeacherView:      findTeacherViewFlowLayout()
        case .filterView:           filterViewFlowLayout()
        case .subjectView:          subjectViewFlowLayout()
        case .gradeSelection:       gradeSelectionFlowLayout()
        case .profileItem:          profileItemFlowLayout()
        case .detailPhotoView:      detailPhotoViewFlowLayout()
        case .default:              defaultLayout(frame: frame)
        case .featureView:          featureViewLayout()
        case .liveCourseService:    liveCourseServiceLayout()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func findTeacherViewFlowLayout() {
        scrollDirection = .vertical
        let itemWidth: CGFloat = MalaScreenWidth*0.47
        let itemHeight: CGFloat = itemWidth*1.28
        let itemMargin: CGFloat = MalaScreenWidth*0.02
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumInteritemSpacing = itemMargin
        minimumLineSpacing = itemMargin
        sectionInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin)
    }
    
    private func filterViewFlowLayout() {
        scrollDirection = .vertical
        let itemWidth: CGFloat = MalaLayout_FilterItemWidth
        let itemHeight: CGFloat = 38.0
        let itemMargin: CGFloat = 0.0
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumInteritemSpacing = itemMargin
        minimumLineSpacing = itemMargin
        sectionInset = UIEdgeInsetsMake(itemMargin/2, itemMargin, itemMargin/2, itemMargin)
        headerReferenceSize = CGSize(width: 100, height: 34)
        footerReferenceSize = CGSize(width: 100, height: 30)
    }
    
    private func subjectViewFlowLayout() {
        scrollDirection = .vertical
        let itemWidth: CGFloat = MalaLayout_FilterItemWidth-10
        let itemHeight: CGFloat = 38.0
        let itemMargin: CGFloat = 0.0
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumInteritemSpacing = itemMargin
        minimumLineSpacing = itemMargin
        sectionInset = UIEdgeInsetsMake(itemMargin/2, itemMargin, itemMargin/2, itemMargin)
        headerReferenceSize = CGSize(width: 100, height: 0)
        footerReferenceSize = CGSize(width: 100, height: 0)
    }
    
    private func gradeSelectionFlowLayout() {
        scrollDirection = .vertical
        let itemWidth = MalaLayout_GradeSelectionWidth
        let itemHeight: CGFloat = MalaLayout_GradeSelectionWidth*0.19
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        minimumInteritemSpacing = 12
        minimumLineSpacing = 14
    }
    
    private func profileItemFlowLayout() {
        scrollDirection = .horizontal
        let itemWidth = MalaScreenWidth / 3
        let itemHeight: CGFloat = 114
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    private func detailPhotoViewFlowLayout() {
        scrollDirection = .horizontal
        let itemWidth: CGFloat = MalaLayout_DetailPhotoWidth
        let itemHeight: CGFloat = MalaLayout_DetailPhotoWidth
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 2
    }
    
    private func defaultLayout(frame: CGRect?) {
        scrollDirection = .horizontal
        if let frame = frame { itemSize = frame.size }
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    private func featureViewLayout() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: MalaLayout_FeatureViewWidth, height: MalaLayout_FeatureViewHeight)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    private func liveCourseServiceLayout() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: MalaLayout_LiveCourseCardWidth/3, height: 34)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}
