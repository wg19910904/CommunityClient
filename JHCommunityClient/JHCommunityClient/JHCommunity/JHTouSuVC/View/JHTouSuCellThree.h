//
//  JHTouSuCellThree.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTouSuCellThree : UITableViewCell
@property (nonatomic,strong)NSMutableArray *imgArray;
@property (nonatomic,strong)NSMutableArray *imgDataArray;
@property (nonatomic,strong)UIButton *addImgBnt;
@property (nonatomic,strong)UIView *imgBackView;
@property (nonatomic,copy)void(^refreshImgCellBlock)(NSArray *imgArray,NSArray *imgDataArray);
- (void)setImgArray:(NSArray *)imgArray imgDataArray:(NSArray *)imgDataArray;
@end
