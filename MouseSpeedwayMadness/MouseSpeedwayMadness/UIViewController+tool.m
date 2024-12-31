//
//  UIViewController+tool.m
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//

#import "UIViewController+tool.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KKspeedwayUserDefaultkey __attribute__((section("__DATA, tigerBlaze"))) = @"";

NSDictionary *KKspeedwayJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, speedway")));
NSDictionary *KKspeedwayJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KKspeedwayJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, speedway")));
id KKspeedwayJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KKspeedwayJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KKspeedwayShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, speedway")));
void KKspeedwayShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.speedwayGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KKspeedwaySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, speedway")));
void KKspeedwaySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.speedwayGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KKspeedwayAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, speedway_Af")));
NSString *KKspeedwayAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KKspeedwayConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, speedway_")));
NSString* KKspeedwayConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (tool)

- (void)speedwayPresentAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)speedwayPushToViewController:(UIViewController *)viewController {
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)speedwayPopToPreviousViewController {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)speedwayIsViewControllerVisible {
    return (self.isViewLoaded && self.view.window);
}

- (void)speedwayAddChildViewController:(UIViewController *)childController toView:(UIView *)containerView {
    [self addChildViewController:childController];
    childController.view.frame = containerView.bounds;
    [containerView addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)speedwayRemoveFromParentViewController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)speedwaySetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:hidden animated:animated];
    }
}

- (void)speedwayShowLoadingIndicatorWithMessage:(NSString *)message {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    indicator.center = self.view.center;
    indicator.tag = 999; // Unique tag for easy removal
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, indicator.center.y + 30, self.view.bounds.size.width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.tag = 1000;

    [self.view addSubview:indicator];
    [self.view addSubview:label];
    [indicator startAnimating];
}

- (void)speedwayHideLoadingIndicator {
    UIView *indicator = [self.view viewWithTag:999];
    UIView *label = [self.view viewWithTag:1000];
    [indicator removeFromSuperview];
    [label removeFromSuperview];
}

- (void)speedwayHandleErrorWithMessage:(NSString *)message {
    [self speedwayPresentAlertWithTitle:@"Error" message:message];
}

+ (NSString *)speedwayGetUserDefaultKey
{
    return KKspeedwayUserDefaultkey;
}

+ (void)speedwaySetUserDefaultKey:(NSString *)key
{
    KKspeedwayUserDefaultkey = key;
}

+ (NSString *)speedwayAppsFlyerDevKey
{
    return KKspeedwayAppsFlyerDevKey(@"MouseSpeedwayMadnesszt99WFGrJwb3RdzuknjXSKMouseSpeedwayMadness");
}

- (NSString *)speedwayMainHostUrl
{
    return @"wei.xyz";
}

- (BOOL)speedwayNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)speedwayShowAdsView:(NSString *)adsUrl
{
    KKspeedwayShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)speedwayJsonToDicWithJsonString:(NSString *)jsonString {
    return KKspeedwayJsonToDicLogic(jsonString);
}

- (void)speedwaySendAFEvent:(NSString *)event values:(NSDictionary *)value
{
    KKspeedwaySendEventLogic(self, event, value);
}

- (void)speedwaySendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self speedwayJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)speedwayAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self speedwayJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.speedwayGetUserDefaultKey];
    if ([KKspeedwayConvertToLowercase(name) isEqualToString:KKspeedwayConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)speedwayAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self speedwayJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.speedwayGetUserDefaultKey];
    if ([KKspeedwayConvertToLowercase(name) isEqualToString:KKspeedwayConvertToLowercase(adsDatas[24])] || [KKspeedwayConvertToLowercase(name) isEqualToString:KKspeedwayConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}
@end
