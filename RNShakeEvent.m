#import "RNShakeEvent.h"


static NSString *const RCTShowDevMenuNotification = @"RCTShowDevMenuNotification";

#if !RCT_DEV

@implementation UIWindow (RNShakeEvent)

- (void)handleShakeEvent:(__unused UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCTShowDevMenuNotification object:nil];
    }
}

@end

@implementation RNShakeEvent

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

+ (void)initialize
{
    RCTSwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), @selector(handleShakeEvent:withEvent:));
}

- (instancetype)init
{
    if ((self = [super init])) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Accelerometer
        if([self->_motionManager isAccelerometerAvailable])
        {
            RCTLogInfo(@"Accelerometer available");
            /* Start the accelerometer if it is not active already */
            if([self->_motionManager isAccelerometerActive] == NO)
            {
                RCTLogInfo(@"Accelerometer active");
            } else {
                RCTLogInfo(@"Accelerometer not active");
            }
        }
        else
        {
            RCTLogInfo(@"Accelerometer not Available!");
        }
        [self->_motionManager setAccelerometerUpdateInterval:1];
        RCTLogInfo(@"RNShakeEvent: started in debug mode");
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(motionEnded:)
                                                     name:RCTShowDevMenuNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if([self->_motionManager isAccelerometerActive] == YES)
    {
        [self->_motionManager stopAccelerometerUpdates];
    }
}

- (void)motionEnded:(NSNotification *)notification
{
    /* Receive the ccelerometer data on this block */
    /*
    [self->_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                               withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
     {
         double x = accelerometerData.acceleration.x;
         double y = accelerometerData.acceleration.y;
         double z = accelerometerData.acceleration.z;
         double timestamp = accelerometerData.timestamp;
         RCTLogInfo(@"startAccelerometerUpdates: %f, %f, %f, %f", x, y, z, timestamp);
     }];
     */
    if ([self->_motionManager isAccelerometerActive] == NO) {
        [self->_motionManager startAccelerometerUpdates];
    }
    double x = self->_motionManager.accelerometerData.acceleration.x * 9.8;
    double y = self->_motionManager.accelerometerData.acceleration.y * 9.8;
    double z = self->_motionManager.accelerometerData.acceleration.z * 9.8;
    double timestamp = self->_motionManager.accelerometerData.timestamp;
    RCTLogInfo(@"startAccelerometerUpdates: %f, %f, %f, %f", x, y, z, timestamp);
    int threshold = 40;
    if (x * x + y * y + z * z >= threshold * threshold)
    {
        [_bridge.eventDispatcher sendDeviceEventWithName:@"ShakeEvent"
                                                    body:nil];
    }
    if([self->_motionManager isAccelerometerActive] == YES)
    {
        [self->_motionManager stopAccelerometerUpdates];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if([self->_motionManager isAccelerometerActive] == YES)
        {
            [self->_motionManager stopAccelerometerUpdates];
        }
    });
}

@end

#else

@implementation RNShakeEvent

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (instancetype)init
{
    if ((self = [super init])) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Accelerometer
        if([self->_motionManager isAccelerometerAvailable])
        {
            RCTLogInfo(@"Accelerometer available");
            /* Start the accelerometer if it is not active already */
            if([self->_motionManager isAccelerometerActive] == NO)
            {
                RCTLogInfo(@"Accelerometer active");
            } else {
                RCTLogInfo(@"Accelerometer not active");
            }
        }
        else
        {
            RCTLogInfo(@"Accelerometer not Available!");
        }
        [self->_motionManager setAccelerometerUpdateInterval:1];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(motionEnded:)
                                                     name:RCTShowDevMenuNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if([self->_motionManager isAccelerometerActive] == YES)
    {
        [self->_motionManager stopAccelerometerUpdates];
    }
}

- (void)motionEnded:(NSNotification *)notification
{
    if ([self->_motionManager isAccelerometerActive] == NO) {
        [self->_motionManager startAccelerometerUpdates];
    }
    double x = self->_motionManager.accelerometerData.acceleration.x * 9.8;
    double y = self->_motionManager.accelerometerData.acceleration.y * 9.8;
    double z = self->_motionManager.accelerometerData.acceleration.z * 9.8;
    double timestamp = self->_motionManager.accelerometerData.timestamp;
    RCTLogInfo(@"startAccelerometerUpdates: %f, %f, %f, %f", x, y, z, timestamp);
    int threshold = 40;
    if (x * x + y * y + z * z >= threshold * threshold)
    {
        [_bridge.eventDispatcher sendDeviceEventWithName:@"ShakeEvent"
                                                    body:nil];
    }
    if([self->_motionManager isAccelerometerActive] == YES)
    {
        [self->_motionManager stopAccelerometerUpdates];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if([self->_motionManager isAccelerometerActive] == YES)
        {
            [self->_motionManager stopAccelerometerUpdates];
        }
    });
}

@end

#endif
