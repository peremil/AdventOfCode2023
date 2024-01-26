
#Hur kan man jämföra ett värde med omringande värden.
#
# ...
# .8.
# #..
#

class HotS {
    $data
        
    HotS ($in){
        $this.data = @()
    
        $i = 0
        foreach ($d in $in){
            $din = $d -split " "
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