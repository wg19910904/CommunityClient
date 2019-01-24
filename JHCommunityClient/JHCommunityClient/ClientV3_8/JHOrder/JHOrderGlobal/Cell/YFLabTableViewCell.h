//
//  YFLabTableViewCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFBaseTableViewCell.h"

@interface YFLabTableViewCell : YFBaseTableViewCell
@property(nonatomic,assign)CGFloat centerLab_masRight;// 中间的lab相对右边边框的约束
@property(nonatomic,assign)CGFloat title_masLeft;// 左边的lab相对左边边框的约束
@property(nonatomic,assign)CGFloat rightLab_masRight;// 右边的lab相对右边边框的约束
@property(nonatomic,strong)UIColor *titleLabColor;
@property(nonatomic,strong)UIColor *centerLabColor;
@property(nonatomic,strong)UIColor *rightLabColor;
@property(nonatomic,weak)UIView *lineView;
-(void)reloadCellWithTitle:(NSString *)titleStr center:(NSString *)centerStr right:(NSString *)rightStr;
@end
