//
//  JHHouseKeepingEvaluationVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//阿姨详情中的评价页面

#import "JHBaseVC.h"

@interface JHHouseKeepingEvaluationVC : JHBaseVC
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,strong)NSArray *commentsArray;
@property (nonatomic,strong)NSArray *commentsaArray;
@property (nonatomic,strong)NSArray *commentsbArray;
@property (nonatomic,strong)NSArray *commentscArray;
@property (nonatomic,strong)NSDictionary *countDic;
@end
