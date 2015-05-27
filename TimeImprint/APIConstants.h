
#import <Foundation/Foundation.h>

extern NSString *const TEST_TOKEN;
extern NSString *const TEST_USER_ID;

extern NSString *const BASE_URL;

extern NSString *const USER_SIGNIN;
extern NSString *const USER_SIGNUP;
extern NSString *const USER_PROFILE;

extern NSString *const GRAPH_FOLLOW;
extern NSString *const GRAPH_UNFOLLOW;
extern NSString *const GRAPH_FOLLOWERS;
extern NSString *const GRAPH_FOLLOWEES;

extern NSString *const TIMELINE_BY_USER;
extern NSString *const TIMELINE_BY_TOPIC;
extern NSString *const TIMELINE_NEWSFEED;
extern NSString *const TIMELINE_DISCOVERY;
extern NSString *const TIMELINE_TAGGED;

extern NSString *const STORY_DETAIL;
extern NSString *const STORY_CREATE;
extern NSString *const STORY_DELETE;
extern NSString *const STORY_LIKE;
extern NSString *const STORY_UNLIKE;
extern NSString *const STORY_COMMENT;
extern NSString *const STORY_ACK;

extern NSString *const TOPIC_HOTTEST;
extern NSString *const TOPIC_LATEST;
extern NSString *const TOPIC_CREATE;

extern NSString *const QUESTION_ASK;
extern NSString *const QUESTION_OUTBOUNDS;
extern NSString *const QUESTION_INBOUNDS;
extern NSString *const QUESTION_READ;
extern NSString *const QUESTION_DELETE;

typedef void (^APISuccessBlock) (id successResponse);

typedef void (^APIFailureBlock) (id failureResponse, NSError *error);

static NSString *const kResponseNotDictoryError = @"Login - Server response is not of type dictionary";
