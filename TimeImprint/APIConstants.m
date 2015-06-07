//
//  APIConstants.m
//  TimeImprint
//
//  Created by Peng Wan on 5/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "APIConstants.h"

NSString *const TEST_TOKEN              = @"b35f6698adce4acd831edb84bfe31ef3";   //GET FROM STORAGE
NSString *const TEST_USER_ID            = @"019d34ec15524c99babc2b560dbd1d72"; //GET FROM STORAGE

NSString *const BASE_URL                = @"http://ec2-52-25-185-187.us-west-2.compute.amazonaws.com";

NSString *const USER_SIGNIN             = @"user/​signin";
NSString *const USER_SIGNUP             = @"user/​signup";
NSString *const USER_PROFILE            = @"user";               //user/​[user_id]

NSString *const GRAPH_FOLLOW            = @"graph/follow";
NSString *const GRAPH_UNFOLLOW          = @"graph/unfollow";
NSString *const GRAPH_FOLLOWERS         = @"graph/followers";    //graph/followers/​[user_id]
NSString *const GRAPH_FOLLOWEES         = @"graph/followees";    //graph/followees/​[user_id]

NSString *const TIMELINE_BY_USER        = @"timeline/by_user";   //timeline/by_user/​[user_id]
NSString *const TIMELINE_BY_TOPIC       = @"timeline/by_topic​";  //timeline/by_topic/​[topic_id]
NSString *const TIMELINE_NEWSFEED       = @"timeline/news_feed";
NSString *const TIMELINE_DISCOVERY      = @"timeline/discovery";
NSString *const TIMELINE_TAGGED         = @"timeline/tagged";

NSString *const STORY_DETAIL            = @"story/view";         //story/view/​[story_id]
NSString *const STORY_CREATE            = @"story/create";
NSString *const STORY_DELETE            = @"story/delete";
NSString *const STORY_LIKE              = @"story/like";
NSString *const STORY_UNLIKE            = @"story/unlike";
NSString *const STORY_COMMENT           = @"story/comment";
NSString *const STORY_ACK               = @"story/ack";

NSString *const TOPIC_HOTTEST           = @"topic/hottest";
NSString *const TOPIC_LATEST            = @"topic/latest";
NSString *const TOPIC_CREATE            = @"topic/create";

NSString *const QUESTION_ASK            = @"question/ask";
NSString *const QUESTION_OUTBOUNDS      = @"question/by_user_id";
NSString *const QUESTION_INBOUNDS       = @"question/to_user_id​";
NSString *const QUESTION_READ           = @"question/read";      //question/read/​[question_id]
NSString *const QUESTION_DELETE         = @"question/delete​";    //question/delete/​[question_id]
