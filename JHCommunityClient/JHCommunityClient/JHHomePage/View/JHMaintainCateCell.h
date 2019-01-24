//
//  JHHouseKeepingCateCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅分类列表中的单元格

#import <UIKit/UIKit.h>
@interface JHMaintainCateCell : UITableViewCell
@property (nonatomic,strong,nullable)UILabel *titleLbel;
@property (nonatomic,strong,nullable)UIImageView *iconImg;
@property (nonnull,strong)UIImageView *dirImg;
@end
