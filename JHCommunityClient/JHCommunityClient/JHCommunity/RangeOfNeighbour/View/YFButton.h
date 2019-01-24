//
//  YFButton.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFButton : UIButton
@property(nonatomic,strong)UIFont *titleFont;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *imgName;
@property(nonatomic,assign)float adjustImgMargin;

@end
