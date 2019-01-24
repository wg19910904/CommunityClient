//
//  WaiMaiSpecialCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickIndex)(NSInteger index);

@interface WaiMaiSpecialCell : UITableViewCell

@property(nonatomic,copy)ClickIndex clickIndex;
-(void)reloadCellWith:(NSArray *)arr;
@end
