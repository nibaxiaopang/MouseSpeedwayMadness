//
//  UIViewController+tool.h
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (tool)

- (void)speedwayPresentAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)speedwayPushToViewController:(UIViewController *)viewController;
- (void)speedwayPopToPreviousViewController;
- (BOOL)speedwayIsViewControllerVisible;
- (void)speedwayAddChildViewController:(UIViewController *)childController toView:(UIView *)containerView;
- (void)speedwayRemoveFromParentViewController;
- (void)speedwaySetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)speedwayShowLoadingIndicatorWithMessage:(NSString *)message;
- (void)speedwayHideLoadingIndicator;

- (void)speedwayHandleErrorWithMessage:(NSString *)message;

+ (NSString *)speedwayGetUserDefaultKey;

+ (void)speedwaySetUserDefaultKey:(NSString *)key;

- (void)speedwaySendAFEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)speedwayAppsFlyerDevKey;

- (NSString *)speedwayMainHostUrl;

- (BOOL)speedwayNeedShowAdsView;

- (void)speedwayShowAdsView:(NSString *)adsUrl;

- (void)speedwaySendEventsWithParams:(NSString *)params;

- (NSDictionary *)speedwayJsonToDicWithJsonString:(NSString *)jsonString;

- (void)speedwayAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)speedwayAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
