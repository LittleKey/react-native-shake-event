#import <React/RCTBridgeModule.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>

#import <CoreMotion/CoreMotion.h>

@interface RNShakeEvent : NSObject <RCTBridgeModule> {
    CMMotionManager *_motionManager;
}

@end
