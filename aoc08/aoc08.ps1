
class Map{
    $Name
    $L
    $R

    map($in){
        $din = (($in -replace "[=(),]") -replace "  ", " ").split(" ")
        $this.Name = $din[0]
        $this.L = $din[1]
        $this.R = $din[2]
    }

}
class CamelMap {
    $Seq
    $map
    $maph
    CamelMap ($in){
        $this.seq = @()
        $this.map = @()
        $this.maph =@{}

        $i = 0
        foreach ($d in $in){
            if($i -eq 0){
                #load seq
                $this.seq = $d.ToCharArray()
            }
            if($i -gt 1){
                $this.map += [map]::new($d)
                $din = (($d -replace "[=(),]") -replace "  ", " ").split(" ")
                #write-host "Laddar " $din[0]
                $fu = ("LR").ToCharArray()
                
                $this.maph[$din[0]] = @{$fu[0] = $din[1];$fu[1] =$din[2]}
                #$this.maph.add($din[0],@{'L' = $din[1];'R' =$din[2]})
            }
            
        $i++
        }
        #write-host "Laddat " $this.maph
     }

     [int64]checkB () {
        $ut = 1
        $sp = ($this.map |where Name -match "..A").Name
        #write-host "start 11:an! " $sp
        $go = $true
        $n = @()
        $i = 0
    
        for($i = 0; $i -lt $sp.length;$i++){
            $go = $true
            $c = 1
            while($go){
                foreach($s in $this.seq){
                    $sp[$i] = $this.maph[$sp[$i]].$s
                    if($sp[$i] -match "..Z"){
                        write-host "Hittat Z " $sp[$i] "pos " $c
                        $n += $c 
                        $go = $false
                        #if($c -eq 20){$go = $false}
                    }
                    $c++
                }
                $ut++
                #if($ut -eq 50){return $ut}
            }
            
            #$go = $false
        }
        #Vad gör vi nu med $n?
        [int64]$l = 0        
        $go = $true
        #$c = 0
            
        foreach($i in $n){
            if($l -eq 0){$l = $i}else{
                $cl = $l
                while($cl % $i -ne 0){
                    $cl+=$l
                }
                #write-host "Nu är vi på " 
                $l = $cl
                write-host "Nu är vi på " $l
            }
        }
        return $l
     }

     [int]checkA () {
        $ut = 1
        $i = 0
        $n = 'AAA'
        $go = $true
        while($go){
            foreach($s in $this.seq){
                #if($i -eq 0){$n = ($this.map |where Name -eq 'AAA').$s}
                #else{
                $n = ($this.map |where Name -eq $n).$s
                #}
                if($n -eq 'ZZZ'){
                    #Done"
                    return $ut
                }
                $ut++
            }
            $i++
            
        }
        return $ut
     }

 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 65238610 -Fel, för lågt

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0

(measure-command {
    $count = [CamelMap]::new($indata).checkB()
}).seconds 

 
$count