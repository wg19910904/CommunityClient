//
//  JHHouseOrderDetailCellFive.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHHouseOrderDetailCellFive : UITableViewCell
@property(nonatomic,copy)NSString * voice_time;
@property(nonatomic,copy)NSString * voice;
@property(nonatomic,retain)UIImageView * imageVoice;
@property(nonatomic,retain)UILabel * label_time;//显示时间的
@property(nonatomic,retain)UIImageView * animationImage;
@end
