
class Fence {
    $data
    $nestM
    #$move
    [int]$psx
    [int]$psy
    
    Fence ($in){
        $this.data = @()
        $i = 0
        foreach ($d in $in){
            $this.data += ,$d.ToCharArray()
            $t = @(0..($d.length-1) | % {'o'})
            $this.nestM += ,$t
            if($this.data[$i] -Contains 'S'){
                Write-host "hittat s "
                $this.psy = $i
                $this.psx = [array]::indexof($this.data[$i],[char]'S')
            }
        $i++
        }
        Write-host "S hittas p y " $this.psy " x " $this.psx
        #$this.drawit()
    }
     [int]checkB () {
        #$move =@($this.psy,$this.psx)
        $move =@()
        $ut = 0
        #Hitta första anslutning
        $cs = $this.CheckFS()
        write-host "startar sedan med " $cs
        #$move += ,@(($this.psy+$cs[0]),($this.psx+$cs[1]))
        $move = @(($this.psy+$cs[0]),($this.psx+$cs[1]))
        $c = 0
        $d =""
        $go= $true
        while($go){
            #$mark = $this.nestM[$move[0]][$move[1]]
            $mark = $this.data[$move[0]][$move[1]]
            #$write-host $mark
            $this.nestM[$move[0]][$move[1]] = 'x'
            if($cs[0] -eq -1){$d='U'}elseif($cs[1] -eq 1){$d='R'}elseif($cs[0] -eq 1){$d='D'}elseif($cs[1] -eq -1){$d='L'}
            if($mark -eq '-' -or $mark -eq '|'){$this.markNB(@($move[0],$move[1]),$mark, $d)}
            elseif($mark -match "[LJ7F]"){$this.markNBC(@($move[0],$move[1]),$mark, $d)}
            $cs = $this.CheckNF($move,$d)
            $move[0] += $cs[0]
            $move[1] += $cs[1]
            #Märk grannarna!
            #$move += ,@(($move[$c][0]+$cs[0]),($move[$c][1]+$cs[1]))

            #write-host "just nu " $this.data[$move[$c][0]][$move[$c][1]] " dir " $d
            if($this.data[$move[0]][$move[1]] -eq 'S'){
                write-host "Tillbaka till S " $c
                $this.nestM[$move[0]][$move[1]] = 'x'
                $ut = ($c+1)/2 
                $go = $false
            }
            $c++
            if($c -gt 1000000){
                write-host "just nu " $move
                write-host "just nu " $this.data[$move[0]][$move[1]] " dir " $d
                if($c -gt 10010){
                    $go = $false
                }
                
            }
        }
        #$this.drawitX()
        $this.drawit()
        return $ut
     }
    
    markNB($pos, $m, $d){
        #$this.nestM
        #write-host "Marker en granne"
        switch ($d) {
            'U' {if($pos[1] -ne 0 -and $this.nestM[$pos[0]][$pos[1]-1] -ne 'x'){$this.nestM[$pos[0]][$pos[1]-1]='I'};if($pos[1] -lt $this.nestM[$pos[0]].length-1 -and $this.nestM[$pos[0]][$pos[1]+1] -ne 'x'){$this.nestM[$pos[0]][$pos[1]+1]='U'}}
            'D' {if($pos[1] -ne 0 -and $this.nestM[$pos[0]][$pos[1]-1] -ne 'x'){$this.nestM[$pos[0]][$pos[1]-1]='U'};if($pos[1] -lt $this.nestM[$pos[0]].length-1 -and $this.nestM[$pos[0]][$pos[1]+1] -ne 'x'){$this.nestM[$pos[0]][$pos[1]+1]='I'}}
            'L' {if($pos[0] -ne 0 -and $this.nestM[$pos[0]-1][$pos[1]] -ne 'x'){$this.nestM[$pos[0]-1][$pos[1]]='U'};if($pos[0] -lt $this.nestM.length -1 -and $this.nestM[$pos[0]+1][$pos[1]] -ne 'x'){$this.nestM[$pos[0]+1][$pos[1]]='I'}}
            'R' {if($pos[0] -ne 0 -and $this.nestM[$pos[0]-1][$pos[1]] -ne 'x'){$this.nestM[$pos[0]-1][$pos[1]]='I'};if($pos[0] -lt $this.nestM.length -1 -and $this.nestM[$pos[0]+1][$pos[1]] -ne 'x'){$this.nestM[$pos[0]+1][$pos[1]]='U'}}
            Default {}
        }
    }
    markNBC($pos, $m, $d){
        #$this.nestM
        #write-host "Marker en granne"
        $s = '+'
        switch ($m) {
            'L' {
                    if($d -eq 'D'){$s = 'U'}
                    elseif($d -eq 'L'){$s = 'I'}
                    $this.markPos(@($pos[0],($pos[1]-1)),$s)
                    $this.markPos(@(($pos[0]-1),($pos[1]-1)),$s)
                    $this.markPos(@(($pos[0]+1),$pos[1]),$s)
                }
            'J' {                    
                    if($d -eq 'D'){$s = 'I'}
                    elseif($d -eq 'R'){$s = 'U'}
                    $this.markPos(@($pos[0],($pos[1]+1)),$s)
                    $this.markPos(@(($pos[0]+1),($pos[1]+1)),$s)
                    $this.markPos(@(($pos[0]+1),$pos[1]),$s)
                }
            '7' {
                    if($d -eq 'U'){$s = 'U'}
                    elseif($d -eq 'R'){$s = 'I'}
                    $this.markPos(@($pos[0],($pos[1]+1)),$s)
                    $this.markPos(@(($pos[0]-1),($pos[1]+1)),$s)
                    $this.markPos(@(($pos[0]-1),$pos[1]),$s)
                }
            'F' {
                    if($d -eq 'U'){$s = 'I'}
                    elseif($d -eq 'L'){$s = 'U'}
                    $this.markPos(@($pos[0],($pos[1]-1)),$s)
                    $this.markPos(@(($pos[0]-1),($pos[1]-1)),$s)
                    $this.markPos(@(($pos[0]-1),$pos[1]),$s)
                }
            Default {}
        }
    }

    markPos($pos,$s){
        if($pos[0] -gt -1 -and $pos[1] -gt -1 -and  $pos[0] -lt $this.nestM.length -and  $pos[1] -lt $this.nestM[$pos[0]].length -and  $this.nestM[$pos[0]][$pos[1]] -ne 'x'){$this.nestM[$pos[0]][$pos[1]]=$s}
    }

    drawit(){
        for($x = 0;$x -lt $this.nestM.length;$x++){
            for($y = 0;$y -le $this.nestM[$x].length;$y++){
                if($this.nestM[$x][$y] -eq 'o'){
                    #write-host "kollar, här var det ostart"
                    if($x -eq 0 -or $y -eq 0 -or $x -eq $this.nestM.length-1 -or $y -eq $this.nestM[$x].length-1){
                        $this.checkM($x,$y)
                        #CheckN
                    }
                }
            }
        }
        $co = 0
        $ci = 0         
        $cu = 0
        $this.nestM |%{
            write-host $_
            $co+= ($_[0..($_.Length)] -match "[o]").count
            $ci+= ($_[0..($_.Length)] -match "[I]").count
            $cu+= ($_[0..($_.Length)] -match "[U]").count
        }
        write-host "kan det vara $co"
        write-host "kan det vara i $ci med o " ($co+$ci)
        write-host "kan det vara u $cu med o " ($co+$cu)
    }

    checkM($ix, $iy){
        #write-host "kollar " $this.nestM[$ix][$iy]
        $this.nestM[$ix][$iy] = '-'
        for($x = $ix-1;$x -le $ix+1;$x++){
            #$c += $this.nestM[$x][($iy-1)..($iy+1)]
            for($y = $iy-1;$y -le $iy+1;$y++){
                #write-host "kollar pompom"
                if($x -ge 0 -and $y -ge 0 -and $x -lt $this.nestM.length -and $y -lt $this.nestM[$x].length -and $this.nestM[$x][$y] -eq 'o'){
                    #write-host "Här var det o " $this.nestM[$x][$y]
                    $this.checkM($x,$y)                    
                }
            }
        }
    }

    drawitX(){
        $this.nestM |%{
            write-host $_
        }
    }

     [int]checkA () {
        #$move =@($this.psy,$this.psx)
        $move =@()
        $ut = 0
        #Hitta första anslutning
        $cs = $this.CheckFS()
        write-host "startar sedan med " $cs
        #$move += ,@(($this.psy+$cs[0]),($this.psx+$cs[1]))
        $move = @(($this.psy+$cs[0]),($this.psx+$cs[1]))
        $c = 0
        $d =""
        $go= $true
        while($go){
            if($cs[0] -eq -1){$d='U'}elseif($cs[1] -eq 1){$d='R'}elseif($cs[0] -eq 1){$d='D'}elseif($cs[1] -eq -1){$d='L'}
            $cs = $this.CheckNF($move,$d)
            $move[0] += $cs[0]
            $move[1] += $cs[1]
            
            #$move += ,@(($move[$c][0]+$cs[0]),($move[$c][1]+$cs[1]))

            #write-host "just nu " $this.data[$move[$c][0]][$move[$c][1]] " dir " $d
            if($this.data[$move[0]][$move[1]] -eq 'S'){
                write-host "Tillbaka till S " $c
                $ut = ($c+1)/2 
                $go = $false
            }
            $c++
            if($c -gt 1000000){
                write-host "just nu " $move
                write-host "just nu " $this.data[$move[0]][$move[1]] " dir " $d
                if($c -gt 10010){
                    $go = $false
                }
                
            }
        }

        return $ut
     }

    [int[]]CheckFS(){
        switch ($this.data[$this.psy-1][$this.psx]) {
            '|' {  }
            'F' {  }
            '7' {  }
            Default {}
        }
        if($this.data[$this.psy-1][$this.psx] -match "[|F7]"){write-host "Go up " $this.data[$this.psy-1][$this.psx]; return @(-1,0)}
        elseif($this.data[$this.psy][$this.psx +1] -match "[7\-J]"){write-host "Go right"  $this.data[$this.psy][$this.psx +1]; return @(0,1)}
        elseif($this.data[$this.psy+1][$this.psx] -match "[|LJ]"){write-host "Go down" $this.data[$this.psy+1][$this.psx]; return @(1,0)}
        elseif($this.data[$this.psy][$this.psx-1] -match "[\-LF]"){write-host "Go Left" $this.data[$this.psy][$this.psx-1]; return @(0,-1)}
        return @(0,0)
    }

    [int[]]CheckNF([int[]]$pos,$d){
        #R L U D
        $f = $this.data[$pos[0]][$pos[1]]
        #write-host "kollar " $f " på väg $d"
        switch ($f) {
            "F" {if($d -eq 'U'){return @(0,1)}else{return @(1,0)}}
            "-" {if($d -eq 'R'){return @(0,1)}else{return @(0,-1)}}
            "7" {if($d -eq 'R'){return @(1,0)}else{return @(0,-1)}}
            "|" {if($d -eq 'U'){return @(-1,0)}else{return @(1,0)}}
            "J" {if($d -eq 'R'){return @(-1,0)}else{return @(0,-1)}}
            "L" {if($d -eq 'D'){return @(0,1)}else{return @(-1,0)}}
            Default {}
        }
        return @(0,0)
    }

 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 428 -Fel, för lågt
# 587 för högt då är 644 också högt 508 var fel

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0

measure-command {
    $count = [Fence]::new($indata).checkB()
}
$count