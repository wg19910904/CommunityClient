//
//  JHPayFeeCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPayFeeCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIImageView *selectImg;//选择图片
@property (nonatomic,assign)NSIndexPath *indexPath;
@end
