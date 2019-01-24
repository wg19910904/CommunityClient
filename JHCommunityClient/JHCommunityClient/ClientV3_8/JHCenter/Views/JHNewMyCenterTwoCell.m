//
//  JHNewMyCenterTwoCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/15.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewMyCenterTwoCell.h"
#import "YFKindItemCollectionView.h"
#import "JHTempAdvModel.h"
@interface JHNewMyCenterTwoCell()
@property(nonatomic,strong)YFKindItemCollectionView *kindItem;//八个或者更多的按钮
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleL;
@end
@implementation JHNewMyCenterTwoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = HEX(@"f1f1f1", 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatUI{
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 12, WIDTH-24, (210+(_array.count > 8 ? 25:0)))];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    _bgView.layer.cornerRadius = 8;
    _bgView.clipsToBounds = YES;

    
    _titleL = [[UILabel alloc]init];
    [_bgView addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset = 10;
        make.width.offset = 60;
        make.height.offset = 20;
    }];
    _titleL.text = @"我的订单";
    _titleL.font = FONT(14);
    
    
    
    
}
-(void)setArray:(NSArray *)array{
    _array = array;
    if(array.count<=0){
        return;
    }
    if (!_bgView) {
//        [_bgView removeFromSuperview];
        [self creatUI];
    }
    [self kindItem];
}
#pragma mark -- 🍊🍊🍊🍊🍊🍊八个或者更多的按钮
-(YFKindItemCollectionView *)kindItem{
    CGFloat h = _bgView.width/4;
    if (_array.count > 4) {
        h = _bgView.width/4 * 2 + (_array.count > 8 ? 20 : 0);
    }else if (_array.count <= 4){
        h = _bgView.width/4;
    }
    if (!_kindItem) {
        _kindItem = [[YFKindItemCollectionView alloc]initWithFrame:FRAME(0, 35, _bgView.width,210-40 +(_array.count > 8 ? 25:0)) isTool:YES];
        _kindItem.colOrLineItems = 4;
        _kindItem.backgroundColor = [UIColor whiteColor];
        __weak typeof (self)weakSelf = self;
        _kindItem.clickKindItem = ^(NSInteger index){
            if (weakSelf.myBlock) {
                weakSelf.myBlock(index);
            }
        };
        [_bgView addSubview:_kindItem];
    }
    NSMutableArray *tempArr = @[].mutableCopy;
    for (JHTempAdvModel *model in self.array) {
        NSDictionary * dic = @{@"title":model.title,@"thumb":model.icon};
        [tempArr addObject:dic];
    }
    _kindItem.dataSource = tempArr;
    return _kindItem;
}

+(NSString *)getIdentifier{
    return @"JHNewMyCenterTwoCell";
}
+(CGFloat)getHeight:(id)model{
    NSArray *arr = model;
    if (arr.count >8) {
        return 210+24+25;
    }else{
        return 210+24;
        
    }
    
    
}
@end
