class Map {
    $SStart
    $DStart
    $MapL
    $Name

    Map($in){
        $this.name = $in
        $this.SStart = @()
        $this.DStart = @()
        $this.MapL = @()
    }

    load($in){
        $x = $in.split(" ")
        $this.SStart += [int64]$x[1]
        $this.DStart += [int64]$x[0]
        $this.MapL += [int64]$x[2]
    }

    [string]GetName(){
        return $this.Name
    }

    [int64]test([int64]$s){
        #write-host "Testar om $s" $this.Name
        for($i = 0;$i -lt $this.SStart.length;$i++){
            #write-host "Testar om $s finns mellan " $this.SStart[$i] " och " ($this.SStart[$i] + $this.Mapl[$i])
            if($s -ge $this.SStart[$i] -and $s -lt $this.SStart[$i] + $this.Mapl[$i]){
                #Write-host "Detta: " $this.SStart[$i] " - " $this.DStart[$i] " for " $this.Name
                $np = $this.SStart[$i] - $this.DStart[$i]
                #write-host "stega " $np
                #write-host "Pang " $s " blir " ($s - $np)

                return ($s - $np)
            }
        }
        return  $s
    }

    [int64]testRx([int64]$s){
        #write-host "Testar om $s" $this.Name
        for($i = 0;$i -lt $this.DStart.length;$i++){
            #write-host "Testar om $s finns mellan " $this.SStart[$i] " och " ($this.SStart[$i] + $this.Mapl[$i])
            if($s -ge $this.DStart[$i] -and $s -lt $this.DStart[$i] + $this.Mapl[$i]){
                #Write-host "Detta: " $this.SStart[$i] " - " $this.DStart[$i] " for " $this.Name
                $np = $this.DStart[$i] - $this.SStart[$i]
                #write-host "stega " $np
                #write-host "Pang " $s " blir " ($s - $np)

                return ($s - $np)
            }
        }
        return  $s
    }

    [int64]testR([int64[][]]$s){
        #In med en range från - till
        #Org $s 

        #write-host "Testar om $s" $this.Name
        for($i = 0;$i -lt $this.DStart.length;$i++){
            #write-host "Testar om $s finns mellan " $this.SStart[$i] " och " ($this.SStart[$i] + $this.Mapl[$i])
            if($s -ge $this.DStart[$i] -and $s -lt $this.DStart[$i] + $this.Mapl[$i]){
                #Write-host "Detta: " $this.SStart[$i] " - " $this.DStart[$i] " for " $this.Name
                $np = $this.DStart[$i] - $this.SStart[$i]
                #write-host "stega " $np
                #write-host "Pang " $s " blir " ($s - $np)

                return ($s - $np)
            }
        }
        return  $s
    }
}

class MapV2 {
    $SStart
    $DStart
    $MapL
    $MapR
    $Name

    MapV2($in){
        $this.name = $in
        [int64[]]$this.SStart = @()
        [int64[]]$this.DStart = @()
        [int64[]]$this.MapL = @()
        [int64[]]$this.MapR = @()
    }

    load($in){
        $x = $in.split(" ")
        [int64]$Start += [int64]$x[1]
        [int64]$Dest += [int64]$x[0]
        [int64]$Range += [int64]$x[2]

        $end = $start +$Range
        $diff = $start - $dest
        $this.MapR += ,@($Start,$End,$Diff)
    }

    [string]GetName(){
        return $this.Name
    }

    [int64]test($s){
        
        if($this.SStart -contains $s){
            $i = [array]::indexOf($this.SStart,$s)
            #$t = [array]::indexOf($this.SStart,78)
            #$i = $this.SStart.indexOf($s)
            #write-host "Treaff p" $i
            #write-host "Treaff t" $t
            #write-host "Treaff v" $s.GetType()
            #write-host "Treaff v" $this.SStart[31].GetType()
            #write-host "Treaff v" $s " blir " $this.DStart[$i]
            return $this.DStart[$i]
        }

        return  $s
    }

    [int64]testR($s){
        
        if($this.DStart -contains $s){
            $i = [array]::indexOf($this.SStart,$s)
            #$t = [array]::indexOf($this.SStart,78)
            #$i = $this.SStart.indexOf($s)
            #write-host "Treaff p" $i
            #write-host "Treaff t" $t
            #write-host "Treaff v" $s.GetType()
            #write-host "Treaff v" $this.SStart[31].GetType()
            #write-host "Treaff v" $s " blir " $this.DStart[$i]
            return $this.DStart[$i]
        }

        return  $s
    }

}

class Mapping {
    $Seeds
    $maps
    $seedA

    Mapping ($in){
        $this.maps = @()
        $this.seedA
        $i = 0
        $m = -1
        foreach ($d in $in){
            if($d -Match "seeds:"){
                $this.Seeds = ($d.split(":")[1].trim().split(" "))
                #write-host "Seeds " $this.Seeds
            }
            elseif($d -Match "map:"){
                $this.maps += [MapV2]::new($d -split " map:")
                $m++
                #write-host $this.maps[$m].GetName()
            }
            elseif($d -match "[0-9]"){
                #write-host "Rad "$d 
                #write-host $this.maps[$m].GetName()
                $this.maps[$m].load($d)
            }
        }
        write-host "Maps done"
        #write-host "Maps " $this.maps[0].SStart
        #write-host "Maps " $this.maps[0].DStart
        

     }

     [int64]checkA () {
        $lo = $null
        foreach($s in $this.Seeds){
            #write-host "Seed " $s
            $x = $s
            $lo = $null
            $hmm = "$s "
            foreach($map in $this.maps){
                $x = $map.test($x)
                #$hmm += "- $x "
            }
            if($lo -eq $null -or $lo -gt $x){
                $lo = $x
            } 
            write-host "Seed " $x " via " $hmm
        }
        return $lo
        #2369219742 Too high
     }

     [int64]checkB () {
        $lo = $null
        $dist = @()
        [int64]$f = 0
        [int64]$t = 0
        $go = $false
        foreach($s in $this.Seeds){
            #write-host "Seed " $s
            if($f -eq 0){
                $f = $s
            }elseif($t -eq 0){
                #write-host "Seed " $s
                $t = $f + $s -1
                $go = $true
            }
            
            if($go){
                
                $dist += $this.checkMapR(@($f,$t))

                $f = 0
                $t = 0
                $go = $false
                #return ($dist | measure-object -Minimum).Minimum
            }

            
            #write-host "Seed " $s " via " $hmm
        }
        #write-host $dist.length
        $lo = ($dist | measure-object -Minimum).Minimum
        
        return $lo
        #2369219742 Too high
     }
    [int64]checkBR () {
        $find = $true
        $lo =0
        $x =20000001
        while($find){
            $r = $this.checkMapR($x)
            #write-host "Crazy but $x gives  $r "
            #is $r in seed range
            if($r -gt 0 -and $this.checkSeedR($r)){
                return $x
            }

            $x ++
            if($x -gt 25000000){
                $find = $false
                $lo = $x
            }
        }
        return $lo
        #2369219742 Too high
    }

    [bool]checkSeedR($x){
        $go = $false
        [int64]$f = 0
        [int64]$t = 0
        
        foreach($s in $this.Seeds){
            if($f -eq 0){
                $f = $s
            }elseif($t -eq 0){
                #write-host "Seed " $s
                $t = $f + $s -1
                $go = $true
            }
            if($go){
                #write-host "check $x"
                if($x -ge $f -and $x -le $t){
                    write-host "Found $x mellan $f and $t "
                    return $true
                }else{
                    $go = $false
                    $f = 0
                    $t = 0
                }
            } 
        }
        return $false
    }

    [int64]checkMap($x){
        foreach($map in $this.maps){
            $x = $map.test($x)
        }
        return $x
    }
    [int64]checkMapR($r){
        $nMap=@()
        for($i = $this.maps.length -1 ; $i -ge 0; $i--){
            $x = $this.maps[$i].testR($x)
        }
        return $x
    }

    [int64]checkMapRXX($x){
        for($i = $this.maps.length -1 ; $i -ge 0; $i--){
            $x = $this.maps[$i].testR($x)
        }
        return $x
    }
 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 65238610 -Fel, för lågt

#$dataFil = "$mypath\indata.txt"
$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0
 
$count = [Mapping]::new($indata).checkB()
 
$count