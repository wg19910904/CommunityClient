//
//  JHPayFeeBillDetailFrameModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHPayFeeBillListModel.h"
@interface JHPayFeeBillDetailFrameModel : NSObject
@property (nonatomic,assign)CGFloat wuYeFeeHeight;
@property (nonatomic,assign)CGFloat waterFeeHeight;
@property (nonatomic,assign)CGFloat dianFeeHeight;
@property (nonatomic,assign)CGFloat gasFeeHeight;
@property (nonatomic,assign)CGFloat cheWeiHeight;
@property (nonatomic,assign)CGFloat totalViewHeight;
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,strong)JHPayFeeBillListModel *payFeeBillListModel;
@end
