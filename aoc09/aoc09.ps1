
class Stepsie {
    $data
    
    Stepsie ($in){
        [int64[]]$this.data = @()
        
        $i = 0
        foreach ($d in $in){
            #write-host "IN " $d
            $this.data += ,$d.split(" ")
        $i++
        }

     }
     [int64]checkB () {
        $ut = 0
        #$ut = $this.data.length
        foreach ($ind in $this.data) {
            $l = $null
            $tes = @()
            $i = 0
            $lc = 0
            $tes += ,$ind
            #write-host "Test 111 " $tes[0]
            $go = $true
            while($go){
                $l = $null
                $tc = 0
                #write-host "Test " $tes[$i]
                $ny  = @()
                $tes[$i] | %{
                    $tc += $_
                    if($l -eq $null){
                        $l = $_
                        #$ny += ,@()
                    }else{
                        $ny += ($_ - $l)
                        $l = $_
                    }
                }
                $lc +=$l
                #write-host "Alla "  $tes[$i]
                if($tc -eq 0){
                    #write-host "Alla are noll! " $lc
                    #write-host "Alla "  $tes[$i+1]
                    $uc = 0
                    #$s = $null
                    $s = $tes[$tes.length -2][0]
                    #write-host "Stepper  " $s
                    for($x = $tes.length-3; $x -ge 0; $x--){
                        #if($s -eq $null){$s = $tes[$x][0] - $tes[$x+1][0]}
                        $uc = $tes[$x][0]-$s
                        $s = $uc
                        #$uc = $tes[$x][0] - $tes[$x+1][0]
                        #write-host "kolla "$uc " - " $tes[$x]
                    }
                    $ut += $uc
                    #write-host "kolla ut nu " $ut
                    #$ut += $lc
                    $go = $false
                }else{$tes += ,$ny}
                                
                $i++
            }
        }
        return $ut
     }

     [int]checkA () {
        $ut = 0
        #$ut = $this.data.length
        foreach ($ind in $this.data) {
            $l = $null
            $tes = @()
            $i = 0
            $lc = 0
            $tes += ,$ind
            #write-host "Test 111 " $tes[0]
            $go = $true
            while($go){
                $l = $null
                $tc = 0
                #write-host "Test " $tes[$i]
                $tes[$i] | %{
                    $tc += $_
                    if($l -eq $null){
                        $l = $_
                        $tes += ,@()
                    }else{
                        $tes[$i+1] += ($_ - $l)
                        $l = $_
                    }
                }
                $lc +=$l
                #write-host "Alla "  $tes[$i]
                if($tc -eq 0){
                    #write-host "Alla are noll! " $lc
                    #write-host "Alla "  $tes[$i+1]
                    $ut += $lc
                    $go = $false
                }                    
                $i++
            }
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
 
$count = [Stepsie]::new($indata).checkB()
 
$count