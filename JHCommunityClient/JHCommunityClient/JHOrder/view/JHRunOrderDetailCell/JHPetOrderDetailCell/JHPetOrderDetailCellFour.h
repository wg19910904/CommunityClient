//
//  JHPetOrderDetailCellFour.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+NetStatus.h"
@interface JHPetOrderDetailCellFour : UITableViewCell
@property(nonatomic,assign)float height;
@property(nonatomic,copy)NSString * voice_time;
@property(nonatomic,copy)NSString * voice;
@property(nonatomic,copy)NSString * photo;
@property(nonatomic,retain)UILabel * label_request;
@property(nonatomic,retain)UIImageView * imageVoice;
@property(nonatomic,retain)UIImageView * animationImage;
@property(nonatomic,retain)UIImageView * imageV;
@end
