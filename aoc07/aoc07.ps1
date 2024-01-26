class Hand {
    [string]$cards
    $rank
    $bid
    $value
    $cvalues

    Hand($in){
        $din = $in -split " "
        $this.cards = [string]$din[0]
        $this.bid = $din[1].trim()
        $this.rank = 1
        $this.value = $this.ValCount($this.cards)
        #$cvalues = @{}
    }

    Compare($h){
        #write-host "Vilken vinner " $this.cards " eller " $h.cards
        if($h.value -lt $this.value){
            #write-host "Lost "
            $this.rank ++
            return
        }elseif($h.value -gt $this.value){
            #write-host "Lost "
            $h.rank ++
            return
        }elseif($h.value -eq $this.value){
            #Compare cards
            $i = 0
            $hc = $h.cards.ToCharArray()
            #write-host "arren blev " $hc
            foreach($c in $this.cards.ToCharArray()){
                #write-host "Vilken vinner " $c " eller " $hc[$i]
                if($this.Rval($c) -lt $this.Rval($hc[$i])){
                    #write-host "det blev: " $c " less then " $this.rval($hc[$i])
                    #write-host "Hur blev: " $hc[$i] " sudden " $this.rval($hc[$i])
                    $h.rank ++
                    return
                }elseif($this.Rval($c) -gt $this.Rval($hc[$i])){
                    #write-host "det blev: " $c " greater then " $this.rval($hc[$i])
                    $this.rank ++
                    return
                }
                $i++   
            }
        }
    }

    cc($a,$b){
        
    }

    [int]Rval($a){
        if($a -match "\d+"){
            return $a -48
        }
        switch ($a) {
            'T' { return 10 }
            'J' { return 1 }
            'Q' { return 12 }
            'K' { return 13 }
            'A' { return 14 }
            Default {return [int]$a}
        }
        return [int]$a
    }

    [int]RvalA($a){
        if($a -match "\d+"){
            return $a -48
        }
        switch ($a) {
            'T' { return 10 }
            'J' { return 11 }
            'Q' { return 12 }
            'K' { return 13 }
            'A' { return 14 }
            Default {return [int]$a}
        }
        return [int]$a
    }

    [int]ValCount($in){
        $inc = $in.ToCharArray()
        $res = @{}
        $js = ($inc | where-object {$_ -eq 'J'} |measure-object).count

        foreach($d in $inc){
            if($d -ne 'J'){
                #write-host "tecken " $d
                $m = ($inc | where-object {$_ -eq $d} |measure-object).count
                if($m -gt 1){
                    if($res.ContainsKey($d)){
                        $res[$d] ++
                    }else{
                        $res.add($d,1)
                    }
                }
            }  
        }
        #write-host "samlat " $res.count
        if($res.count -eq 1){
            foreach($k in $res.Keys){
                $res[$k] += $js
                #write-host "samlat lika " $res[$k]
                if($res[$k] -eq 2){return 2}
                elseif($res[$k] -eq 3){return 4}
                elseif($res[$k] -eq 4){return 6}
                elseif($res[$k] -eq 5){return 7}
            }
        }elseif($res.count -eq 2){
            $tot = 0
            foreach($k in $res.Keys){
                $tot += $res[$k]
                #write-host "samlat 2 lika " $res[$k]
            }
            $tot += $js
            if($tot -eq 4){return 3}
            elseif($tot -eq 5){return 5}
        }elseif($js -gt 0){
            if($js -eq 1){return 2}
            elseif($js -eq 2){return 4}
            elseif($js -eq 3){return 6}
            elseif($js -gt 3){return 7}
            return 1
        }
        return 1
    }
    [int64]score(){
        return $this.rank * $this.bid
    }
}
class CCard {
    $cards
    
    CCard ($in){
        $this.cards = @()

        foreach ($d in $in){
            $this.cards += [Hand]::new($d)
        }

    }
    [int]checkB () {
        $c = 0
        return $c
    }

    [int]checkA () {
        $c = 0
        $x = 1
        foreach($h in $this.cards){
            #if($x -le $this.cards.length +1){
                for($i = $x; $i -lt $this.cards.length;$i++ ){
                        $h.Compare($this.cards[$i])
                }
            #}
            $x++
        }
        foreach($h in $this.cards){
            if($h.rank -lt 10){
                #write-host "Rank 1 " $h.cards " bid " $h.bid "val " $h.value
                write-host "Rank "$h.rank " cards "  $h.cards " bid " $h.bid "val " $h.value
            }

            #write-host "Rank  " $h.rank
            #write-host "Rank "$h.rank " cards "  $h.cards " bid " $h.bid "val " $h.value
            $c+=$h.score()
        }
        return $c
    }

 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 249773466 -Fel, för högt
#Testat 249820546 -fel för högt
#248812215 Rätt
#B 250205352 high
#B 249894952 Low
#B 250637255 High
#B 250457986 Fel
#B 250958486 Fel
#B 251458986
$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0

#(Measure-Command {
    $count = [CCard]::new($indata).checkA()
    
#}).Seconds
$count