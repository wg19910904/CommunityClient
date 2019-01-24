//
//  WaiMaiHomeKindCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "WaiMaiHomeKindCell.h"
#import "YFKindItemCollectionView.h"

@interface WaiMaiHomeKindCell ()
@property(nonatomic,strong)YFKindItemCollectionView *kindItem;
@end


@implementation WaiMaiHomeKindCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark -- 🍊🍊🍊🍊🍊🍊八个或者更多的按钮
-(YFKindItemCollectionView *)kindItem:(NSArray *)array{
    if (!_kindItem) {
        //        CGFloat h = 190*(WIDTH/375);
        //        if (array.count >10) {
        //            h = 190*(WIDTH/375) + 20;
        //        }
        CGFloat h = WIDTH/4;
        if (array.count > 5) {
            h = WIDTH/4 * 2 + (array.count > 10 ? 20 : 0);
        }else if (array.count <= 5){
            h = WIDTH/4;

        }
        _kindItem = [[YFKindItemCollectionView alloc]initWithFrame:FRAME(0, 0, WIDTH,h)];
        _kindItem.colOrLineItems = 5;
        _kindItem.backgroundColor = [UIColor whiteColor];
        __weak typeof (self)weakSelf = self;
        _kindItem.clickKindItem = ^(NSInteger index){
            if (weakSelf.clickIndex) {
                weakSelf.clickIndex(index);
            }
        };
        [self addSubview:_kindItem];
        _kindItem.dataSource = array.mutableCopy;
    }
    return _kindItem;
}

-(void)reloadCellWith:(NSArray *)arr{
    [_kindItem removeFromSuperview];
    _kindItem = nil;
    [self kindItem:arr];
}

@end
