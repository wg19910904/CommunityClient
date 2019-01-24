//
//  JHPublishImgCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPublishImgCell : UITableViewCell
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIView *imgView;
@property (nonatomic,strong)NSMutableArray *imgArray;
@property (nonatomic,strong)NSMutableArray *imgDataArray;
@property (nonatomic,strong)UIButton *addImgBnt;
@property (nonatomic,copy)void(^refreshImgCellBlock)(NSArray *imgArray,NSArray *imgDataArray);
- (void)setImgArray:(NSArray *)imgArray imgDataArray:(NSArray *)imgDataArray;
@end
