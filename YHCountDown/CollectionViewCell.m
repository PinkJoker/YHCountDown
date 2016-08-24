//
//  CollectionViewCell.m
//  YHCountDown
//
//  Created by 我叫MT on 16/8/20.
//  Copyright © 2016年 Pinksnow. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatMyView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatMyView];
    }
    return self;
}

-(void)creatMyView
{
    self.iconImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconImage];
    self.iconImage.backgroundColor = [UIColor yellowColor];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


@end
