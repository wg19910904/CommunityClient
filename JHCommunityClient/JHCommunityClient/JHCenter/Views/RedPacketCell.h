//
//  RedPacketCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"
@interface RedPacketCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *limitLabel;
@property (nonatomic,strong)UILabel *timeLable;
@property (nonatomic,strong)UILabel *typeLable;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *amount;
@property (nonatomic,strong)RedPacketModel *redPacketModel;
- (void)setRedPacketModel:(RedPacketModel *)redPacketModel selectRedPacket:(BOOL)selectRedPacket;
@end
