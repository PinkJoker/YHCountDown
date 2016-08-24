//
//  CollectCell.h
//  YHCountDown
//
//  Created by 我叫MT on 16/8/19.
//  Copyright © 2016年 Pinksnow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTimer (YHBlocksSupport)

+ (NSTimer *)yh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;


@end

@class CollectModal;
@interface CollectCell : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIPageControl *page;
}

@property(nonatomic, strong)UICollectionView *collectView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIView *shuView;

@property(nonatomic, strong)CollectModal *modal;

@property (nonatomic, weak)NSTimer *timer;

+(CollectCell *)shareCollectCell;

@end

@interface CollectModal : NSObject

@property(nonatomic, copy)NSString *titleStr;
@property(nonatomic, copy)NSString *imageStr;


@end