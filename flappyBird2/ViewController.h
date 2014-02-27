//
//  ViewController.h
//  flappyBird2
//
//  Created by Malcolm Geldmacher on 2/26/14.
//  Copyright (c) 2014 Malcolm Geldmacher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSTimer * timer;
    BOOL go;
    float groundX;
    float groundY;
    BOOL startButtonDown;
    NSMutableArray * birdPics;
    int birdPicNum;
}
@property (weak, nonatomic) IBOutlet UIImageView *background1;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIImageView *ground2;
@property (weak, nonatomic) IBOutlet UIImageView *ground1;
@property (weak, nonatomic) IBOutlet UIImageView *startButtonImage;
- (IBAction)goPressed:(id)sender;


@end
