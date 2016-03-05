//
//  ZJFlowLayout.m
//  表情键盘OC
//
//  Created by apple on 15/8/30.
//  Copyright © 2015年 zhangjing. All rights reserved.
//

#import "ZJFlowLayout.h"

@implementation ZJFlowLayout
- (void)prepareLayout {
    CGFloat w = self.collectionView.bounds.size.width / 7;
    CGFloat y = (self.collectionView.bounds.size.height - w * 3) * 0.499;
    self.itemSize = CGSizeMake(w, w);
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(y, 0, y, 0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.pagingEnabled = true;
    self.collectionView.showsHorizontalScrollIndicator = false;
}
@end
