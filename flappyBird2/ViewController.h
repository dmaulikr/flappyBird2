//
//  ViewController.h
//  flappyBird2
//
//  Created by Malcolm Geldmacher on 2/26/14.
//  Copyright (c) 2014 Malcolm Geldmacher. All rights reserved.
//

#import <UIKit/UIKit.h>
  int gameMode;
  bool soundFX;
  bool musicOn;
@interface ViewController : UIViewController
{
  
    bool buttonsMoved;
    
    NSTimer * gameLoopTimer;
    NSTimer * groundTimer;
    NSTimer * birdFlapTimer;
    NSTimer * gravityTimer;
    NSTimer * coinTimer;
    int timerCount;
    BOOL go;
    float groundX;
    float groundY;
    BOOL startButtonDown;
    NSMutableArray * birdPics;
    int birdPicNum;
    NSMutableArray * coinPics;
    int coinPicNum;
    BOOL wingsGoingUp;
    float birdY;
    float gravityConstant;
    float birdAccel;
    BOOL gravityOn;
}
@property (weak, nonatomic) IBOutlet UIImageView *background1;
@property (weak, nonatomic) IBOutlet UIImageView *ground1;
@property (weak, nonatomic) IBOutlet UIImageView *birdPicture;
@property (weak, nonatomic) IBOutlet UIImageView *titlePicture;
@property (weak, nonatomic) IBOutlet UIButton *easyButtonView;
@property (weak, nonatomic) IBOutlet UIButton *mediumButtonView;
@property (weak, nonatomic) IBOutlet UIButton *hardButtonView;

- (IBAction)easyMode:(id)sender;
- (IBAction)mediumMode:(id)sender;
- (IBAction)hardMode:(id)sender;
- (IBAction)soundFXSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *soundFXOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *musicSwitchOutlet;
- (IBAction)musicSwitch:(id)sender;

@end
