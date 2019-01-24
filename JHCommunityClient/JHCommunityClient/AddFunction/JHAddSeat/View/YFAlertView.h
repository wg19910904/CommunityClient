//
//  YFAlertView.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickSure)();

@interface YFAlertView : UIView
@property(nonatomic,copy)ClickSure clickSure;
@property(nonatomic,copy)NSString *desStr;
-(void)show;
-(void)hidden;
@end
