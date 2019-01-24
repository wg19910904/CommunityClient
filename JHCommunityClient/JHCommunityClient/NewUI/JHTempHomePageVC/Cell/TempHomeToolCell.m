//
//  TempHomeToolCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "TempHomeToolCell.h"
#import "YFKindItemCollectionView.h"
#import "JHTempAdvModel.h"
@interface TempHomeToolCell()
@property(nonatomic,strong)UIView *bgView;//背景View
@property(nonatomic,strong)UILabel *titleL;//标题
@property(nonatomic,strong)UIView *label_lineTop;//顶部的分割线
@property(nonatomic,strong)YFKindItemCollectionView *kindItem;//八个或者更多的按钮
@end
@implementation TempHomeToolCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACK_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //背景View
        [self bgView];
        //标题
        [self titleL];
        //顶部的分割线
        [self label_lineTop];
    }
    return self;
}
//背景View
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 10;
            make.left.offset = 0;
            make.right.offset = -0;
            make.bottom.offset = -10;
        }];
    }
    return _bgView;
}
//标题
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = NSLocalizedString(@"常用工具", nil);
        _titleL.font = FONT(16);
        _titleL.textColor = HEX(@"1d1c1c", 1);
        [_bgView addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.height.offset = 20;
            make.top.offset = 14;
        }];
    }
    return _titleL;
}
//顶部的分割线
-(UIView *)label_lineTop{
    if (!_label_lineTop) {
        _label_lineTop = [[UIView alloc]init];
        _label_lineTop.backgroundColor = HEX(@"dedede", 1);
        [_bgView addSubview:_label_lineTop];
        [_label_lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.right.offset = -0;
            make.top.offset = 43.5;
            make.height.offset = 0.5;
        }];
    }
    return _label_lineTop;
}
-(void)setArray:(NSMutableArray *)array{
    _array = array;
    [self kindItem];
}
#pragma mark -- 八个或者更多的按钮
-(YFKindItemCollectionView *)kindItem{
    CGFloat height_collectionV = 220;
    if (self.array.count <= 4) {
        height_collectionV = 110;
    }
    if (!_kindItem) {
        _kindItem = [[YFKindItemCollectionView alloc]initWithFrame:FRAME(0, 44, WIDTH,height_collectionV) isTool:YES];
        _kindItem.colOrLineItems = 4;
        _kindItem.backgroundColor = [UIColor whiteColor];
        __weak typeof (self)weakSelf = self;
        _kindItem.clickKindItem = ^(NSInteger index){
            if (weakSelf.clickToolBlock) {
                weakSelf.clickToolBlock(index);
            }
        };
        [_bgView addSubview:_kindItem];
    }
    _kindItem.dataSource = @[].mutableCopy;
    _kindItem.height = height_collectionV;
    _kindItem.y = 44;
    for (int i = 0; i < self.array.count; i++) {
        JHTempAdvModel *model = self.array[i];
        NSDictionary * dic = @{@"title":model.title,@"thumb":model.thumb};
        [_kindItem.dataSource addObject:dic];
    }
    return _kindItem;
}
@end
