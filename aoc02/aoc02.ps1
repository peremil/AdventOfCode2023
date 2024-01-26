$mypath = Split-Path $MyInvocation.MyCommand.Path -parent

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"

$data =  Get-Content $dataFil

function aoc2a {
    $ut = 0
    $data | % {
        $fat=$false
        $wdx = $_.Split(':')
        $gno = [int]$wdx[0].split(' ')[1]
        $wdx[1].Split(';') |%{
            #Write-Host "data nu: $_ "
            $_.Split(',') |% {
                $d = $_.trimstart(" ").split(' ')
                #Write-Host "detalj nu: $($d[1]) är $($d[0])"
                #Write-Host "detalj nu x: $($_)"
                switch ($d[1]) {
                    'red' {if([int]$d[0] -gt 12){$fat = $true} }
                    'green' {if([int]$d[0] -gt 13){$fat = $true}  }
                    'blue' {if([int]$d[0] -gt 14){$fat = $true}  }
                    Default {}
                }

            }
            #if($fat){break}
        }
        if(!$fat){$ut += $gno}
    }
    return $ut
}

function aoc2b {
    $ut = 0
    $data | % {
        $fat=$false
        $wdx = $_.Split(':')
        [int]$hr = 0
        [int]$hg = 0
        [int]$hb = 0

        $gno = [int]$wdx[0].split(' ')[1]
        $wdx[1].Split(';') |%{
            #Write-Host "data nu: $_ "
            $_.Split(',') |% {
                $d = $_.trimstart(" ").split(' ')
                #Write-Host "detalj nu: $($d[1]) är $($d[0])"
                #Write-Host "detalj nu x: $($_)"
                switch ($d[1]) {
                    'red' {if([int]$d[0] -gt $hr){$hr = $d[0]} }
                    'green' {if([int]$d[0] -gt $hg){$hg = $d[0]}  }
                    'blue' {if([int]$d[0] -gt $hb){$hb = $d[0]}  }
                    Default {}
                }

            }
            #if($fat){break}
        }
        #Write-Host "detalj nu: red $hr green $hg blue $hb"
        $c = $hr*$hg*$hb
        #Write-Host "Totalt för raden: $c"
        $ut += $c
        #if(!$fat){$ut += $gno}       

    }
    return $ut
}


aoc2b