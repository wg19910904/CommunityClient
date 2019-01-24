//
//  ChosePeopleNumView.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "HZQChosePickerView.h"

@implementation HZQChosePickerView
{
    HZQChosePickerView * control;
    NSArray * dataArray;//保存数据的
    NSInteger tag;//当前选中的索引
}


+(HZQChosePickerView *)showChosePeopleNumViewWithArray:(NSArray *)infoArray
                                             withIndex:(NSInteger)index{
    HZQChosePickerView * view = [[HZQChosePickerView alloc]init];
    [view creatViewWithArray:infoArray withIndex:index withView:view];
    return view;
}
-(void)creatViewWithArray:(NSArray*)infoArray
                withIndex:(NSInteger)index
                 withView:(HZQChosePickerView *)view{
    control = view;
    dataArray = infoArray;
    tag = index;
    view.frame = FRAME(0, 0, WIDTH, HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    [view addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
    //创建中间的view
    [view addSubview:self.center_view];
    //显示标题的label
    [_center_view addSubview:self.label_title];
    //添加pickerView
    [_center_view addSubview:self.pickerView];
    //创建底部的按钮
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(i*((WIDTH - 80)/2), WIDTH - 130, (WIDTH - 80)/2, 50);
        if (i == 0) {
            [btn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
            [btn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
        }else{
            [btn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
            [btn setTitleColor:HEX(@"59c181", 1.0) forState:UIControlStateNormal];
        }
        btn.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.titleLabel.font = FONT(14);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_center_view addSubview:btn];
    }
}
#pragma mark - 这是点击按钮的方法
-(void)clickBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        [self clickToRemove];
    }else{
        [self clickToRemove];
        if (self.delegate && [self.delegate respondsToSelector:@selector(choseWithText:withIndex:)]) {
            [self.delegate choseWithText:dataArray[tag] withIndex:tag];
        }
        if (self.myBlock) {
            self.myBlock(dataArray[tag],tag);
        }
    }
}
#pragma mark - 返回中间的view
-(UIView *)center_view{
    if (!_center_view) {
        _center_view = [[UIView alloc]init];
        _center_view.frame = FRAME(40, (HEIGHT - WIDTH + 80)/2, WIDTH-80, WIDTH - 80);
        _center_view.backgroundColor = [UIColor whiteColor];
        _center_view.layer.cornerRadius = 4;
        _center_view.layer.masksToBounds = YES;
    }
    return _center_view;
}
#pragma marek - 这是返回标题的
-(UILabel *)label_title{
    if (!_label_title) {
        _label_title = [[UILabel alloc]init];
        _label_title.frame = FRAME(0, 0, WIDTH - 80, 40);
        _label_title.backgroundColor = HEX(@"f5f5f5", 1.0);
        _label_title.text = NSLocalizedString(@"请选择就餐人数", nil);
        _label_title.font = FONT(14);
        _label_title.textAlignment = NSTextAlignmentCenter;
        _label_title.textColor = HEX(@"333333", 1.0);

    }
    return _label_title;
}
#pragma mark - 这是返回人数选择的控制器
-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _pickerView.frame = FRAME(0, 40, WIDTH - 80, WIDTH - 170);
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_pickerView selectRow:tag inComponent:0 animated:YES];
    }
    return _pickerView;
}
#pragma mark - 点击消失的方法
-(void)clickToRemove{
    [control removeFromSuperview];
    control = nil;
}
#pragma mark - 这是pickerView的代理和数据源方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return dataArray.count;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGRect rect1 = [pickerView.subviews objectAtIndex:1].frame;
    rect1.origin.x = 0;
    rect1.size.width = pickerView.frame.size.width ;
    [[pickerView.subviews objectAtIndex:1] setFrame:rect1];
    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:THEME_COLOR];
    CGRect rect2 = [pickerView.subviews objectAtIndex:2].frame;
    rect2.origin.x = 0;
    rect2.size.width = pickerView.frame.size.width ;
    [[pickerView.subviews objectAtIndex:2] setFrame:rect2];
    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:THEME_COLOR];
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH - 80, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = dataArray[row];
    myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    if (tag==row) myView.textColor=THEME_COLOR;
    else myView.textColor=HEX(@"333333", 1.0);
    return myView;

}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIDTH - 80;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel *lab=(UILabel *)[pickerView viewForRow:row forComponent:component];
    lab.textColor=THEME_COLOR;
    tag = row;
}
@end
