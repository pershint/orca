//
//  ORRunModel.h
//  Orca
//
//  Created by Mark Howe on Tue Dec 24 2002.
//  Copyright � 2002 CENPA, University of Washington. All rights reserved.
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



#import "ORBaseDecoder.h"
#import "ORDataChainObject.h"

#pragma mark ���Forward Declarations
@class ORDataPacket;
@class ORDataSet;
@class ORRunScript;
@class ORDataTypeAssigner;
@class ORRunScriptModel;

@interface ORRunModel :  ORDataChainObject {
    @private
        unsigned long 	runNumber;

        NSCalendarDate* startTime;
        NSTimer* 		timer;
        NSTimer* 		heartBeatTimer;

        NSTimeInterval  elapsedTime;
        NSTimeInterval  timeToGo;
        NSTimeInterval  timeLimit;
        BOOL            timedRun;
        BOOL            repeatRun;
        BOOL            quickStart;
        ORDataPacket*	dataPacket;
        BOOL            ignoreRepeat;
        unsigned long	runType;
        BOOL            remoteControl;
        unsigned long   dataId;
       
        NSString*		definitionsFilePath;
        NSString* 		dirName;
        id              client;
        unsigned long	exceptionCount;

        BOOL			forceFullInit;
		BOOL			_forceRestart;
		BOOL			_ignoreMode;
		BOOL			_wasQuickStart;
		BOOL			_nextRunWillQuickStart;
		BOOL			_ignoreRunTimeout;
		unsigned long	_currentRun;
        int				runningState;
        ORDataTypeAssigner* dataTypeAssigner;
        unsigned long lastRunNumberShipped;
        NSMutableArray* runTypeNames;
        BOOL        remoteInterface;
		BOOL		runPaused;
		
		//thread control variables
		BOOL		timeToStopTakingData;
		BOOL		dataTakingThreadRunning;
		float		totalWaitTime;

		ORAlarm*    runFailedAlarm;
		ORAlarm*    runStoppedByVetoAlarm;
	
		ORRunScriptModel* startScript;
		ORRunScriptModel* shutDownScript;

		NSString* startScriptState;
		NSString* shutDownScriptState;
}


#pragma mark ���Initialization
- (void) makeConnectors;

#pragma mark ���Accessors
- (NSString*) shutDownScriptState;
- (void) setShutDownScriptState:(NSString*)aShutDownScriptState;
- (NSString*) startScriptState;
- (void) setStartScriptState:(NSString*)aStartScriptState;
- (ORRunScriptModel*) shutDownScript;
- (void) setShutDownScript:(ORRunScriptModel*)aShutDownScript;
- (ORRunScriptModel*) startScript;
- (void) setStartScript:(ORRunScriptModel*)aStartScript;
- (BOOL) isRunning;
- (BOOL) runPaused;
- (void) setRunPaused:(BOOL)aFlag;
- (BOOL) remoteInterface;
- (void) setRemoteInterface:(BOOL)aRemoteInterface;
- (NSArray*) runTypeNames;
- (void) setRunTypeNames:(NSMutableArray*)aRunTypeNames;
- (unsigned long)   getCurrentRunNumber; //file access
- (unsigned long)   runNumber;
- (void)	    setRunNumber:(unsigned long)aRunNumber;
- (NSString*) startTimeAsString;
- (NSCalendarDate*) startTime;
- (void)	setStartTime:(NSCalendarDate*) aDate;
- (NSTimeInterval)  elapsedTime;
- (NSString*) elapsedTimeString;
- (void)	setElapsedTime:(NSTimeInterval) aValue;
- (NSTimeInterval)  timeToGo;
- (void)	setTimeToGo:(NSTimeInterval) aValue;
- (BOOL)	timedRun;
- (void)	setTimedRun:(BOOL) aValue;
- (BOOL)	repeatRun;
- (void)	setRepeatRun:(BOOL) aValue;
- (NSTimeInterval)timeLimit;
- (void)	setTimeLimit:(NSTimeInterval) aValue;
- (ORDataPacket*)dataPacket;
- (void)	setDataPacket:(ORDataPacket*)aDataPacket;
- (void)	setDirName:(NSString*)aFileName;
- (NSString*)   dirName;
- (unsigned long)exceptionCount;
- (void)	incExceptionCount;
- (void)	clearExceptionCount;
- (unsigned long)runType;
- (void)	setRunType:(unsigned long)aMask;
- (BOOL)	remoteControl;
- (void)	setRemoteControl:(BOOL)aState;
- (NSString*)   commandID;
- (BOOL)        nextRunWillQuickStart;
- (void)        setNextRunWillQuickStart:(BOOL)state;
- (int)		runningState;
- (void)	setRunningState:(int)aRunningState;
- (void)	setForceRestart:(BOOL)aState;
- (BOOL)	quickStart;
- (void)	setQuickStart:(BOOL)flag;
- (NSString *)  definitionsFilePath;
- (void)	setDefinitionsFilePath:(NSString *)aDefinitionsFilePath;
- (ORDataTypeAssigner *) dataTypeAssigner;
- (void) setDataTypeAssigner: (ORDataTypeAssigner *) DataTypeAssigner;
- (unsigned long) dataId;
- (void) setDataId: (unsigned long) DataId;
- (void) setOfflineRun:(BOOL)flag;
- (BOOL) offlineRun;

#pragma mark ���Run Modifiers
- (void) remoteStartRun:(unsigned long)aRunNumber;
- (void) remoteRestartRun:(unsigned long)aRunNumber;
- (void) remoteHaltRun;
- (void) remoteStopRun:(BOOL)nextRunState;
- (void) forceHalt;
- (void) runAbortFromScript;

- (void) startRun:(BOOL)doInit;
- (void) startRun;
- (void) restartRun;
- (void) stopRun;
- (void) haltRun;

- (NSDictionary*) dataRecordDescription;
- (void) takeData;
- (void) runStarted:(BOOL)doInit;
- (NSMutableDictionary*) addParametersToDictionary:(NSMutableDictionary*)dictionary;

- (void) incrementTime:(NSTimer*)aTimer;
- (void) sendHeartBeat:(NSTimer*)aTimer;

- (void) needMoreTimeToStopRun:(NSNotification*)aNotification;
- (void) vetosChanged:(NSNotification*)aNotification;
- (void) runModeChanged:(NSNotification*)aNotification;
- (void) vmePowerFailed:(NSNotification*)aNotification;
- (void) gotForceRunStopNotification:(NSNotification*)aNotification;
- (void) gotRequestedRunStopNotification:(NSNotification*)aNotification;
- (void) gotRequestedRunHaltNotification:(NSNotification*)aNotification;
- (void) requestedRunHalt:(id)userInfo;
- (void) requestedRunStop:(id)userInfo;
- (BOOL) readRunTypeNames;
- (NSString*) shortStatus;

- (id)   initWithCoder:(NSCoder*)decoder;
- (void) encodeWithCoder:(NSCoder*)encoder;

@end


@interface ORRunDecoderForRun : ORBaseDecoder
{}
- (unsigned long) decodeData:(void*)someData fromDataPacket:(ORDataPacket*)aDataPacket intoDataSet:(ORDataSet*)aDataSet;
- (NSString*) dataRecordDescription:(unsigned long*)dataPtr;
@end

@interface NSObject (SpecialDataTakingFinishUp)
- (void) runIsStopping:(ORDataPacket*)aDataPacket userInfo:(id)userInfo;
- (BOOL) doneTakingData;
@end

extern NSString* ORRunModelShutDownScriptStateChanged;
extern NSString* ORRunModelStartScriptStateChanged;
extern NSString* ORRunModelShutDownScriptChanged;
extern NSString* ORRunModelStartScriptChanged;
extern NSString* ORRunTimedRunChangedNotification;
extern NSString* ORRunRepeatRunChangedNotification;
extern NSString* ORRunTimeLimitChangedNotification;
extern NSString* ORRunElapsedTimeChangedNotification;
extern NSString* ORRunStartTimeChangedNotification;
extern NSString* ORRunTimeToGoChangedNotification;
extern NSString* ORRunNumberChangedNotification;
extern NSString* ORRunRemoteControlChangedNotification;

extern NSString* ORRunNumberDirChangedNotification;
extern NSString* ORRunModelExceptionCountChangedNotification;
extern NSString* ORRunMaskChangedNotification;
extern NSString* ORRunTypeChangedNotification;
extern NSString* ORRunQuickStartChangedNotification;
extern NSString* ORRunDefinitionsFileChangedNotification;

extern NSString* ORRunNumberLock;
extern NSString* ORRunTypeLock;
extern NSString* ORRunRemoteInterfaceChangedNotification;
