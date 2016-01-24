//
//  WolframTableViewCell.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/11/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "WolframTableViewCell.h"

@implementation WolframTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    NSLog(@"POD ID LABEL ON TABLE VIEW CELL: %@", self.podIDLabel.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
