
class CosmC {
    $data
    $gal
    $fact

    CosmC ($in){
        $this.data = @()
        $this.gal = @()
        $this.fact = 1000000
        $this.fact -=1
        $i = 0
        foreach ($d in $in){
            $this.data += ,$d.ToCharArray()
            if($this.data[($this.data.length-1)] -Contains '#'){
                #write-host "Hittat galax"
                $c = 0
                $this.data[$i] |%{
                    if($_ -eq '#'){
                            $this.gal+=,@($i,$c)
                            #write-host "Lastar in " $i ", "$c
                    }
                    $c++
                }
            }else{
                #write-host "Add blindrow"
                #$this.data += ,$d.ToCharArray()
                #$i++
            }
            $i++
        }
        #Add col
        $xi = 0
        for($i = 0;$i -lt $this.data.length;$i++){
            if(!($this.data[$i] -Contains '#')){
                #write-host "Add blindrow nw"
                $this.gal |%{
                    if($_[0] -gt ($i+$xi)){
                        $_[0] = $_[0] + $this.fact
                    }
                }
                $xi +=$this.fact
            }
        }
        #Add with
        $ci = 0
        for($i = 0;$i -lt $this.data[0].length;$i++){
            $cx = @()
            for($x = 0;$x -lt $this.data.length;$x++){
                $cx += $this.data[$x][$i]
            }
            #write-host " Check " $cx
            #write-host " Check " ($cx -contains '#')
            if(!($cx -Contains '#')){
                #write-host "Addar blind col" $i
                $this.gal |%{
                    if($_[1] -ge ($i+$ci)){
                        $_[1] =$_[1] + $this.fact
                    }
                }
                $ci+= $this.fact
            }
            
        }
        #check for galaxys
        <#
                        $c = 0
                $this.data[$i] |%{
                    if($_ -eq '#'){
                            $this.gal+=,@($i,$c)
                            #write-host "Lastar in " $i ", "$c
                        }
                    $c++
                }
        #>
     }

     [int]checkB () {
        $ut = 0
     
        return $ut
        #3182871 to low
     }

     [int64]checkA () {
        write-host "check nest ner "
        $ut = 0
        $c = 0
        $gc = 0
        $this.gal |%{
            for($i = $c+1;$i -lt $this.gal.length;$i++){
                #write-host "Testar " $this.gal[$i]
                $n = $this.gal[$i][0] - $_[0]
                $u = $this.gal[$i][1] - $_[1]
                if($n -lt 0){$n = -$n }
                if($u -lt 0){$u = -$u}
                #$u++
                $d = $n+$u
                #write-host "till nest $c till $i ner  " $n  " sida " $u "Totalt " $d
                $ut += $d
                $gc ++
            }
            $c++
        }
        write-host "galaxer " $gc
        return $ut
     }

 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 65238610 -Fel, för lågt

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
 $count = 0
 
$count = [CosmC]::new($indata).checkA()
 
$count