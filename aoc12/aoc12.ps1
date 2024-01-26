
#Hur kan man jämföra ett värde med omringande värden.
#
# ...
# .8.
# #..
#

class HotS {
    $data
    $con
        
    HotS ($in){
        $this.data = @()
        $this.con =@()
        $i = 0
        foreach ($d in $in){
            $din = $d -split " "
            $this.data += ,$din[0].ToCharArray()
            $this.con += ,$din[1].split(",")

            write-host $din[0]
        $i++
        }

     }
     [int]checkB () {
        $ut = 0

        return $ut
        #3182871 to low
     }

    [int]checkA () {
        $ut = 0
        $g = 0
        foreach($dr in $this.data){
            write-host "Fan nu da " $dr " och " $this.con[$g]
            #$seCo = @{}
            $s = $dr
            $s += '.'
            $a = $this.con[$g]
            $k = $a.length
            $a += $s.length +1
            write-host "Det vi har "$a.length
            write-host "Det vi har start s " $s.length " och a " $a.length
            $seCo = New-Object 'long[][][]' (($s.length+1),($a.length + 1),($s.length + 3))
            #write-host "Det vi har start s " $s.length " och a " $a.length
            $seCo[0][0][0] = 1
            write-host "Det vi " $seCo[0][0].length
            $se =0
            $l = ''
            foreach($i in 0..($s.length-1)){
                #$seCo += ,@()
                write-host "Det loop 1"
                foreach($j in 0..($a.length)){
                    #$seCo[$i] += ,@()
                    write-host "Det loop 2"
                    foreach($p in 0..($s.length+1)){
                        $cur = $seCO[$i][$j][$p]
                        write-host "Det loop 3 har vi " $s[$i]
                        #write-host "nu har vi " $s[$i] "och samlat " $cur
                        if($cur -eq 0){}else{
                            if($s[$i] -eq '.' -or $s[$i] -eq '?'){
                                if($p -eq 0 -or $p -eq $a[$g][$j-1]){
                                    write-host " punkt eller nu har vi " $cur " i " $i " j " $j" p " $p
                                    $seCo[$i+1][$j][0] += $cur
                                }
                            }
                            if($s[$i] -eq '#' -or $s[$i] -eq '?'){
                                write-host "#? nu har vi " $cur " i " $i " j " $j" p " $p
                                #write-host "Det vi har " $seCo[$i+1][$j].length
                                $seCo[$i+1][$j][$p+1] += $cur
                            }
                        }
                    }
                    
                }
            }
            write-host "slut " $seCo.length
            return $seCo[$s.length][$k][0]
            write-host "jahaja " $seCo.length
            $ut += $seCo[$dr.length][$this.con[$g].length][0]
            $g++
            
        }
        return $ut
     }

 }
 
$mypath = Split-Path $MyInvocation.MyCommand.Path -parent
#Testat 65238610 -Fel, för lågt

#$dataFil = "$mypath\indata.txt"
$dataFil = "$mypath\intest.txt"
$indata =  Get-Content $dataFil
$count = 0
 
$count = [HotS]::new($indata).checkA()
 
$count

#print(sum((g:=lambda m,d: not d if not m else (m[0]!='#' and g(m[1:],d))+(d and match(r'[#?]{%d}[.?]'%d[0],m) and g(m[d[0]+1:],d[1:]) or 0))(s[0]+'.',(*map(int,s[1].split(',')),)) for s in map(str.split,open(0))))
