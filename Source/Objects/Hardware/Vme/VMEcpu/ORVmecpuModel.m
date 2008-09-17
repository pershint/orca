//--------------------------------------------------------
// ORVmecpuModel
// Created by Mark  A. Howe on Tue Feb 07 2006
// Code partially generated by the OrcaCodeWizard. Written by Mark A. Howe.
// Copyright (c) 2006 CENPA, University of Washington. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of 
//Washington at the Center for Experimental Nuclear Physics and 
//Astrophysics (CENPA) sponsored in part by the United States 
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020. 
//The University has certain rights in the program pursuant to 
//the contract and the program should not be copied or distributed 
//outside your organization.  The DOE and the University of 
//Washington reserve all rights in the program. Neither the authors,
//University of Washington, or U.S. Government make any warranty, 
//express or implied, or assume any liability or responsibility 
//for the use of this software.
//-------------------------------------------------------------

#pragma mark ���Imported Files

#import "ORVmecpuModel.h"
#import "ORVmeCrateModel.h"
#import "ORReadOutList.h"
#import "SBC_Link.h"
#import "SBC_config.h"

#pragma mark ���External Strings
NSString* ORVmecpuLock = @"ORVmecpuLock";	

@implementation ORVmecpuModel
- (id) init
{
	self = [super init];
	ORReadOutList* readList = [[ORReadOutList alloc] initWithIdentifier:@"ReadOut List"];
	[self setReadOutGroup:readList];
	[readList release];
	sbcLink = [[SBC_Link alloc] initWithDelegate:self];
	return self;
}

- (void) dealloc
{
	[readOutGroup release];
	[sbcLink release];
	[super dealloc];
}

- (void) wakeUp 
{
	[super wakeUp];
	[sbcLink wakeUp];
}

- (void) sleep 
{
	[super sleep];
	[sbcLink sleep];
}	

- (void) setUpImage
{
	[self setImage:[NSImage imageNamed:@"Vmecpu"]];
}

- (void) makeMainController
{
	[self linkToController:@"SBC_LinkController"];
}

- (void) awakeAfterDocumentLoaded
{
	NS_DURING
		if(!sbcLink){
			sbcLink = [[SBC_Link alloc] initWithDelegate:self];
		}
		[sbcLink connect];
	NS_HANDLER
	NS_ENDHANDLER
}

#pragma mark ���Accessors
- (id) controllerCard
{
	return self;
}

- (SBC_Link*)sbcLink
{
	return sbcLink;
}

- (ORReadOutList*) readOutGroup
{
	return readOutGroup;
}
- (void) setReadOutGroup:(ORReadOutList*)newReadOutGroup
{
	[readOutGroup autorelease];
	readOutGroup=[newReadOutGroup retain];
}


- (NSMutableArray*) children {
	//method exists to give common interface across all objects for display in lists
	return [NSMutableArray arrayWithObject:readOutGroup];
}

#pragma mark ���ORVmeBusProtocol Protocol
- (void) resetContrl
{
	[self reset];
}

- (void) checkStatusErrors
{
	if (![sbcLink isConnected]) {
		[NSException raise: OExceptionVmeAccessError format:[NSString stringWithString:@"SBC not connected."]];
	}
}

#pragma mark ���SBC_Linking protocol

- (NSString*) cpuName
{
	return [NSString stringWithFormat:@"VME CPU (Crate %d)",[self crateNumber]];
}

- (NSString*) sbcLockName
{
	return ORVmecpuLock;
}

- (NSString*) sbcLocalCodePath
{
	return @"Source/Objects/Hardware/Vme/VMEcpu/VME_Readout_Code";
}

- (NSString*) codeResourcePath
{
	return [[self sbcLocalCodePath] lastPathComponent];
}

#pragma mark ���Archival
- (id) initWithCoder:(NSCoder*)decoder
{
	self = [super initWithCoder:decoder];
	[[self undoManager] disableUndoRegistration];
	
	[self setReadOutGroup:  [decoder decodeObjectForKey:@"ReadoutGroup"]];

	sbcLink = [[decoder decodeObjectForKey:@"SBC_Link"] retain];
	if(!sbcLink){
		sbcLink = [[SBC_Link alloc] initWithDelegate:self];
	}
	else [sbcLink setDelegate:self];
	
	//needed only during testing because the readoutgroup was added when the object was already in the config
	if(!readOutGroup){
		ORReadOutList* readList = [[ORReadOutList alloc] initWithIdentifier:@"ReadOut List"];
		[self setReadOutGroup:readList];
		[readList release];
	}
	[[self undoManager] enableUndoRegistration];
	return self;
}

- (void) encodeWithCoder:(NSCoder*)encoder
{
	[super encodeWithCoder:encoder];
	[encoder encodeObject:readOutGroup  forKey:@"ReadoutGroup"];
	[encoder encodeObject:sbcLink		forKey:@"SBC_Link"];
}

- (void) runTaskStarted:(ORDataPacket*)aDataPacket userInfo:(id)userInfo
{
	dataTakers = [[readOutGroup allObjects] retain];									//cache of data takers.

	NSMutableDictionary* extraUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];		
    [extraUserInfo setObject:[NSNumber numberWithBool:YES] forKey:kSBCisDataTaker];		//tell our objects that ORCA is NOT the dataTaker

    NSEnumerator* e = [dataTakers objectEnumerator];
    id obj;
    while(obj = [e nextObject]){
        [obj runTaskStarted:aDataPacket userInfo:extraUserInfo];
    }
    
    //load all the data needed for the eCPU to do the HW read-out.
	[self load_HW_Config];
	[sbcLink runTaskStarted:aDataPacket userInfo:extraUserInfo];
}

-(void) takeData:(ORDataPacket*)aDataPacket userInfo:(id)userInfo
{
	[sbcLink takeData:aDataPacket userInfo:userInfo];
}

- (void) runIsStopping:(ORDataPacket*)aDataPacket userInfo:(id)userInfo
{
    NSEnumerator* e = [dataTakers objectEnumerator];
    id obj;
    while(obj = [e nextObject]){
        [obj runIsStopping:aDataPacket userInfo:userInfo];
    }
	[sbcLink runIsStopping:aDataPacket userInfo:userInfo];
}

- (void) runTaskStopped:(ORDataPacket*)aDataPacket userInfo:(id)userInfo
{
    NSEnumerator* e = [dataTakers objectEnumerator];
    id obj;
    while(obj = [e nextObject]){
        [obj runTaskStopped:aDataPacket userInfo:userInfo];
    }
	[sbcLink runTaskStopped:aDataPacket userInfo:userInfo];
}

- (BOOL) doneTakingData
{
	return [sbcLink doneTakingData];
}

- (void) saveReadOutList:(NSFileHandle*)aFile
{
    [readOutGroup saveUsingFile:aFile];
}

- (void) loadReadOutList:(NSFileHandle*)aFile
{
    [self setReadOutGroup:[[[ORReadOutList alloc] initWithIdentifier:@"cPCI"]autorelease]];
    [readOutGroup loadUsingFile:aFile];
}

- (void) reset
{
    [self performSysReset];
}

- (void) performSysReset
{
    unsigned long registerRead = 0x0;
    [self readLongBlock:&registerRead 
            atAddress:0x404 
            numToRead:1
            withAddMod:0x39
            usingAddSpace:0xFFFF];
    registerRead |= 0x404000;
    
    [self writeLongBlock:&registerRead
            atAddress:0x404 
            numToWrite:1
            withAddMod:0x39
            usingAddSpace:0xFFFF];
    
    NSLog(@"VmecpuModel (crate: %d, card: %d): Performed SYSRESET.\n", [self crateNumber], [self slot]);
}

- (void) load_HW_Config
{
	NSEnumerator* e = [dataTakers objectEnumerator];
	id obj;
	int index = 0;
	SBC_crate_config configStruct;
	
	configStruct.total_cards = 0;

	while(obj = [e nextObject]){
		if([obj respondsToSelector:@selector(load_HW_Config_Structure:index:)]){
			index = [obj load_HW_Config_Structure:&configStruct index:index];
		}
	}
	
	[sbcLink load_HW_Config:&configStruct];
	
}

-(void) readLongBlock:(unsigned long *) readAddress
			atAddress:(unsigned int) vmeAddress
			numToRead:(unsigned int) numberLongs
		   withAddMod:(unsigned short) anAddressModifier
		usingAddSpace:(unsigned short) anAddressSpace
{
	if(![sbcLink isConnected]){
		[NSException raise:@"Not Connected" format:@"Socket not connected."];
	}
	[sbcLink readLongBlock:readAddress
					atAddress:vmeAddress
					numToRead:numberLongs
				   withAddMod:anAddressModifier
				usingAddSpace:anAddressSpace];
}

-(void) writeLongBlock:(unsigned long *) writeAddress
			 atAddress:(unsigned int) vmeAddress
			numToWrite:(unsigned int) numberLongs
			withAddMod:(unsigned short) anAddressModifier
		 usingAddSpace:(unsigned short) anAddressSpace
{
	if(![sbcLink isConnected]){
		[NSException raise:@"Not Connected" format:@"Socket not connected."];
	}
	[sbcLink writeLongBlock:writeAddress
					 atAddress:vmeAddress
					numToWrite:numberLongs
					withAddMod:anAddressModifier
				 usingAddSpace:anAddressSpace];
	
}

	/* readLong is for reading a long from a single address 
	   so that the address never changes, i.e. it does not
	   auto-increment.  We use a specific address space to
	   do this: 0xFF. */
-(void) readLong:(unsigned long *) readAddress
	   atAddress:(unsigned int) vmeAddress
	 timesToRead:(unsigned int) numberLongs
	  withAddMod:(unsigned short) anAddressModifier
   usingAddSpace:(unsigned short) anAddressSpace
{
	if(![sbcLink isConnected]){
		[NSException raise:@"Not Connected" format:@"Socket not connected."];
	}
	[sbcLink readLongBlock:readAddress
			   atAddress:vmeAddress
			   numToRead:numberLongs
			  withAddMod:anAddressModifier
		   usingAddSpace:0xFF];
}

-(void) readByteBlock:(unsigned char *) readAddress
			atAddress:(unsigned int) vmeAddress
			numToRead:(unsigned int) numberBytes
		   withAddMod:(unsigned short) anAddressModifier
		usingAddSpace:(unsigned short) anAddressSpace
{
	if(![sbcLink isConnected]){
		[NSException raise:@"Not Connected" format:@"Socket not connected."];
	}
	[sbcLink readByteBlock:readAddress
					atAddress:vmeAddress
					numToRead:numberBytes
				   withAddMod:anAddressModifier
				usingAddSpace:anAddressSpace];
	
}

-(void) writeByteBlock:(unsigned char *) writeAddress
			 atAddress:(unsigned int) vmeAddress
			numToWrite:(unsigned int) numberBytes
			withAddMod:(unsigned short) anAddressModifier
		 usingAddSpace:(unsigned short) anAddressSpace
{
	if(![sbcLink isConnected]){
		[NSException raise:@"Not Connected" format:@"Socket not connected."];
	}
	[sbcLink writeByteBlock:writeAddress
					 atAddress:vmeAddress
					numToWrite:numberBytes
					withAddMod:anAddressModifier
				 usingAddSpace:anAddressSpace];
	
}

-(void) readWordBlock:(unsigned short *) readAddress
			atAddress:(unsigned int) vmeAddress
			numToRead:(unsigned int) numberWords
		   withAddMod:(unsigned short) anAddressModifier
		usingAddSpace:(unsigned short) anAddressSpace
{
	
	if(![sbcLink isConnected]){
		[NSException raise:@"Not Connected" format:@"Socket not connected."];
	}
	[sbcLink readWordBlock:readAddress
					atAddress:vmeAddress
					numToRead:numberWords
				   withAddMod:anAddressModifier
				usingAddSpace:anAddressSpace];
	
}

-(void) writeWordBlock:(unsigned short *) writeAddress
			 atAddress:(unsigned int) vmeAddress
			numToWrite:(unsigned int) numberWords
			withAddMod:(unsigned short) anAddressModifier
		 usingAddSpace:(unsigned short) anAddressSpace
{
	if(![sbcLink isConnected]){
		[NSException raise:@"Not Connected" format:@"Socket not connected."];
	}
	[sbcLink writeWordBlock:writeAddress
					 atAddress:vmeAddress
					numToWrite:numberWords
					withAddMod:anAddressModifier
				 usingAddSpace:anAddressSpace];
}

@end
