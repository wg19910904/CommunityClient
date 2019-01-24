//
//  TempHomeChannelCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "TempHomeChannelCell.h"
#import "YFKindItemCollectionView.h"
#import "JHTempAdvModel.h"
@interface TempHomeChannelCell()
@property(nonatomic,strong)YFKindItemCollectionView *kindItem;//八个或者更多的按钮
@end
@implementation TempHomeChannelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACK_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setArray:(NSArray *)array{
    _array = array;
   // [_kindItem removeFromSuperview];
   // _kindItem = nil;
    [self kindItem];
}
#pragma mark -- 🍊🍊🍊🍊🍊🍊八个或者更多的按钮
-(YFKindItemCollectionView *)kindItem{
    CGFloat h = WIDTH/4;
    if (_array.count > 5) {
        h = WIDTH/4 * 2 + (_array.count > 10 ? 20 : 0);
    }else if (_array.count <= 5){
        h = WIDTH/4;
    }
    if (!_kindItem) {
        _kindItem = [[YFKindItemCollectionView alloc]initWithFrame:FRAME(0, 0, WIDTH,h)];
        _kindItem.colOrLineItems = 5;
        _kindItem.backgroundColor = [UIColor whiteColor];
               __weak typeof (self)weakSelf = self;
        _kindItem.clickKindItem = ^(NSInteger index){
            if (weakSelf.myBlock) {
                weakSelf.myBlock(index);
            }
        };
        [self addSubview:_kindItem];
    }
    _kindItem.height = h;
    NSMutableArray *tempArr = @[].mutableCopy;
    for (JHTempAdvModel *model in self.array) {
        NSDictionary * dic = @{@"title":model.title,@"thumb":model.thumb};
        [tempArr addObject:dic];
    }
    _kindItem.dataSource = tempArr;
    return _kindItem;
}
@end
