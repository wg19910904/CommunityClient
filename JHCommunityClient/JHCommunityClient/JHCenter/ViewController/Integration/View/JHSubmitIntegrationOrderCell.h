//
//  JHSubmitIntegrationOrderCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSubmitIntegrationOrderCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,strong)UILabel *number;//剩余数量
@property (nonatomic,strong)UIButton *addBnt;
@property (nonatomic,strong)UIButton *subBnt;
@property (nonatomic,strong)UILabel *buyNumber;//购买数量
@property (nonatomic,strong)NSDictionary *dataDic;//数据源
@end
