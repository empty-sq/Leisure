//
//  URLHeaderDefine.h
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#ifndef URLHeaderDefine_h
#define URLHeaderDefine_h

//  阅读模块请求地址
/** 阅读首页列表 */
#define READLIST_URL           @"http://api2.pianke.me/read/columns"
/** 列表详情 */
#define READDETAILLIST_URL     @"http://api2.pianke.me/read/columns_detail"
/** 文章详情 */
#define READCONTENT_URL        @"http://api2.pianke.me/article/info"

//  评论
/** 获取评论 */
#define GETCOMMENT_url         @"http://api2.pianke.me/comment/get"
/** 发表评论 */
#define ADDCOMMENT_url         @"http://api2.pianke.me/comment/add"
/** 删除评论 */
#define DELCOMMENT_url         @"http://api2.pianke.me/comment/del"

//  电台模块
/** 电台列表 */
#define RADIOLIST_URL          @"http://api2.pianke.me/ting/radio"
/** 上拉电台列表 */
#define RADIOMLISTORE_URL      @"http://api2.pianke.me/ting/radio_list"
/** 电台详细列表 */
#define RADIODETAILLIST_URL    @"http://api2.pianke.me/ting/radio_detail"
#define RADIODETAILMORE_URL    @"http://api2.pianke.me/ting/radio_detail_list "

//  良品模块
/** 良品列表 */
#define SHOPLIST_URL           @"http://api2.pianke.me/pub/shop"
/** 良品详情 */
#define SHOPINFO_URL           @"http://api2.pianke.me/group/posts_info"

//  话题模块
/** 话题列表 */
#define TOPICLIST_URL          @"http://api2.pianke.me/group/posts_hotlist"
/** 话题详情 */
#define TOPICINFO_URL          @"http://api2.pianke.me/group/posts_info"

#endif /* URLHeaderDefine_h */
