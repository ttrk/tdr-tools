#!/bin/bash

set -x

revision=460156
cadi="HIN-18-006"
baseDir="/path/to/HIN-18-006"
outputDir=$baseDir"/"$cadi"-diff"$revision
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

