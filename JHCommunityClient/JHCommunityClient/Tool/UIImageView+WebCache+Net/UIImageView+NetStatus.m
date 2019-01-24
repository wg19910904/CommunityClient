//
//  UIImageView+NetStatus.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/7.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "UIImageView+NetStatus.h"
#import "JHSwitchModel.h"
#import <UIImageView+WebCache.h>
@implementation UIImageView (NetStatus)
- (void)sd_image:(NSURL *)url plimage:(UIImage *)image
{
//    JHSwitchModel * model = [JHSwitchModel shareModel];
//    if(/* DISABLES CODE */ (YES)) {
        [self sd_setImageWithURL:url placeholderImage:image];
//    }
//    else{
//        if(model.netWorkStatus)
//        {
//            [self sd_setImageWithURL:nil placeholderImage:image];
//        }
//        else
//        {
//            [self sd_setImageWithURL:url placeholderImage:image];
//        }
//    }
}
@end
