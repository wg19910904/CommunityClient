//
//  HistorySearchView.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTitle)(NSString *title);

@interface HistorySearchView : UIView

@property(nonatomic,copy)ClickTitle clickTitle;

// 添加搜索历史
-(void)searchHistoryAddStr:(NSString *)str;

// 清除搜索历史
-(void)clearSearchHistory;
@end
