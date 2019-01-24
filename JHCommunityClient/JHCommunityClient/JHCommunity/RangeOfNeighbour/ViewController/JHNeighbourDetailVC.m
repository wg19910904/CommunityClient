//
//  JHNeighbourDetailVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHNeighbourDetailVC.h"
#import "YFTextView.h"
#import "JHNeighbourCell.h"
#import "NeighbourCommentCell.h"
#import <IQKeyboardManager.h>
#import <MJRefresh.h>
#import "JHShareModel.h"

@interface JHNeighbourDetailVC()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)YFTextView *inputTextView;
@property(nonatomic,weak)UIView *bottomView;
@property(nonatomic,weak)UIButton *telBtn;
@property(nonatomic,weak)UIButton *talkBtn;
@property(nonatomic,assign)BOOL is_scroll;
@property(nonatomic,strong)NeighbourModel *model;
@property(nonatomic,strong)NSMutableDictionary *replyInfoDic;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,weak)UIButton *answerBnt;
@end

@implementation JHNeighbourDetailVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.view.backgroundColor=BACK_COLOR;
    self.navigationItem.title=@"圈子详情";
    [self setUpNavi];
    [IQKeyboardManager sharedManager].enable=NO;
    [self getTiebaDetail];
    
    self.page=1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybodDidShow) name:UIKeyboardDidShowNotification object:nil];
}

-(void)setUpView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [weakSelf getCommentList];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getCommentList];
    }];
   
    [((MJRefreshAutoNormalFooter *)self.tableView.mj_footer) setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_footer.automaticallyHidden=YES;
}

-(void)setUpNavi{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(20, 0,40, 40)];
    rightBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    rightBtn.imageView.contentMode=UIViewContentModeCenter;
    [rightBtn addTarget:self action:@selector(clickTel)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:IMAGE(@"order_phone") forState:UIControlStateNormal];
     UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.telBtn=rightBtn;
    rightBtn.hidden=YES;
    self.navigationItem.rightBarButtonItem =rightBtnItem;
    
}

#pragma mark ======获取订单详情=======
-(void)getTiebaDetail{
    SHOW_HUD
    [NeighbourModel getNeighbourModelDeatilWithId:self.tieba_id block:^(NeighbourModel *model, NSString *msg) {
       HIDE_HUD
        if (model) {
            [self setUpView];
            [self createBottomView];
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:model.items];
            self.model=model;
            [self.tableView reloadData];
            self.inputTextView.placeholderStr=[NSString stringWithFormat:@" 回复  %@",model.member[@"nickname"]];
            if ([model.from isEqualToString:@"trade"]) self.telBtn.hidden=NO;
            
            self.replyInfoDic[@"tieba_id"]=self.model.tieba_id;
        }else [self showMsg:msg];
    }];
}

#pragma mark ======获取评论列表=======
-(void)getCommentList{
    SHOW_HUD
   [NeighbourModel getNeighbourCommentListWithPage:self.page tieba_id:self.model.tieba_id block:^(NSArray *arr, NSString *msg) {
       HIDE_HUD
       if (arr) {
           
           if (self.page==1) {
               [self.tableView.mj_footer endRefreshing];
               [self.tableView.mj_header endRefreshing];
               [self.datasource removeAllObjects];
               [self.datasource addObjectsFromArray:arr];
           }else{
               [self.tableView.mj_footer endRefreshing];
               [self.tableView.mj_header endRefreshing];
               [self.datasource addObjectsFromArray:arr];
           }
           [self.tableView reloadData];
//           [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
       }else {
           [self.tableView.mj_footer endRefreshing];
           [self.tableView.mj_header endRefreshing];
           [self showMsg:msg];
       }
       
   } ];
}


#pragma mark ======打电话=======
-(void)clickTel{
//    self.telBtn.hidden=YES;
    [self showMobile:self.model.mobile];
}

#pragma mark ======创建底部回复view=======
-(void)createBottomView{
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 50)];
    bottomView.backgroundColor=BACK_COLOR;
    [self.view addSubview:bottomView];
    self.bottomView=bottomView;

    YFTextView *inputTextView=[[YFTextView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-80, 50)];
    [bottomView addSubview:inputTextView];
    inputTextView.placeholderColor=HEX(@"999999", 1.0);
    inputTextView.placeholderFont=14;
    inputTextView.placeholderStr=@" 回复 ";
    inputTextView.textFont=14;
    inputTextView.maxCount=10000;
    inputTextView.hiddenCountLab=YES;
    inputTextView.showsVerticalScrollIndicator=NO;
    inputTextView.showPlaceholdInVerticalCenter=YES;
    self.inputTextView=inputTextView;
    
    UIButton *answerBtn=[UIButton new];
    [bottomView addSubview:answerBtn];
    [answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=0;
        make.top.offset=0;
        make.width.offset=80;
        make.height.offset=50;
    }];
    answerBtn.backgroundColor=THEME_COLOR;
    //[answerBtn setTitle:NSLocalizedString(@"回复", nil) forState:UIControlStateNormal];
    [answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    answerBtn.titleLabel.font=FONT(14);
    [answerBtn addTarget:self action:@selector(answerSomeone) forControlEvents:UIControlEventTouchUpInside];
    self.answerBnt = answerBtn;
    UIView *lineView=[UIView new];
    lineView.backgroundColor=HEX(@"999999", 1.0);
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=0.5;
    }];
}

-(void)showBottomView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.y=HEIGHT-50;
    }];
//    [self.view endEditing:YES];
}

-(void)hiddenBottomView{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.y=HEIGHT;
    }];
}

#pragma mark ======回复某人=======
-(void)answerSomeone{
    if (self.inputTextView.inputText.length==0) {
        [self showMsg:NSLocalizedString(@"回复内容不能为空", nil)];
    }
    self.replyInfoDic[@"content"]=self.inputTextView.inputText;
    self.inputTextView.inputText=@"";
    [self hiddenBottomView];
    
    SHOW_HUD
    [NeighbourCommentModel replyCommentWithInfoDic:self.replyInfoDic block:^(NSString *msg) {
        HIDE_HUD
        [self showMsg:msg];
        if ([msg isEqualToString:NSLocalizedString(@"回复成功", nil)]) {
            self.model.replys=[NSString stringWithFormat:@"%d",[self.model.replys intValue]+1];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            self.page=1;
            [self getCommentList];
            if (self.success)  self.success();
        }
    }];
    
}

#pragma mark ======监听键盘的收起和弹出=======
-(void)keybordWillShow:(NSNotification *)noti{
    self.is_scroll=YES;
    NSValue *toValue = (NSValue *)noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect frame;
    [toValue getValue:&frame];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.y=HEIGHT-50-frame.size.height;
    }];
}

-(void)keybodDidShow{
    self.is_scroll=NO;
}

-(void)keybordWillHidden:(NSNotification *)noti{
    [self hiddenBottomView];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.is_scroll)  return;
    [self hiddenBottomView];
//    [self.view endEditing:YES];
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 70, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 70, 0, 0)];
        }
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0)  return 1;
    return self.datasource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *ID=@"NeighbourCellSectionOne";
        JHNeighbourCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[JHNeighbourCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        [cell reloadCellWithModel:self.model is_showDes:YES];
        cell.clickComment=^(){
            [self showBottomView];
////            if ([[JHShareModel shareModel].communityModel.uid isEqualToString:self.model.member[@"uid"]]) {
                self.inputTextView.placeholderStr=@" 评论";
            [self.answerBnt setTitle:NSLocalizedString(@"评论", nil) forState:0];
            //[NSString stringWithFormat:@" 回复  %@",self.model.member[@"nickname"]];
////            }else  {
//               self.inputTextView.placeholderStr=[NSString stringWithFormat:@" 回复  %@",self.model.member[@"nickname"]];
            
//            }
            self.replyInfoDic[@"at_reply_id"]=@"";
        };
        
        cell.clickSupport=^{
            [self likeTiebaWith:self.model andIndexPath:indexPath];
        };
        
        return cell;
    }else{
        static NSString *ID=@"NeighbourDetailCommentCell";
        NeighbourCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[NeighbourCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        NeighbourCommentModel *model=self.datasource[indexPath.row];
        [cell reloadCellWith:model];
        cell.clickIcon=^(){
            [self showBottomView];
//            if ([[JHShareModel shareModel].communityModel.uid isEqualToString:self.model.member[@"uid"]]) {
//                self.inputTextView.placeholderStr=@" 回复";
//                self.replyInfoDic[@"at_reply_id"]=@"";
//            }else  {
                self.inputTextView.placeholderStr=[NSString stringWithFormat:@" 回复  %@",self.model.member[@"nickname"]];
                self.replyInfoDic[@"at_reply_id"]=model.reply_id;
             [self.answerBnt setTitle:NSLocalizedString(@"回复", nil) forState:0];
//            }
            
        };
        return cell;
    }
}

#pragma mark ======点赞=======
-(void)likeTiebaWith:(NeighbourModel *)model andIndexPath:(NSIndexPath *)indexPath{
    SHOW_HUD
    [NeighbourModel likeTiebaWithId:model.tieba_id block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        [self showMsg:msg];
        if (arr) {
            model.likes=[NSString stringWithFormat:@"%d",[model.likes intValue]+1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        NeighbourCommentModel *model=self.datasource[indexPath.row];
        [self showBottomView];
//        if ([[JHShareModel shareModel].communityModel.uid isEqualToString:self.model.member[@"uid"]]) {
//            self.inputTextView.placeholderStr=@" 回复";
//            self.replyInfoDic[@"at_reply_id"]=@"";
//        }else  {
            self.inputTextView.placeholderStr=[NSString stringWithFormat:@" 回复  %@",self.model.member[@"nickname"]];
            self.replyInfoDic[@"at_reply_id"]=model.reply_id;
        [self.answerBnt setTitle:NSLocalizedString(@"回复", nil) forState:0];
//        }
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSString *str;
        if ([self.model.from isEqualToString:@"trade"]) {
           str=[NSString stringWithFormat:@"%@", self.model.title];
        }else str=[NSString stringWithFormat:@"%@", self.model.content];
       
        float height=getStrHeight(str, WIDTH-30, 14);
        if (str.length==0)  height=0;
    
        float imgH=0;
        if (self.model.photos.count==0)   imgH=0;
        else{
            int count=(int)self.model.photos.count/4+1;
            imgH = (WIDTH-15*4)/3.0 * count+15*count;
        }
        
        float desH=0;
        if ([self.model.from isEqualToString:@"trade"]) {
            NSString *desStr=self.model.content;
            if (desStr.length!=0) desH=getStrHeight(desStr, WIDTH-30, 13)+15;
        }
       
        return 145+height+imgH+desH;
        
    }else{
        NeighbourCommentModel *model=self.datasource[indexPath.row];
        NSString *str=model.content;
        float height=getStrHeight(str, WIDTH-30, 12);
        return 60+height;
    }
    
}

-(NSMutableDictionary *)replyInfoDic{
    if (_replyInfoDic==nil) {
        _replyInfoDic=[[NSMutableDictionary alloc] init];
    }
    return _replyInfoDic;
}

-(NSMutableArray *)datasource{
    if (_datasource==nil) {
        _datasource=[[NSMutableArray alloc] init];
    }
    return _datasource;
}


@end
