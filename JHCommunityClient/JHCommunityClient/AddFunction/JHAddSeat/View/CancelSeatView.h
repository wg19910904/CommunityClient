//
//  CancelSeatView.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickCancelSure)(NSString *cancelStr);

@interface CancelSeatView : UIView
@property(nonatomic,copy)ClickCancelSure clickSure;
@property(nonatomic,strong)NSArray *cancelArr;
-(void)show;
-(void)hidden;
@end
