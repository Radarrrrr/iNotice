//
//  ToDoCell.m
//  Radar Use
//
//  Created by Radar on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToDoCell.h"
#import "ToDoInfo.h"


@implementation ToDoCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        
        self.backgroundColor = [UIColor clearColor];
        
//        UIView *bgView = [[[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, to_do_cell_height-10)] autorelease];
//        bgView.backgroundColor = [UIColor whiteColor];
//        bgView.alpha = 0.5;
//        [self.contentView addSubview:bgView];
        
//      self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//      cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		
		//add _titleLabel
		_descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCR_WIDTH-30-10, to_do_cell_height)];
		_descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.userInteractionEnabled = NO;
		_descLabel.textAlignment = NSTextAlignmentLeft;
		_descLabel.font = DDFONT_B(14);
		_descLabel.textColor = DDCOLOR_TEXT_A;
        _descLabel.numberOfLines = 2;
		[self.contentView addSubview:_descLabel];
        
        //add _dateLabel
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_WIDTH-100-10, to_do_cell_height-14, 100, 14)];
		_dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.userInteractionEnabled = NO;
		_dateLabel.textAlignment = NSTextAlignmentRight;
		_dateLabel.font = DDFONT_B(10);
		_dateLabel.textColor = DDCOLOR_TEXT_C;
		[self.contentView addSubview:_dateLabel];
        
        //add _indexLabel
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (to_do_cell_height-13)/2, 13, 13)];
		_indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.userInteractionEnabled = NO;
		_indexLabel.textAlignment = NSTextAlignmentCenter;
		_indexLabel.font = DDFONT_B(10);
		_indexLabel.textColor = RGB(250, 40, 60);
        [DDFunction addRadiusToView:_indexLabel radius:4];
        [DDFunction addBorderToView:_indexLabel color:RGB(250, 40, 60) lineWidth:1];
		[self.contentView addSubview:_indexLabel];

        
        //加分隔线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, to_do_cell_height-0.5, SCR_WIDTH-20, 0.5)];
        line.backgroundColor = DDCOLOR_LINE_A;
        [self.contentView addSubview:line];
        [line release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    
//    float twidth = 300;
//    if(editing)
//    {
//        twidth = 225;
//    }
//    
//    CGRect dframe = _descLabel.frame;
//    if(dframe.size.width != twidth)
//    {
//        dframe.size.width = twidth;
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            _descLabel.frame = dframe;
//        }];
//    }
//}

- (void)dealloc {

	[_descLabel release];
    [_dateLabel release];
    [_indexLabel release];

    [super dealloc];
}




#pragma mark -
#pragma mark in use functions



#pragma mark -
#pragma mark out use functions
-(void)setCellData:(id)data
{    
    if(!data) return;
    if(![data isKindOfClass:[ToDoInfo class]]) return;
	
    ToDoInfo *info = (ToDoInfo*)data;
	_descLabel.text = info.infoDesc;
    _dateLabel.text = info.createTime;
    
    
    
	//设定contentview的高度，这个很重要，关系到外部tableview的cell的高度设定多高，那个高度就是从这里来的
	float height = to_do_cell_height;
	
	CGRect newRect = self.contentView.frame;
	newRect.size.height = height;
	
	self.contentView.frame = newRect;
	self.frame = newRect;
}

- (void)setCellIndexPath:(NSIndexPath*)indexPath
{
    if(!indexPath) return;
    
    _indexLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row+1];
    
}



@end
