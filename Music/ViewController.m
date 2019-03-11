//
//  ViewController.m
//  Music
//
//  Created by fanyin on 2019/3/11.
//  Copyright © 2019 fanyin. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [uib]
    UIButton* timeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//    button.backgroundColor
    [timeButton setBackgroundColor:UIColor.redColor];
//    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [timeButton setTitle:@"Test_nor" forState:UIControlStateNormal];
    [timeButton setTitle:@"Test_dis" forState:UIControlStateDisabled];
    
    
//    RACSignal* signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@"1"];
//        [subscriber sendCompleted];}
//                          ];

     RACSignal* signalTest = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         [subscriber sendNext:@"1"];
         return nil;
    }];
    
    [signalTest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [[self loadList] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSString class]]) {
            NSLog(@"%@",x);
        }
    }];
    
    
    __block NSUInteger numberLimit = 60;
    __block NSUInteger number = 0;
    RACSignal *timeSignal = [[[[[RACSignal interval:1.0f
                                        onScheduler:[RACScheduler mainThreadScheduler]]
                                take:numberLimit]
                               startWith:@(numberLimit)]
                              map:^id(NSDate *date)
    {
       
        if (number == 0) {
            [timeButton setTitle:@"重新发送" forState:UIControlStateNormal];
            return @YES;
        }
        else{
            timeButton.titleLabel.text = [NSString stringWithFormat:@"%d", number--];
            return @NO;
        }
    }] takeUntil:self.rac_willDeallocSignal];
    
    timeButton.rac_command = [[RACCommand alloc]initWithEnabled:timeSignal
                                                    signalBlock:^RACSignal *(id input)
    {
        number = numberLimit;
        return timeSignal;
    }];
    
//    RACSignal* signal = [button rac_signalForControlEvents:UIControlEventTouchUpInside];
//    button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
//       return signal;
//    }];
//
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"UIControl = %@",x );
//    }];
    
//    [button.uicon]
    
//    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *  x) {
//        NSLog(@"UIControl = %@",x );
//    }];
    
    [self.view addSubview:timeButton];
}

- (void)click {
    NSLog(@"click");
}




- (RACSignal*)loadList {
    RACSignal* signalTest = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"dataInfo"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    return signalTest;
}


@end
