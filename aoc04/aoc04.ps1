
#Hur kan man jämföra ett värde med omringande värden.
#
# ...
# .8.
# #..
#

class CardCount {
    $win
    $card
    [int]$x
    [int]$y
    $count
    $cwinCount
    
    CardCount ($in){
        $this.win = @()
        $this.card = @()
        $lwin = @()
        $lcard = @()
        $this.cwinCount = @()

        $i = 0
        foreach ($d in $in){
            $din = ($d -split ":")[1].split("|")
            #write-host "intrarad  " $din[1]
            $lwin = $din[0].trim()
            $lcard = $din[1].trim()
            #write-host "intrarad  " $lcard
            $lwin = $lwin -replace "  ", " "
            $lcard = $lcard -replace "  "," "
            #write-host "snofsrad  " $lcard
            $this.win += ,$lwin.split(" ")
            $this.card += ,$lcard.split(" ")
            $this.cwinCount += 1
            #$this.data[$i] = @($d.ToCharArray())
        $i++
        }

     }
     [int]checkB () {
        $ut = 0
        #$this.win
        #write-host "card " $this.card[0]
        $rno = 0
        $twin = 0
        $m = 0
        foreach($r in $this.card){
            $m = $this.cwinCount[$rno]
            $rwin = 0
            foreach($n in $r){
                #write-host "cards " $n
                if($this.win[$rno].contains($n)){
                    #write-host " a Win! " $n
                    $rwin ++
                }
            }
            if($rwin -gt 0){
                for($i = $rno+1;$i -lt $rno+$rwin+1;$i++){
                    $this.cwinCount[$i] += $m
                }
            }
            $rno ++
        }
        #write-host "Wins " $this.win[0].length
        #write-host "Card " $this.card[0].length
        $ut = ($this.cwinCount |measure-object -sum).sum
        return $ut
        #3182871 to low
     }

     [int]checkA () {
        $ut = 0
        #$this.win
        #write-host "card " $this.card[0]
        $rno = 0
        $twin = 0
        foreach($r in $this.card){
            $rwin = 1
            foreach($n in $r){
                #write-host "cards " $n
                if($this.win[$rno].contains($n)){
                    #write-host " a Win! " $n
                    $rwin = $rwin *2
                }
            }
            if($rwin -gt 1){$twin += $rwin/2}
            $rno ++
        }
        #write-host "Wins " $this.win[0].length
        #write-host "Card " $this.card[0].length
        return $twin
     }

 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 65238610 -Fel, för lågt

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0
 
$count = [CardCount]::new($indata).checkB()
 
$count