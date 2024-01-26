$mypath = Split-Path $MyInvocation.MyCommand.Path -parent

$dataFil = "$mypath\indata.txt"
#$dataFil = "$mypath\intest.txt"

$data =  Get-Content $dataFil

function aoc1a {
    $ut = 0
    $data | % {
        #$_
        #Regex.Replace($_, @"[^\d]", "")
        $res = $_ -replace '[^\d]+', ''
        $d =  $res[0] + $res[$res.length-1]
        #$d
        $ut += [int32]$d
    }
    return $ut
}


function aoc1b {
    $ut = 0
    $data | % {
        $d = 0
        #$_
        $in = $_
        $no = @{
            'one' = '1'
            'two' = '2'
            'three' = '3'
            'four' = '4'
            'five' = '5'
            'six' = '6'
            'seven' = '7'
            'eight' = '8'
            'nine' = '9'
        }
        $li = 0
        $lno = ''
        $hi = 0
        $hno = ''

        Foreach ($n in $no.Keys) {
            #$_
            #$n
            #$no.$n
            
            #$in = $in.Replace($n, $no.$n)
            
            if($in -match $n){
                #$n
                #Write-host "match $n i position $($in.indexOf($n))"
                if($in.indexOf($n) -lt $li -or $lno -eq ''){
                    $li = $in.indexOf($n)
                    $lno = $no.$n
                }
                if($in.lastindexOf($n) -gt $hi -or $hno -eq ''){
                    $hi = $in.lastindexOf($n)
                    $hno = $no.$n
                }
               #$in = $in.insert($in.indexOf($n, $no.$n))
            }
        }
        #$li
        #$lno
        #$hi
        #$hno
        #Write-host "högsta är: $hno position $hi"
        if($hno -ne '') {$in = $in.insert($hi, $hno)}
        if($lno -ne '') {$in = $in.insert($li, $lno)}
        
        #$in = $in.insert($in.indexOf($n), $no.$n)
        #$in
        #$in
        $in = $in -replace '[^\d]+', ''
        $d =  $in[0] + $in[$in.length-1]
        #$_
        #$in
        #$d
        #$d
        $ut += [int32]$d
        #$in
    #$in -replace($no.Keys, $no.v)
    }
    return $ut
}

aoc1b