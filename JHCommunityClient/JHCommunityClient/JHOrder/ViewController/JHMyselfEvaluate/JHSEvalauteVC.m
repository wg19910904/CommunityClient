//
//  JHSEvalauteVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSEvalauteVC.h"
#import "JHSEvaluateCell.h"
#import "JHSEvaluateModel.h"
 
@interface JHSEvalauteVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
    float height_evaluate;
    float height_replay;
    JHSEvaluateModel * detailModel;
}
@end

@implementation JHSEvalauteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //这是发送请求的方法
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是发送请求的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"client/member/order/comment_info" withParams:@{@"order_id":self.order_id} success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            detailModel = [JHSEvaluateModel creatJHSEvaluateModelWithDictionary:json[@"data"][@"comment"]];
            if (detailModel.imageArray.count == 0) {
                self.isPhoto = NO;
            }else{
                self.isPhoto = YES;
            }
            if (detailModel.reply.length == 0) {
                self.isReplay = NO;
            }else{
                self.isReplay = YES;
            }
            if (myTableView == nil) {
                [self creatUITableView];
            }else{
                [myTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"我的评价", nil);
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [myTableView registerClass:[JHSEvaluateCell class] forCellReuseIdentifier:@"cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    height_evaluate = [detailModel.content boundingRectWithSize:CGSizeMake(WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height*1.5;
    NSString * str_replay = [NSString stringWithFormat:NSLocalizedString(@"回复:%@", nil),detailModel.reply];
    height_replay = [str_replay boundingRectWithSize:CGSizeMake(WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height*1.5;
    NSInteger a = 0;
    if (_isZiti) {
        a = -50;
    }
    if (self.isPhoto && self.isReplay) {
        return 80 + 50 + 115 + height_evaluate + 10 + height_replay + 150 + (WIDTH - 70)/4+a;
    }else if(!self.isPhoto && self.isReplay){
        return 80 + 50 + 115 + height_evaluate + 10 + height_replay + 150+a;
    }else if(self.isPhoto && !self.isReplay){
        return 80 + 50 + 115 + height_evaluate  + 110 + (WIDTH - 70)/4+a;

    }else{
        return 80 + 50 + 115 + height_evaluate + 100+a;

    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHSEvaluateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.isReplay = self.isReplay;
    cell.isPhoto = self.isPhoto;
    cell.height_replay = height_replay;
    cell.height_evaluate = height_evaluate;
    cell.isZiti = self.isZiti;
    cell.model = detailModel;
    return cell;
}
@end
