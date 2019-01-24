//
//  JHProductDetailCellTwo.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHProductDetailCellTwo : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,copy)NSDictionary *dataDic;
@property(nonatomic,strong)UIButton *subtractBtn;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UILabel *numLabel;
@property (nonatomic,retain)NSMutableArray *btnArray;
@property (nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *label_no;
@end
