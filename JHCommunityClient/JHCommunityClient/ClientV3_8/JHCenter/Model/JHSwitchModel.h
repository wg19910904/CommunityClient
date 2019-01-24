//
//  JHSwitchModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHSwitchModel : NSObject
@property (nonatomic,copy)NSString *netWorkOn;//设置2G/3G/4G网络下显示列表照片
//@property (nonatomic,copy)NSString *pushStatus;//消息推送设置;
@property (nonatomic,assign)BOOL netWorkStatus;//当前网络状态是否为2G/3G/4G
/**
 *首先取到netWorkOn,如果netWorkOn = yes,可以直接网络接在图片
 *如果netWorkOn = no,再判断netWorkStatus,如果netWorkStatus = yes不可以加载网络图片,netWorkStatus = no,可以加载图片
 */
+ (JHSwitchModel *)shareModel;
@end
