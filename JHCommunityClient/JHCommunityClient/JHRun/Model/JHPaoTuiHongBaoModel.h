//
//  JHPaoTuiHongBaoModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/2/10.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPaoTuiHongBaoModel : NSObject
@property(nonatomic,strong)NSDictionary *hongbao;
@property(nonatomic,strong)NSArray *hongbaos;
@property(nonatomic,assign)BOOL isChange;
+(void)postToGetHongBaoArr:(NSString *)amount tip:(NSString *)tip block:(void(^)(JHPaoTuiHongBaoModel *model))myBlock;
@end
