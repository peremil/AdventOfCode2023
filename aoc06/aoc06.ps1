
class BoatRace {
    $time
    $dist
    [int]$x
    [int]$y
    $count
    $cwinCount
    
    BoatRace ($in){
        $this.time = @()
        $this.dist = @()
        $lwin = @()
        $lcard = @()
        $this.cwinCount = @()

        foreach ($d in $in){
            $din = $d -replace '\s+', ' ' -split ":" 
            # -replace '\s+', ' '
            if($din[0] -contains "Time"){
                #load times
                #$di = 
                $this.time = $din[1].trim().split(" ")
            }
            elseif($din[0] -contains "Distance"){
                #load distance
                $this.dist = $din[1].trim().split(" ")
            }
        }

    }
    [int]checkB () {
        [int64]$t = $this.time -join ""
        [int64]$d = $this.dist -join ""
        $c = 0
        for($i = 0;$i -le $t ;$i++){
            $run = $t - $i
            $dis = $run * $i
            if($dis -gt $d){
                $c++
            }
        }
        write-host "Time " $t
        write-host "Dist " $d
        return $c
    }

    [int]checkA () {
        $max = 1
        $p = 0
        $c = 0
        foreach($t in $this.time){
            $d = $this.dist[$p]
            $c = 0
            for($i = 0;$i -le $t ;$i++){
                $run = $t - $i
                $dis = $run * $i
                if($dis -gt $d){
                    $c++
                }
            }
            #write-host $c
            $max = $max * $c
            $p++
            
        }
        return $max
    }

 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 65238610 -Fel, för lågt

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0
 
$count = [BoatRace]::new($indata).checkB()

$count