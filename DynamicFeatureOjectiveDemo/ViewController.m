//
//  ViewController.m
//  DynamicFeatureOjectiveDemo
//
//  Created by WhatsXie on 2017/5/12.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "ViewController.h"
// Cat
@interface Cat : NSObject
@end
@implementation Cat
- (void) say {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Cat" object:nil userInfo:nil];
}
@end
// Dog
@interface Dog : NSObject
@end
@implementation Dog
- (void) say {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dog" object:nil userInfo:nil];
}
@end
// Mouse
@interface Mouse : NSObject
@end
@implementation Mouse
- (void) say {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Mouse" object:nil userInfo:nil];
}
@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *animalTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *sayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animalImageView;
@property (weak, nonatomic) IBOutlet UIView *TalkView;
@property (weak, nonatomic) IBOutlet UILabel *fristTalkLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTalkLabel;
@property (weak, nonatomic) IBOutlet UILabel *reTalkLabel;
@property (weak, nonatomic) IBOutlet UITextField *talkTextFeld;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.TalkView.hidden = YES;
    self.fristTalkLabel.hidden = YES;
    self.myTalkLabel.hidden = YES;
    self.animalImageView.hidden = YES;
    self.reTalkLabel.hidden = YES;

    [self dynamicFeature];
}

- (void)dynamicFeature {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"Cat" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.sayLabel.text = @"Miao miao~~";
        [self loadTalkView:@"cat"];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"Dog" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.sayLabel.text = @"Wang Wang~~";
        [self loadTalkView:@"dog"];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"Mouse" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.sayLabel.text = @"Zhi Zhi~~";
        [self loadTalkView:@"mouse"];
    }];
}
- (void)loadTalkView :(NSString *)animal{
    self.TalkView.hidden = NO;
    NSString *loadTalkText = [[NSString alloc] initWithFormat:@"hello ,I am a %@, Nice to Meet you!", animal];
    
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    NSLog(@"You can say 'whatsdog' or whats other animals~");
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

    self.fristTalkLabel.hidden = NO;
    self.fristTalkLabel.text = loadTalkText;
}
- (IBAction)animalAction:(id)sender {
    NSString *nameAnimal = _animalTextFiled.text;
    Class class = NSClassFromString(nameAnimal);
    if (class == nil) {
        self.sayLabel.text = @"Please use the example animal!";
        self.animalImageView.image = [UIImage imageNamed:@"error.png"];
        return;
    }
    id object = [class new];
    SEL sayMethod = @selector(say);
    if ([object respondsToSelector:sayMethod]) {
        [object performSelector:sayMethod];
    }
}
- (IBAction)sendTalk:(id)sender {
    self.myTalkLabel.hidden = NO;
    
    dispatch_time_t delayTimeT = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTimeT, dispatch_get_main_queue(), ^{
        self.myTalkLabel.text = self.talkTextFeld.text;

        NSString *sendText = self.talkTextFeld.text;
        SEL method = NSSelectorFromString(sendText);
        if ([self respondsToSelector:method]) {
            [self performSelector:method];
        } else {
            NSLog(@"%@ is not method", sendText);
        }
    });
}
- (void)whatscat {
    self.reTalkLabel.hidden = NO;
    self.reTalkLabel.text = @"I will say Miao miao~";
    self.animalImageView.hidden = NO;
    dispatch_time_t delayTimeT = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTimeT, dispatch_get_main_queue(), ^{
    self.animalImageView.image = [UIImage imageNamed:@"cat.png"];
    });

}
- (void)whatsdog {
    self.reTalkLabel.hidden = NO;
    self.reTalkLabel.text = @"I will say wangwang~";
    self.animalImageView.hidden = NO;
    dispatch_time_t delayTimeT = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTimeT, dispatch_get_main_queue(), ^{
    self.animalImageView.image = [UIImage imageNamed:@"dog.png"];
    });

}
- (void)whatsmouse {
    self.reTalkLabel.hidden = NO;
    self.reTalkLabel.text = @"I will say zhizhi~";
    self.animalImageView.hidden = NO;
    dispatch_time_t delayTimeT = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTimeT, dispatch_get_main_queue(), ^{
    self.animalImageView.image = [UIImage imageNamed:@"mouse.png"];
    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
