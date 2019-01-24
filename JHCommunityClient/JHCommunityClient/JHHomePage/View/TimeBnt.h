//
//  TimeBnt.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/21.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeBnt : UIButton
@property (nonatomic,strong)UILabel *weekLabel;
@property (nonatomic,strong)UILabel *dayLabel;
- (id)initWithFrame:(CGRect)frame;
@end
