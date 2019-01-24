//
//  ChooseCommunityCell.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineCommunityModel.h"
#import "JHBaseVC.h"
typedef void(^DeleteAddr)();
typedef void(^ChangeAddr)();

@interface ChooseCommunityCell : UITableViewCell
@property(nonatomic,copy)DeleteAddr deleteAddr;
@property(nonatomic,copy)ChangeAddr changeAddr;
@property (nonatomic,strong)JHBaseVC *vc;
@property (nonatomic,strong)MineCommunityModel *model;
-(void)reloadCellWithModel:(MineCommunityModel *)model withVC:(JHBaseVC *)vc;

@end
