//
//  RestView.h
//  JHCommunityClient
//
//  Created by jianghu1 on 16/10/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BackBlock)();
@interface RestView : UIView
@property(nonatomic,copy)BackBlock backBlock;
- (void)show;
@end
