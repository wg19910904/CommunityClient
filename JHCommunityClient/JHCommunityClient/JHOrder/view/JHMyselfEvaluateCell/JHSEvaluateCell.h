//
//  JHSEvaluateCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSEvaluateModel.h"
@interface JHSEvaluateCell : UITableViewCell
@property(nonatomic,retain)JHSEvaluateModel * model;
@property(nonatomic,assign)float height_evaluate;
@property(nonatomic,assign)float height_replay;
@property(nonatomic,assign)BOOL isReplay;
@property(nonatomic,assign)BOOL isPhoto;
@property(nonatomic,assign)BOOL isZiti;
@end
