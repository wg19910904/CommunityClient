//
//  TakeawayOrderProgressCellTwo.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTakewayProgressModel.h"
@interface TakeawayOrderProgressCellTwo : UITableViewCell
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,retain)NSMutableArray * infoArray;
@property(nonatomic,retain)JHTakewayProgressModel * model;
@property(nonatomic,retain)UIButton * btn_call;//打电话
@property(nonatomic,retain)UIImageView * imageView_head;
@property(nonatomic,retain)UILabel * label_praogressOne;//创建第一根进度线
@property(nonatomic,retain)UILabel * label_praogressTwo;//创建第二根进度线
@end
