//
//  SeatNumberBottomView.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteOrder)();
typedef void(^CancleOrder)();
typedef void(^CuiOrder)();

@interface SeatNumberBottomView : UIView
@property(nonatomic,assign)SeatNumberStatus status;
@property(nonatomic,copy)CancleOrder cancleOrder;
@property(nonatomic,copy)CuiOrder cuiOrder;
@property(nonatomic,copy)DeleteOrder deleteOrder;

@property(nonatomic,assign)BOOL is_seat;//是否是订座
@end
