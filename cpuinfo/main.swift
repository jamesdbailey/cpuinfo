//
//  main.swift
//  environment
//
//  Created by jdb on 8/15/22.
//

import Foundation

func sysCtl( _ name: String ) -> String {
    var size = 0
    sysctlbyname(name, nil, &size, nil, 0)
    var buff = [CChar](repeating: 0,  count: size)
    sysctlbyname(name, &buff, &size, nil, 0)
    return String(cString: buff)
}

func getSysCtlUInt32( _ name: String ) -> UInt32 {
    let value = sysCtl( name )
    for element in value.unicodeScalars {
        let myInt = element.value
        return myInt
    }
    
    return 0;
}

func getCpus( PerfLevels nLevels: UInt32) {
    var cpus = [Int]()
    for idx in 0..<nLevels {
        let key = "hw.perflevel\(Int(idx)).logicalcpu_max"
        let val = getSysCtlUInt32(key)
        cpus.append( Int(val) )
    }
    
    for idx in 0..<nLevels {
        print( "hw.perflevel\(idx).logicalcpu_max = \(cpus[Int( idx )])")
    }
}

let cpuBrand = "machdep.cpu.brand_string"
let perfLevels = "hw.nperflevels"
print("\(sysCtl(cpuBrand))")
print("PerformanceLevels: \(getSysCtlUInt32( perfLevels ))")
getCpus( PerfLevels: getSysCtlUInt32( perfLevels ) )
