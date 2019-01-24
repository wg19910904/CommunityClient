//
//  MyCollectionPersonCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionPersonModel.h"
#import "StarView.h"
@interface MyCollectionPersonCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *type;
@property (nonatomic,strong)UILabel *length;
@property (nonatomic,strong)UIView *starView;
@property (nonatomic,strong)UILabel *experience;
@property (nonatomic,strong)UILabel *service;
@property (nonatomic,strong)UIImageView *dirImg;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *labelArray;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *label3;
@property (nonatomic,strong)UILabel *label4;
@property (nonatomic,strong)MyCollectionPersonModel *myCollectionPersonModel;
@end
