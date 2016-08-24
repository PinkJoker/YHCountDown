//
//  CollectCell.m
//  YHCountDown
//
//  Created by 我叫MT on 16/8/19.
//  Copyright © 2016年 Pinksnow. All rights reserved.
//

#import "CollectCell.h"
#import "CollectionViewCell.h"
#define count 3

@implementation NSTimer(YHBlocksSupport)

+(NSTimer *)yh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(yh_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+(void)yh_blockInvoke:(NSTimer *)timer
{
    void(^block)( ) = timer.userInfo;
    if (block) {
        block();
    }
}

@end



@interface CollectCell ()


@end


@implementation CollectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatMyView];
    }
    return self;
}

-(void)creatMyView
{__weak __typeof(&*self)weakSelf = self;
    self.shuView = [[UIView alloc]init];
    [self.contentView addSubview:self.shuView];
    self.shuView.backgroundColor = [UIColor redColor];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.backgroundColor = [UIColor magentaColor];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = @"图片展示";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.shuView.mas_centerY);
        make.left.mas_equalTo(weakSelf.shuView.mas_right).offset(5);
    }];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
   // flowLayout.minimumInteritemSpacing = 20;
    //flowLayout.itemSize = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>)
   flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.collectView];
    self.collectView.backgroundColor = [UIColor cyanColor];
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    CGFloat collectHeight =(  sWidth /3 *1 - 20 )*0.6;
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.shuView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(collectHeight);
       // make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(20);
    }];
    self.collectView.contentSize = CGSizeMake(sWidth*3, 0);
    self.collectView.pagingEnabled = YES;
    self.collectView.showsHorizontalScrollIndicator = NO;
    [self.collectView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    page = [[UIPageControl alloc]init];
    page.numberOfPages = 3;
    page.currentPage = 0;
    page.pageIndicatorTintColor = [UIColor grayColor];
    page.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.contentView addSubview:page];
    [page addTarget:self action:@selector(slidePage:) forControlEvents:UIControlEventValueChanged];
    
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.collectView.mas_bottom).offset(10);
       // make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];

    [self addTimer];

}

- (void)addTimer{
    __weak __typeof(&*self)weakSelf = self;
    self.timer = [NSTimer yh_scheduledTimerWithTimeInterval:5 block:^{
        [weakSelf nextImage];
    } repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)pauseTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)nextImage {
    CGFloat width = sWidth;
    NSInteger index = page.currentPage;
    if (index == count ) {
        index = 0;
    } else {
        index++;
    }
    [self.collectView setContentOffset:CGPointMake((index + 1) * width, 0)animated:YES];
}


-(void)slidePage:(UIPageControl *)pageA
{
    
    NSInteger pageNumber = pageA.currentPage;
    
    [self.collectView setContentOffset:CGPointMake(sWidth*pageNumber, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = sWidth;
    int index = (self.collectView.contentOffset.x + width *0.5)/width;
    if (index == count+1 ) {
        [self.collectView setContentOffset:CGPointMake(width, 0) animated:NO];
    }else if (index == 0){
        [self.collectView setContentOffset:CGPointMake(count *width, 0) animated:NO];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat width = sWidth;
    int index = (self.collectView.contentOffset.x + width *0.5)/width;
    if (index == count +1) {
        index = 1;
    }else if(index == 0 ){
        index = count-1;
    }
    page.currentPage = index - 1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseTimer];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"------------");
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"啥时候调用");
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束拖拽");
    __weak __typeof(self)weakSelf = self;
    [self pauseTimer];
    dispatch_after(DISPATCH_TIMER_STRICT, dispatch_get_main_queue(), ^{
           [weakSelf addTimer];
    });
    
}



-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = sWidth /3 *1 - 20;
    return CGSizeMake(width, width *0.6);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    [self pauseTimer];
    __weak __typeof(self)weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf addTimer];
//    });
}

-(void)setModal:(CollectModal *)modal
{
    _modal = modal;
    
    self.titleLabel.text = modal.titleStr;
    
}
-(void)dealloc
{
    NSLog(@"进入释放");

    [self pauseTimer];
}

+(CollectCell *)shareCollectCell
{
    static CollectCell *shareCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCell = [[CollectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectcell"];
    });
    return shareCell;
}

@end


@implementation CollectModal



@end
