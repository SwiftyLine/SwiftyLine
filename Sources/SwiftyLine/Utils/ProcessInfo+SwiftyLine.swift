//
//  Process+SwiftyLine.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/4/11.
//

import Foundation

extension ProcessInfo {
    
    #if DEBUG
    var isAttached: Bool {
        var info = kinfo_proc()
        var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    #else
    var isAttached: Bool { false }
    #endif
}

/**
 
 #include <sys/sysctl.h>

 BOOL CLProcessIsAttached(void) {
     size_t size = sizeof(struct kinfo_proc);
     struct kinfo_proc info;
     int ret, name[4];
     memset(&info, 0, sizeof(struct kinfo_proc));
     name[0] = CTL_KERN;
     name[1] = KERN_PROC;
     name[2] = KERN_PROC_PID;
     name[3] = getpid();
     if ((ret = (sysctl(name, 4, &info, &size, NULL, 0)))) {
         return ret; /* sysctl() failed for some reason */
     }
     return (info.kp_proc.p_flag & P_TRACED) ? YES : NO;
 }

 */
