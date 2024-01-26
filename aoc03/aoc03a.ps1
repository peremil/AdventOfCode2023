
#Hur kan man jämföra ett värde med omringande värden.
#
# ...
# .8.
# #..
#

class Gearr {
    $data
    [int]$x
    [int]$y
    $count
    
    Gearr ($in){
         $this.data = @()
         $i = 0
         foreach ($d in $in){
             $d.trim()
             $this.data += ,($d.ToCharArray())
             #$this.data[$i] = @($d.ToCharArray())
             $i++
         }
     }
     
     [int]checkA () {
        $ut = 0
        $c = 0

        for($i = 0;$i -lt $this.data.count;$i++){
            #if($i -eq 4){break}
            $n = $false
            $d = @()
            $use = $false
            #write-host "Test rad $i"
            for($r = 0;$r -lt $this.data[$i].count;$r++){
                
                if($this.data[$i][$r] -match "\d"){
                    $n = $true
                    $d += $this.data[$i][$r]

                    if(!$use -and $this.checkN($i,$r)){
                        $use = $true
                    }
                }else{
                    if($n -and $use){
                        [int]$num = $d -join ""
                        $ut += $num
                    }
                    $n = $false
                    $use = $false
                    $d = @()
                }
                if($r -eq $this.data[$i].count -1 -and $use){
                    [int]$num = $d -join ""
                    $ut += $num
                }
            }
            
            $c ++
        }
        return $ut
     }

    [int]checkB () {
        $ut = 0
        $c = 0

        for($i = 0;$i -lt $this.data.count;$i++){
            #if($i -eq 4){break}
            $n = $false
            $d = @()
            $use = $false
            #write-host "Test rad $i"
            for($r = 0;$r -lt $this.data[$i].count;$r++){
                
                if($this.data[$i][$r] -match "\*"){
                    $n = $true
                    $d += $this.data[$i][$r]
                    #write-host "fiska runt tjärnan "
                    $nytal = $this.checkS($i,$r)
                    if($nytal -gt 1){
                        #adda
                        $ut += $nytal
                    }
                }else{
                }
           }
            $c ++
        }
        return $ut
     }
     [int32]checkS($r,$p){
        #Hitta 2 individual numbers
        #$t = @()
        $ut = @{}
        $ut.clear()
        #$t += $this.data[$r-1][$p-1]
        for($a = $r-1; $a -le $r +1; $a++){
            if($a -ge 0 -and $a -le $this.data.count){
                for($b = $p-1;$b -le $p+1;$b++){
                    if($b -ge 0 -and $b -lt $this.data[$a].count){
                        if($this.data[$a][$b] -match "[0-9]"){
                            #write-host "Check "  $this.data[$a][$b]
                            #Fiska
                            $nf = $this.fishNo($a,$b)
                            foreach($k in $nf.keys){
                                #write-host "hittat " $nf[$k] på $k
                                if(!$ut.ContainsKey($k)){
                                    $ut[$k] = $nf[$k]
                                }
                            }
                            #return $true
                        }else{
                            #write-host "skipped "  $this.data[$a][$b]
                        }
                    }
                }
            }
        }
        #write-host "Hittade " $ut.Count
        if($ut.Count -eq 2){
            $ret = 1
            foreach($k in $ut.keys){
                $ret = $ret * $ut[$k]
            }
            #write-host "stjarnan ger raknat " $ret
            return $ret
        }
        #write-host "stjärnan ger " $ut
        return 1
     }

    [object]fishNo($r,$p){
        $sp = 0
        $skey = ""
        $tp = $p
        $end = $false
        while(!$end){
            if($this.data[$r][$tp] -match "[^0-9]"){
                $sp = $tp+1
                $end = $true
            }
            $tp --
        }
        $ep = 0
        $tal = ""
        $ut = @{}
        $tp = $sp
        while($ep -eq 0){
            #write-host "startar på $sp"
            if($tp -le $this.data[$r].length -and $this.data[$r][$tp] -match "[0-9]"){
                #write-host "addar " $this.data[$r][$tp]
                $tal += $this.data[$r][$tp]
            }else{
                #write-host "skickar tillbaka $tal"
                [string]$skey = [string]$r +'x'+ [string]$sp
                $ut[$skey] = [int32]$tal

                if($tp -ge $p +1){
                    return $ut
                }
                $tal = ""
            }
            $tp ++
        }

        return $ut

    }

     [bool]checkN($r,$p){
        #$t = @()
        #$t += $this.data[$r-1][$p-1]
        for($a = $r-1; $a -le $r +1; $a++){
            if($a -ge 0 -and $a -le $this.data.count){
                for($b = $p-1;$b -le $p+1;$b++){
                    if($b -ge 0 -and $b -lt $this.data[$a].count){
                        if($this.data[$a][$b] -match "[^a-zA-Z0-9.]"){
                            #write-host "Check "  $this.data[$a][$b]
                            return $true
                        }else{
                            #write-host "skipped "  $this.data[$a][$b]
                        }
                    }
                }
            }
        }
        return $false
     }

     [int]Go ($x,$y){
         $this.x = $x
         $this.y = $y
         $c = 0
         $p = $this.x
         $pmax = $this.data[0].length
         for($i=$this.y;$i -lt $this.data.count;$i +=$this.y){
             if($this.data[$i][$p] -eq "#"){
                 $c++
             }
             $p += $this.x
             if($p -ge $pmax){
                 $p = $p - $pmax
             }   
         }
 
         return $c
     }
 
 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 65238610 -Fel, för lågt

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0
 
$count = [Gearr]::new($indata).checkB()
 
$count