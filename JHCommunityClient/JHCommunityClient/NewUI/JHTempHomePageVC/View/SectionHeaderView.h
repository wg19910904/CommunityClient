//
//  SectionHeaderView.h
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/24.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UITableViewHeaderFooterView
@property(nonatomic,copy)void(^myBlock)(NSInteger tag);
@property(nonatomic,assign)BOOL isNew;//是否是头条
@end
