#!/bin/bash

if [ $# -lt 4 ]; then
  echo "Usage: ./tdrlatexdiff.sh [cadi] [baseDir] [revision] [outputDir]"
  echo "Example: ./tdrlatexdiff.sh HIN-18-006 /myPath/HIN-18-006 456777 ./myDiffDir"
  exit 1
fi

cadi=$1
baseDir=$2
revision=$3
outputDir=$(readlink -f ${4})

echo "cadi = $cadi"
echo "baseDir = $baseDir"
echo "revision = $revision"
echo "outputDir = $outputDir"

set -x

baseDirRel="."
paperDir=$baseDirRel"/papers/"$cadi
trunkDir=$paperDir"/trunk"
texFile=$trunkDir"/"$cadi".tex"
texFileBACKUP=$outputDir"/"$cadi."tex"
bibtexFile=$trunkDir"/"$cadi".bib"

skeletonFile=$baseDirRel"/utils/trunk/general/skeleton_start.tex"
skeletonFileBACKUP=$outputDir"/skeleton_start_ORIGINAL.tex"
diffFileTex=$trunkDir"/"$cadi"-diffr"${revision}".tex"

outputPdf=$baseDirRel"/papers/tmp/"$cadi"_temp.pdf"
diffFilePdf=$outputDir"/"$cadi"-diffr"${revision}".pdf"

originalDir=$PWD
cd $baseDir
eval `./papers/tdr runtime -sh` # for tcsh. use -sh for bash.
latexdiff-vc --svn -r r${revision} $texFile

mkdir -p $outputDir
# back up original tex file
cp $texFile $texFileBACKUP
# need to compile latexdiff file instead of the original tex file
cp $diffFileTex $texFile
# back up latexdiff file
mv $diffFileTex $outputDir
# back up original skeleton file
cp $skeletonFile $skeletonFileBACKUP
# replace original skeleton file
cp $originalDir/skeleton_start_latexdiff.tex $skeletonFile

tdr --style=paper b $cadi
cp $outputPdf $diffFilePdf

# revert back to original .tex file
cp $texFileBACKUP $texFile
# revert back to original skeleton file
cp $skeletonFileBACKUP $skeletonFile

cd $originalDir

