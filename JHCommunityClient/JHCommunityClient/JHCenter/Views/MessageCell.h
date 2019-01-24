//
//  MessageCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/3.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;//图标
@property (nonatomic,strong)UILabel *titleLabel;//标题
@property (nonatomic,strong)UILabel *detailLabel;//详细
@property (nonatomic,strong)UILabel *timeLabel;//事件
@property (nonatomic,strong)MessageModel *messageModel;
@end
