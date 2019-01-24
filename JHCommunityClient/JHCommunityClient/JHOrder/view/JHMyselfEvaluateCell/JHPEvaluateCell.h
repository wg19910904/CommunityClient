//
//  JHPEvaluateCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPEvaluateModel.h"
#import "StarView.h"
@interface JHPEvaluateCell : UITableViewCell
@property(nonatomic,retain)JHPEvaluateModel * model;
@property(nonatomic,assign)float height_evaluate;
@property(nonatomic,assign)float height_replay;
@property(nonatomic,assign)BOOL isReplay;
@property(nonatomic,assign)BOOL isPhoto;
@end
