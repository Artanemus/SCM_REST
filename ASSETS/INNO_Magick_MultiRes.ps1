Set-Location C:\Users\Ben\Documents\GitHub\SCM_REST\ASSETS\
<#
Creation of REST PNG - orginates from GitHub\SCM_ASSETS\
Square aspect ratio used for icons.
Output used by INNO and RAD studio.
Windows universal platform package logo settings (PNG) 
#>
$inpath = 'C:\Users\Ben\Documents\GitHub\SCM_REST\ASSETS\'
$infile = $inpath + 'SCM_REST-800x800.png'

$outpath = 'C:\Users\Ben\Documents\GitHub\SCM_REST\ASSETS\'
$outfileICO = $outpath + 'SCM_REST.ico'
$outfileREST250 = $outpath + 'SCM_REST_250x250.png'
$outfileREST150 = $outpath + 'SCM_REST_150x150.png'
$outfileREST44 = $outpath + 'SCM_REST_44x44.png'

# HERO ICON

if (Test-Path -Path $outfileICO -PathType Leaf) {
    Remove-Item $outfileICO
}

magick convert $infile -flatten -resize 256x256 -alpha off -background white -define icon:auto-resize="256,128,96,64,48,32,16" $outfileICO

# GitHub ../Artanemus/SCM_REST/ repository readme.md 

if (Test-Path -Path $outfileREST250 -PathType Leaf) {
    Remove-Item $outfileREST250
}

magick convert $infile -flatten -resize 250x250 $outfileREST250

# GitHub WebPages download page icon 

if (Test-Path -Path $outfileREST150 -PathType Leaf) {
    Remove-Item $outfileREST150
}

magick convert $infile -flatten -resize 150x150 $outfileREST150

# FMX Android Mobile app icon 

if (Test-Path -Path $outfileREST44 -PathType Leaf) {
    Remove-Item $outfileREST44
}

magick convert $infile -flatten -resize 44x44 $outfileREST44

