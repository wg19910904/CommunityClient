//
//  StarView.h
//  Lunch
//
//  Created by ijianghu on 15/12/9.
//  Copyright © 2015年 jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView
+(UIView *)addEvaluateViewWithStarNO:(float)starNO
                        withStarSize:(CGFloat)size
                   withBackViewFrame:(CGRect )frame;
@end
