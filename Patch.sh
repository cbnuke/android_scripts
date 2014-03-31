#Set patches directory
rootDir=$PWD
patchDir="device/sony/montblanc-common/hardware/patches"

# Cherry picks
echo "Cherry picking..."

while read line                   
do          
   dir=$(echo $line | cut -f1 -d"|");
   gitCmd=$(echo $line | cut -f2 -d"|");
   
   
   cd $dir;
   git pull aosp &> /dev/null;
   git cherry-pick $gitCmd;
   exitValue=$?;
   cd $rootDir;
   
    if (( $exitValue > 0 )); then
      echo "Error with cherry-pick: \"$gitCmd\" in $dir/";
      exit 1;
    fi
   
done < $patchDir/cherry-picks.list


#Patch
echo "Patching..."
for dir in $(ls -d $patchDir/*/ | grep -v FM );
do
  for f in $(ls $dir | grep .patch);
  do
    git apply -p1 --verbose --ignore-space-change --ignore-whitespace < $dir$f
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
	  echo "Error $RETVAL with patch $dir$f"
	  exit $RETVAL
    fi
  done
done