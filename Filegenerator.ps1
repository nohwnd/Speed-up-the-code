Measure-Command {

    $bfn = "plc_log.txt"
    $bs = @(0..24999), @(25000..49999)


    $ll = foreach ($_ in  $bs)<# -ThrottleLimit 2 -Parallel #> {
    $pn = 'PLC_A','PLC_B','PLC_C','PLC_D'
    $ets = @(
        'Sandextrator overload',
        'Conveyor misalignment',
        'Valve stuck',
        'Temperature warning'
    )
    $sc = 'OK','WARN','ERR'
    $r = [System.Random]::new()

        $rg = $_
        foreach ($i in $rg) {
            $ts = [datetime]::now.AddSeconds(-$i).ToString('yyyy-MM-dd HH:mm:ss')
            $plc = $pn[$r.Next(0, $pn.Length)]
            $o = $r.Next(101,121)
            $b = $r.Next(1000,1101)
            $s = $sc[$r.Next(0, $sc.Length)]
            $mt = [math]::Round($r.Next(60, 110) + $r.Next(),2)
            $l = $r.Next(0,101)
        
            if ($r.Next(1,8) -eq 4) {
                $ei = $r.Next(0, $ets.Length)
                if (0 -eq $ei) {
                    $v = $r.Next(1,11)
                    $ms = "ERROR; {0}; {1}; Sandextrator overload; {2}; {3}; {4}; {5}; {6}; {7}" -f $ts, $plc, $v, $s, $o, $b, $mt, $l
                } else {
                    $et =  $ets[$ei]
                    $ms = 'ERROR; {0}; {1}; {2}; ; {3}; {4}; {5}; {6}; {7}' -f $ts, $plc, $et, $s, $o, $b, $mt, $l
                }
            } else {
                $ms = 'INFO; {0}; {1}; System running normally; ; {2}; {3}; {4}; {5}; {6}' -f $ts, $plc, $s, $o, $b, $mt, $l
            }
        
            $ms
        }
    }
    
   [system.io.file]::WriteAllLines($bfn, $ll)
   [console]::writeLine("PLC log file generated.") # looks like this is part of the requirements? othwerwise we can save more time
}

