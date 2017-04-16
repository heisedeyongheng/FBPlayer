//
//  ISSBufQueue.h
//  FFMPEGTest
//
//  Created by 健 王 on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>

struct queueObj
{
    void * obj;
    struct queueObj * next;
};

class ISSBufQueue
{
public:
    ISSBufQueue();
    ~ISSBufQueue();
    
    void AddToQueue(void*obj);
    void * GetFromQueue();
public:
    int queueLenght;
private:
    struct queueObj * head;
    struct queueObj * end;
};
