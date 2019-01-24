//
//  JHHeadLinesVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/16.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHHeadLinesVC.h"
 

@interface JHHeadLinesVC (){
    NSMutableArray *titleDataArr;
}

@end

@implementation JHHeadLinesVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX(@"f2f2f2", 1);
     self.navigationItem.title = NSLocalizedString(@"头条",nil);
    titleDataArr = @[].mutableCopy;
    [self getData];
}

-(void)initData{
    
    
    self.cbs_titleArray = @[].mutableCopy;


    self.cbs_titleArray = titleDataArr;
    self.cbs_viewArray = @[].mutableCopy;
    for (NSInteger i=0; i<titleDataArr.count; i++) {
        [self.cbs_viewArray addObject:@"JHRecommendedView"];
    }

 
    self.cbs_Type = CBSSegmentHeaderTypeScroll;
    self.cbs_headerColor = [UIColor whiteColor];
    self.cbs_bottomLineColor = THEME_COLOR;
    self.cbs_buttonHeight = 50;
    [self initSegment];
}

- (void)didSelectSegmentIndex:(NSInteger)index
{
    NSLog(@"%ld", (long)index);
}
-(void)getData{
    
    [HttpTool postWithAPI:@"client/headline/index/index" withParams:@{@"cat_id":@"0"} success:^(id json) {
        NSLog(@"client/headline/index/index------%@",json);
        
        if ([json[@"error"] isEqualToString:@"0"]) {
            [titleDataArr removeAllObjects];
            for (NSDictionary *dic in json[@"data"][@"cat_items"]) {
                [titleDataArr addObject:dic];
            }
            [self initData];
        }else{
            [self showMsg:json[@"message"]];
        }
     
        
        
    } failure:^(NSError *error) {
        [self showMsg:NSLocalizedString(@"服务器繁忙,请稍后再试",nil)];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
   
}
@end
