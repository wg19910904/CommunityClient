//
//  JHCartCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHCartCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UIButton *subBtn;
@property (nonatomic,strong)UILabel *num;
@property (nonatomic,copy)NSDictionary *dataDic;
@end
