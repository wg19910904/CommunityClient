//
//  JHTempJumpWithRouteModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/10.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempJumpWithRouteModel.h"
@implementation JHTempJumpWithRouteModel
+(id)jumpWithLink:(NSString *)link{
    if (link.length == 0 || [link hasPrefix:@"#"]) {
        return nil;
    }
    UIViewController *vc;
    
    // 如果链接中不包含当前的域名,直接返回相应的网页
    if ([link containsString:KReplace_Url] == NO) {
        Class vcClass = NSClassFromString(@"JHTempWebViewVC");
        vc = [[vcClass alloc]init];
        [vc setValue:link forKey:@"url"];
        vc.hidesBottomBarWhenPushed = YES;
        return vc;
    }
    // 其他情况的相应的跳转
    JHTempJumpWithRouteModel *model = [[JHTempJumpWithRouteModel alloc]init];
    NSString * parameterId = [model getParameterWithLink:link];
    BOOL isShop = NO;

    if ([link containsString:@"shop"] && ![link containsString:@"tuan"] && ![link containsString:@"detail"] && ![link containsString:@"waimai/shop"]&&![link containsString:@"items-shop"] && ![link containsString:@"mall"]&&![link containsString:@"apply/shop"]) {

        isShop = YES;
    }
    NSString *str;
    if ([link containsString:@"waimai"]) {
        str = [link substringFromIndex:link.length - 6];
    }
    NSString *str1;
    if ([link containsString:@"xiaoqu"]) {
        str1 = [link substringFromIndex:link.length - 5];
    }
    if([link containsString:@"mall"]){
        //商城
        Class vcClass = NSClassFromString(@"JHTempWebViewVC");
        vc = [[vcClass alloc]init];
        [vc setValue:link forKey:@"url"];
    }else if (([link containsString:@"waimai/index"]||[str isEqualToString:@"waimai"]) && ![link containsString:@"?"]) {//外卖首页
        Class vcClass = NSClassFromString(@"JHNewWaiMaiHomeVC");
        vc = [[vcClass alloc]init];
    }else if([link containsString:@"waimai/product/index"]){//外卖店铺详情
        Class vcClass = NSClassFromString(@"JHWaiMaiMainVC");
        vc = [[vcClass alloc]init];
        [vc setValue:parameterId forKey:@"shop_id"];
    }else if([link containsString:@"waimai/product/detail"]){//外卖商品详情
        Class vcClass = NSClassFromString(@"JHProductDetailVC");
        vc = [[vcClass alloc]init];
        [vc setValue:parameterId forKey:@"product_id"];
    }else if ([link containsString:@"waimai/shop/index"]|| [link containsString:@"waimai/shop"]){//(外卖商家列表)
        Class vcClass = NSClassFromString(@"JHWaiMaiFilterListVC");
        vc = [[vcClass alloc]init];
        [vc setValue:parameterId forKey:@"cateId"];
    }else if (([link containsString:@"shop/index"] || isShop) && ![link containsString:@"mall"]){//商家列表
        Class vcClass = NSClassFromString(@"JHWaiMaiFilterListVC");
        vc = [[vcClass alloc]init];
        [vc setValue:@(YES) forKey:@"isShop"];
        [vc setValue:@(YES) forKey:@"isShowSearch"];
        [vc setValue:parameterId forKey:@"cateId"];
    }else if ([link containsString:@"shop/detail"]){//商家详情
        Class vcClass = NSClassFromString(@"JHShopHomepageVC");
        vc = [[vcClass alloc]init];
        [vc setValue:parameterId forKey:@"shop_id"];
    }else if ([link containsString:@"tuan/shop"]){//团购商家列表
        //跳转到团购
        Class vcClass = NSClassFromString(@"JHTuanGouListVC");
        vc = [[vcClass alloc] init];
    }else if ([link containsString:@"tuan/product/goodsitems"]){//团购列表
        Class vcClass = NSClassFromString(@"JHTuanGouProductListVC");
        vc = [[vcClass alloc]init];
        [vc setValue:NSLocalizedString(@"团购列表", nil) forKey:@"titleString"];
        [vc setValue:parameterId forKey:@"shop_id"];
    }
    else if ([link containsString:@"tuan/product/goodsdetail"]){//团购详情
        Class vcClass = NSClassFromString(@"JHTuanGouProductDetailVC");
        vc = [[vcClass alloc]init];
        [vc setValue:NSLocalizedString(@"团购详情", nil) forKey:@"titleString"];
        [vc setValue:parameterId forKey:@"tuan_id"];
    }else if ([link containsString:@"headline/items"]){//头条列表
        Class vcClass = NSClassFromString(@"JHTempNewsMainVC");
        vc = [[vcClass alloc]init];
        [vc setValue:parameterId forKey:@"cate_id"];
    }else if ([link containsString:@"paotui/index"] || [link containsString:@"/paotui"] ){//跑腿
        if ([link containsString:@"items/paotui"]) {
            Class vcClass = NSClassFromString(@"JHRunOederListViewController");
            vc = [[vcClass alloc]init];
        }else{
        Class vcClass = NSClassFromString(@"JHRunVC");
        vc = [[vcClass alloc]init];
    }

    }else if ([link containsString:@"house/index"] || [link containsString:@"house"]){//家政
        if ([link containsString:@"items/house"]) {
            //JHHouseKeepListVC
            Class vcClass = NSClassFromString(@"JHHouseKeepListVC");
            vc = [[vcClass alloc]init];
        }else{
            Class vcClass = NSClassFromString(@"JHHouseKeepingVC");
            vc = [[vcClass alloc]init];
       
        }
       
    }else if ([link containsString:@"weixiu/index"] || [link containsString:@"weixiu"] ){//维修
        if ([link containsString:@"items/weixiu"]) {
            //JHHouseKeepListVC
            Class vcClass = NSClassFromString(@"JHUpKeepListVCViewController");
            vc = [[vcClass alloc]init];
        }else{
        Class vcClass = NSClassFromString(@"JHMaintainVC");
        vc = [[vcClass alloc]init];
        }
    }
    else if([link containsString:@"passport/login"]){//登录
        Class vcClass = NSClassFromString(@"JHLoginVC");
        vc = [[vcClass alloc] init];
    }else if([link containsString:@"xiaoqu/index"] || [str1 isEqualToString:@"xiaoqu"]){//小区
        Class vcClass = NSClassFromString(@"JHCommunityHomeVC");
        vc = [[vcClass alloc] init];
    }else if([link containsString:@"xiaoqu/tieba/index"] ||[link containsString:@"xiaoqu/tieba"] ){//小区邻里
        Class vcClass = NSClassFromString(@"JHRangeOfNeighbourVC");
        vc = [[vcClass alloc] init];
    }else if([link containsString:@"ucenter/addr"]){//我的地址
        Class vcClass = NSClassFromString(@"JHWaiMaiAddressVC");
        vc = [[vcClass alloc] init];
    }else if([link containsString:@"ucenter/order/yuyue"]){
        Class vcClass = NSClassFromString(@"JHSeatAndNumberListVC");
         vc = [[vcClass alloc] init];
    }else if([link containsString:@"ucenter/order/tuan"] && ![link containsString:@"tuandetail"]){//团购订单
        Class vcClass = NSClassFromString(@"JHGroupOrderVC");
        vc = [[vcClass alloc] init];
    }else if([link containsString:@"ucenter/order/waimai"] && ![link containsString:@"waimaidetail"]){//外卖订单
        
            Class vcClass = NSClassFromString(@"JHWaiMaiOrderVC");
            vc = [[vcClass alloc] init];
        
    }else if([link containsString:@"ucenter/order/maidan"]){//买单订单
        Class vcClass = NSClassFromString(@"JHMaidanOrderList");
        vc = [[vcClass alloc] init];
    }else if([link containsString:@"topline"] && ![link containsString:@"cate"]){//头条//"http://app.xiaoleida.cn/topline/index.html
        
        Class vcClass = NSClassFromString(@"JHHeadLinesVC");
        vc = [[vcClass alloc] init];
        
    }else {
        //均不匹配时,跳转到相应的网页
        Class vcClass = NSClassFromString(@"JHTempWebViewVC");
//        Class vcClass = NSClassFromString(@"XHWebViewViewController");
        vc = [[vcClass alloc]init];
        [vc setValue:link forKey:@"url"];
    }
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}
//原生界面,如果有参数,取出参数
-(NSString *)getParameterWithLink:(NSString *)link{
    link = [[link componentsSeparatedByString:@".html"]firstObject];
    NSString *str;
    if ([link containsString:@"-"]&&[link containsString:@"waimai/product/index"]) {//外卖店铺详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
    }else if ([link containsString:@"waimai/product/detail"] && [link containsString:@"-"]){//外卖商品详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
    }else if ([link containsString:@"tuan/product/goodsitems"] && [link containsString:@"-"]){//团购列表
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"tuan/product/goodsdetail"] && [link containsString:@"-"]){//团购详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"headline/items"] && [link containsString:@"-"]){//头条列表
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if (([link containsString:@"shop/index"] || [link containsString:@"waimai/shop/index"]|| [link containsString:@"shop"]|| [link containsString:@"waimai/shop"]) && [link containsString:@"?"]){//商家列表
        str = [[link componentsSeparatedByString:@"?"]lastObject];
        str = [[str componentsSeparatedByString:@"="]lastObject];
    }else if ([link containsString:@"waimai/shop-index"]){//商家列表
         str = [[link componentsSeparatedByString:@"-"]lastObject];
    }
    else if ([link containsString:@"shop/detail"] && [link containsString:@"-"]){//商家详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
    }
    return str;
}
@end
