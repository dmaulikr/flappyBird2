//
//  flappyView.m
//  flappyBird2
//
//  Created by Brittny Wright on 2/28/14.
//  Copyright (c) 2014 Malcolm Geldmacher. All rights reserved.
//

#import "flappyView.h"

@implementation flappyView
/******************OVERVIEW*********************
"flappyView" is the view controller that handles the actual game play of the game. It handles everything about game play and is the main part of the game.
 **********************************************/


/***********************************************
 INITIALIZATION -- BEGIN
***********************************************/


/****************viewDidLoad********************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Called when the view loads. Handles most of the initialization needed for the game. Then  proceeds to the rest of the code.
 **********************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTubes];
    [self setUpCollisionObjects];
    [self setUpBackground];
    [self setUpBird];
    [self setUpGravity];
    [self setUpCoins];
    go = NO;
}
/****************setUpTubes**********************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Initializes and sets constants for coins.
 ***********************************************/
-(void)setUpCoins
{
    coinPics = [[NSMutableArray alloc]init];
    [coinPics addObject:@"flappyBirdCoin1.png"];
    [coinPics addObject:@"flappyBirdCoin2.png"];
    [coinPics addObject:@"flappyBirdCoin3.png"];
    [coinPics addObject:@"flappyBirdCoin4.png"];
    [coinPics addObject:@"flappyBirdCoin5.png"];
    [coinPics addObject:@"flappyBirdCoin6.png"];
    [coinPics addObject:@"flappyBirdCoin7.png"];
    [coinPics addObject:@"flappyBirdCoin8.png"];
    [coinPics addObject:@"flappyBirdCoin9.png"];
    [coinPics addObject:@"flappyBirdCoin10.png"];
    coinPicNum = 1;
    UIImage * coinImage = [UIImage imageNamed:coinPics[0]];
    _coinPicture.image = coinImage;
    _coinPicture1.image=coinImage;
    _coinPicture1.hidden=YES;
    _coinPicture.hidden=YES;
    coinRand=arc4random()%396;  //above ground
    coinSpeed=-1;
    startCoinOne=NO;
    startCoinTwo=NO;
    coinsBegan=NO;
 
}


/****************setUpTubes**********************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Initializes and sets constants for tubes.
 ***********************************************/
-(void)setUpTubes
{
    widthOfViewController=320;
    sizeBetweenTubes=128;
    tubeWidth=59;
    tubeHeight=256;
    tubeBottomY=321;
    tubeBottomX=350;
    tubeTopX=350;
    tubeTopY=-107;
    tubeSpeed=-1;
    random=150;
    startTubeOne=YES;
    startTubeTwo=NO;
    
    _tubeBottomImage.hidden=YES;
    _tubeBottomImage1.hidden=YES;
    
    _tubeTopImage.hidden=YES;
    _tubeTopImage1.hidden=YES;
}

/*************setUpCollisionObjects*************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Initializes and adds objects to a collision array for detecting collisions.
 **********************************************/
-(void)setUpCollisionObjects
{
    collisionObjectsArray=[[NSMutableArray alloc] init];
    
    [collisionObjectsArray addObject:_tubeBottomImage];
    [collisionObjectsArray addObject:_tubeBottomImage1];
    [collisionObjectsArray addObject:_tubeTopImage];
    [collisionObjectsArray addObject:_tubeTopImage1];
    [collisionObjectsArray addObject:_ground1];
    [collisionObjectsArray addObject:_ground2];
}

/*****************setUpBackground****************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Sets up and initializes both the static background and the moving foreground
 ***********************************************/
-(void)setUpBackground
{
    _background1.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _ground1.frame = CGRectMake(0, self.view.frame.size.height - _ground1.frame.size.height, _ground1.frame.size.width, _ground1.frame.size.height);
    _ground2.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height - _ground2.frame.size.height, _ground2.frame.size.width, _ground2.frame.size.height);
    
    groundY = self.view.frame.size.height - _ground1.frame.size.height;
    groundX = 0;
}

/******************setUpBird**********************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Sets up and initializes the bird view, the bird images array, and all the variables associated with the bird
 ************************************************/
-(void)setUpBird
{
    _birdPicture.frame = CGRectMake(_birdPicture.frame.origin.x, _birdPicture.frame.origin.y, 34, 24);
    
    birdPics = [[NSMutableArray alloc]init];
    [birdPics addObject:@"flappyBirdFlying1.png"];
    [birdPics addObject:@"flappyBirdFlying2.png"];
    [birdPics addObject:@"flappyBirdFlying3.png"];
    
    birdY = _birdPicture.frame.origin.y;
    birdPicNum = 0;
    birdAccel = 0;
    wingsGoingUp = NO;
    dead = NO;
}

/*********************setUpGravity****************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Initializes the variables associated with the gravity of the game
 ************************************************/
-(void)setUpGravity
{
    gravityConstant = 0.22;
    gravityOn = NO;
}


/*************************************************
 INITIALIZATION -- END
 ************************************************/



/*************************************************
 DEFAULTS -- BEGIN
 ************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [gravityTimer invalidate];
    [tubeTimer invalidate];
}

/*************************************************
 DEFAULTS -- END
 ************************************************/

/*************************************************
 GAME -- BEGIN
 ************************************************/

/****************gameLoop*************************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: The main loop of the game. Checks states of all situations, performs actions and updates states of all objects and views
 ************************************************/
-(void)gameLoop
{
    [self updateTube];
    [self updateGround];
    [self updateGravity];
    [self updateCoinMovement];

    if(timerCount == 10)
    {
        [self updateFlaps];
        [self updateCoins];
        timerCount = 0;
    }
    //increase timerCount for updates not synchronous with gameLoop
    timerCount += 1;
}

-(void)updateGround
{
    [UIView animateWithDuration:0.01
                     animations:^(void)
     {
         [_ground1 setFrame:CGRectMake(groundX, groundY, _ground1.frame.size.width, _ground1.frame.size.height)];
         [_ground2 setFrame:CGRectMake(groundX + self.view.frame.size.width, groundY, _ground2.frame.size.width, _ground2.frame.size.height)];
     }
                     completion:^(BOOL finished){}];
    groundX -= 1;
    if(groundX < (self.view.frame.size.width * -1))
    {
        groundX = 0;
    }
}

-(void)updateFlaps
{
    [UIView animateWithDuration:0.01
                     animations:^(void)
     {
         _birdPicture.image = [UIImage imageNamed:birdPics[birdPicNum]];
     }
                     completion:^(BOOL finished){}];
    if(birdPicNum == [birdPics count] - 1)
    {
        birdPicNum = [birdPics count] - 2;
        wingsGoingUp = YES;
    }
    else if(birdPicNum == 0)
    {
        birdPicNum = 1;
        wingsGoingUp = NO;
    }
    else
    {
        if(wingsGoingUp)
        {
            birdPicNum -= 1;
        }
        else
        {
            birdPicNum += 1;
        }
    }
}

-(void)updateGravity
{
    [UIView animateWithDuration:0.01
                     animations:^(void)
     {
         _birdPicture.frame = CGRectMake(_birdPicture.frame.origin.x, _birdPicture.frame.origin.y - birdAccel, _birdPicture.frame.size.width, _birdPicture.frame.size.height);
     }
                     completion:^(BOOL finished){}];
        birdAccel -= gravityConstant;
}

-(void)updateCoins
{
    [UIView animateWithDuration:0.1 animations:^(void){
        UIImage * newImage = [UIImage imageNamed:coinPics[coinPicNum]];
        _coinPicture.image = newImage;
        _coinPicture1.image= newImage;
    }completion:^(BOOL finished){}];
    coinPicNum += 1;
    //NSLog([NSString stringWithFormat:@"%d", coinPicNum]);
    if(coinPicNum == [coinPics count])
    {
        coinPicNum = 0;
    }
}

/****************UpdateTubes**********************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Updates the tubes movment. Checks for collisions. And initiates the random numbers used.
 ***********************************************/
-(void)updateTube
{
    
    //collision checking
    for(int i=0; i<[collisionObjectsArray count]; i++)
    {
        UIImageView *Bird=collisionObjectsArray[i];
        
        if(CGRectIntersectsRect(_birdPicture.frame, Bird.frame ))
        {
        
           // [self gameOver];
        }
        
    }
    
    
    
    
    if(_tubeBottomImage.frame.origin.x<10||_tubeBottomImage1.frame.origin.x<10)
    {
        random=(arc4random()%238)*-1;
        coinRand=(arc4random()%396);  //above the ground
    }
    
    
    //IF first tube is halfway off the screen
    if(_tubeBottomImage.frame.origin.x<0)
    {
        
        startTubeTwo=YES;
  
      
    }
    //if second image is halfway off the screen
    if(_tubeBottomImage1.frame.origin.x<0)
    {
        startTubeOne=YES;
    }
    
    
    //if first tube finishes start second and put first back to original spot
    if(_tubeBottomImage.center.x<(_tubeBottomImage.frame.size.width*-1))
    {
        startTubeOne=NO;
        
         _tubeTopImage.frame=CGRectMake(tubeTopX, random, _tubeTopImage.frame.size.width, _tubeTopImage.frame.size.height);
        
         _tubeBottomImage.frame=CGRectMake(tubeBottomX, (random+sizeBetweenTubes+_tubeBottomImage.frame.size.height), _tubeBottomImage.frame.size.width, _tubeBottomImage.frame.size.height);
        
        
        
    }
    
    
     //if second tube finishes start first and put second back to original spot
   if(_tubeBottomImage1.center.x<(_tubeBottomImage1.frame.size.width*-1))
    {
        startTubeTwo=NO;
         _tubeTopImage1.frame=CGRectMake(tubeTopX, random, _tubeTopImage1.frame.size.width, _tubeTopImage1.frame.size.height);
        
    _tubeBottomImage1.frame=CGRectMake(tubeBottomX, (random+sizeBetweenTubes+_tubeBottomImage1.frame.size.height), _tubeBottomImage1.frame.size.width, _tubeBottomImage1.frame.size.height);
        
   }
    
    
    //Movement of the tubes
    if(startTubeOne==YES)
    {
        _tubeBottomImage.frame = CGRectMake(_tubeBottomImage.frame.origin.x+tubeSpeed, _tubeBottomImage.frame.origin.y, _tubeBottomImage.frame.size.width, _tubeBottomImage.frame.size.height);
        
        _tubeTopImage.frame = CGRectMake(_tubeTopImage.frame.origin.x+tubeSpeed, _tubeTopImage.frame.origin.y, _tubeTopImage.frame.size.width, _tubeTopImage.frame.size.height);
        
    }
    
    if(startTubeTwo==YES)
    {
 _tubeBottomImage1.frame = CGRectMake(_tubeBottomImage1.frame.origin.x+tubeSpeed, _tubeBottomImage1.frame.origin.y, _tubeBottomImage1.frame.size.width, _tubeBottomImage1.frame.size.height);
        
    _tubeTopImage1.frame = CGRectMake(_tubeTopImage1.frame.origin.x+tubeSpeed, _tubeTopImage1.frame.origin.y, _tubeTopImage1.frame.size.width, _tubeTopImage1.frame.size.height);
        
    }
    

}




/**********************************************
 PARAMS: NONE
 RETURNS: NONE
 DESCRIPTION: Updates coin movement across the screen.
 ***********************************************/
-(void)updateCoinMovement
{
    
    
        if(_tubeBottomImage.frame.origin.x<160) // 160== half way acroos the screen
        {
            
            startCoinOne=YES;
        }
    
    
   
    
        
        if(startCoinOne==YES)
        {
        _coinPicture.frame=CGRectMake(_coinPicture.frame.origin.x+coinSpeed, _coinPicture.frame.origin.y, _coinPicture.frame.size.width, _coinPicture.frame.size.height);
        }
        if(startCoinTwo==YES)
        {
            _coinPicture1.frame=CGRectMake(_coinPicture1.frame.origin.x+coinSpeed, _coinPicture1.frame.origin.y, _coinPicture1.frame.size.width, _coinPicture1.frame.size.height);
            
        }
    
    
    if(_coinPicture.frame.origin.x<0)
    {
        startCoinTwo=YES;
    }
    if(_coinPicture1.frame.origin.x<0)
    {
        startCoinOne=YES;
    }
   
    if(_coinPicture.frame.origin.x<_coinPicture.frame.size.width*-1)
    {
        startCoinOne=NO;
        _coinPicture.frame=CGRectMake(tubeBottomX, coinRand, _coinPicture.frame.size.width, _coinPicture.frame.size.height);
    }
    if(_coinPicture1.frame.origin.x<_coinPicture1.frame.size.width*-1)
    {
        startCoinTwo=NO;
        _coinPicture1.frame=CGRectMake(tubeBottomX, coinRand, _coinPicture.frame.size.width, _coinPicture.frame.size.height);
    }
    
        
}




- (IBAction)goPressed:(id)sender
{
    if(!go)
    {
        gameLoopTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
        
        
        _coinPicture.frame=CGRectMake(tubeBottomX, coinRand, _coinPicture.frame.size.width, _coinPicture.frame.size.height);
        _coinPicture.hidden=NO;
        _coinPicture1.frame=CGRectMake(tubeBottomX, coinRand, _coinPicture.frame.size.width, _coinPicture.frame.size.height);
        _coinPicture1.hidden=NO;
        
        _tubeBottomImage.frame=CGRectMake(tubeBottomX, tubeBottomY, _tubeBottomImage.frame.size.width, _tubeBottomImage.frame.size.height);
        _tubeBottomImage1.frame=CGRectMake(tubeBottomX, tubeBottomY, _tubeBottomImage1.frame.size.width, _tubeBottomImage1.frame.size.height);
        _tubeTopImage.frame=CGRectMake(tubeTopX, tubeTopY, _tubeTopImage.frame.size.width, _tubeTopImage.frame.size.height);
        _tubeTopImage1.frame=CGRectMake(tubeTopX, tubeTopY, _tubeTopImage1.frame.size.width, _tubeTopImage1.frame.size.height);
        _tubeBottomImage1.hidden=NO;
        _tubeBottomImage.hidden=NO;
        _tubeTopImage1.hidden=NO;
        _tubeTopImage.hidden=NO;
        
        
        
        
        //tubeTimer=[NSTimer scheduledTimerWithTimeInterval:.01 target:(self) selector:@selector(updateTube) userInfo:nil repeats:YES];
        
        //NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
        //groundTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(updateGround) userInfo:Nil repeats:YES];
        //birdFlapTimer = [NSTimer timerWithTimeInterval:0.10 target:self selector:@selector(updateFlaps) userInfo:Nil repeats:YES];
        //[theRunLoop addTimer:groundTimer forMode:NSDefaultRunLoopMode];
        //[theRunLoop addTimer:birdFlapTimer forMode:NSDefaultRunLoopMode];
        go = YES;
        [_goButton setTitle:@"Stop!" forState:UIControlStateNormal];
    }
    else
    {
        [tubeTimer invalidate];
        [groundTimer invalidate];
        [birdFlapTimer invalidate];
        go = NO;
        [_goButton setTitle:@"Go!" forState:UIControlStateNormal];
    }
}

- (IBAction)gravityPressed:(id)sender
{
    if(!gravityOn)
    {
        //NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
        //gravityTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(updateGravity) userInfo:Nil repeats:YES];
        //[theRunLoop addTimer:gravityTimer forMode:NSDefaultRunLoopMode];
        gravityOn = YES;
    }
    else
    {
        //[gravityTimer invalidate];
        gravityOn = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * curTouch = [touches anyObject];
    CGPoint curTouchPoint = [curTouch locationInView:self.view];
    if(CGRectContainsPoint(_startButtonImage.frame, curTouchPoint))
    {
        [_startButtonImage setFrame:CGRectMake(_startButtonImage.frame.origin.x, _startButtonImage.frame.origin.y + 2, _startButtonImage.frame.size.width, _startButtonImage.frame.size.height)];
        startButtonDown = YES;
    }
    else
    {
        birdAccel = 6;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * curTouch = [touches anyObject];
    CGPoint curTouchPoint = [curTouch locationInView:self.view];
    if(startButtonDown && CGRectContainsPoint(_startButtonImage.frame, curTouchPoint))
    {
        [_startButtonImage setFrame:CGRectMake(_startButtonImage.frame.origin.x, _startButtonImage.frame.origin.y - 2, _startButtonImage.frame.size.width, _startButtonImage.frame.size.height)];
        startButtonDown = NO;
        [self goPressed:event];
        [self gravityPressed:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * curTouch = [touches anyObject];
    CGPoint curTouchPoint = [curTouch locationInView:self.view];
    if(startButtonDown && !CGRectContainsPoint(_startButtonImage.frame, curTouchPoint))
    {
        [_startButtonImage setFrame:CGRectMake(_startButtonImage.frame.origin.x, _startButtonImage.frame.origin.y - 2, _startButtonImage.frame.size.width, _startButtonImage.frame.size.height)];
        startButtonDown = NO;
    }
    else if(!startButtonDown && CGRectContainsPoint(_startButtonImage.frame, curTouchPoint))
    {
        [_startButtonImage setFrame:CGRectMake(_startButtonImage.frame.origin.x, _startButtonImage.frame.origin.y + 2, _startButtonImage.frame.size.width, _startButtonImage.frame.size.height)];
        startButtonDown = YES;
    }
}

-(void)makeBirdFall
{
    [UIView animateWithDuration:0.01
            animations:^(void)
            {
                _birdPicture.frame = CGRectMake(_birdPicture.frame.origin.x, birdFall, _birdPicture.frame.size.width, _birdPicture.frame.size.height);
            }
            completion:^(BOOL finished){}];
    if(_birdPicture.frame.origin.y + _birdPicture.frame.size.height >= _ground1.frame.origin.y)
    {
        [self finish];
    }
    birdFall -= birdAccel;
}

-(void)dropBird
{
    birdFall = _birdPicture.frame.origin.y;
    birdAccel = -5;
    fallTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(makeBirdFall) userInfo:nil repeats:YES];
}

-(void)gameOver
{
    [gravityTimer invalidate];
    
    [groundTimer invalidate];
    [tubeTimer invalidate];
    [gameLoopTimer invalidate];
    
    [self dropBird];
}

-(void)finish
{
    [fallTimer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end