//
//  JHAddSeatHeaderVeiw.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAddSeatModel.h"
@protocol  JHAddSeatHeaderVeiwDelegate<NSObject>
@optional
-(void)clickTimeWithTag:(NSInteger)tag;
@end
@interface JHAddSeatHeaderVeiw : UITableViewHeaderFooterView
@property(nonatomic,retain)JHAddSeatModel *model;
@property(nonatomic,assign)id<JHAddSeatHeaderVeiwDelegate>delegate;
@end
