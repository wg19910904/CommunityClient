//
//  JHHMRecordCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHHMRecordCell : UITableViewCell
@property (nonatomic,strong)UIView *recordBackImg;//录音背景图片
@property (nonatomic,strong)UIImageView  *recordImageAnnimation;//录音动画图片
@property (nonatomic,strong)UILabel *recordTime;//录音时长标签
@property (nonatomic,assign)int recordTimeText;
@property (nonatomic,strong)UIButton *voiceBtn;//声音按钮

@end
