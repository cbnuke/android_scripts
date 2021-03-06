#! /bin/bash

#cd xste

branch="cm-12.1"
remote="CyanogenMod"
urlstart="https://github.com/CyanogenMod/android_"
urlend=".git"
gitstart="git@github.com:XperiaSTE/android_"
#gitstart="https://github.com/XperiaSTE/android_"
gitend=".git"

path=(
bionic
build
bootable/recovery
external/icu
frameworks/av
frameworks/base
frameworks/native
hardware/libhardware
hardware/libhardware_legacy
packages/apps/Eleven
packages/apps/Settings
packages/services/Telecomm
system/core
vendor/cm
)

#############


# Read array $path lenght
repos=$(echo ${#path[@]} )

read -r -p "Do you wish to add remotes? [y/N] " response
response=${response,,}  
if [[ $response =~ ^(yes|y)$ ]]
then
for ((i = 0; i < $repos; i++)) 
do
echo "Adding remote ${remote} to ${path[i]}"
# Exception
if [[ ${path[i]} == bootable/recovery ]]; then
url="https://github.com/omnirom/android_bootable_recovery.git"
remote="omnirom"
else
# Generate url from $path
url="${urlstart}$(echo ${path[i]} | sed 's.\/._.g')${urlend}"
remote="CyanogenMod"
fi
git -C ${path[i]} remote remove ${remote}
git -C ${path[i]} remote add ${remote} ${url}
done
echo
fi

read -r -p "Do you wish to fetch remotes? [y/N] " response
response=${response,,}
if [[ $response =~ ^(yes|y)$ ]]
then
for ((i = 0; i < $repos; i++)) 
do
echo "Fetching ${path[i]}"
# Exception
if [[ ${path[i]} == bootable/recovery ]]; then
remote="omnirom"
fi
git -C ${path[i]} fetch ${remote} 
remote="CyanogenMod"
done
echo
fi

read -r -p "Do you wish to change branches? [y/N] " response
response=${response,,}  
if [[ $response =~ ^(yes|y)$ ]]
then
for ((i = 0; i < $repos; i++)) 
do
# Exception
if [[ ${path[i]} == bootable/recovery ]]; then
branch="android-6.0"
else
branch="cm-12.1"
fi
echo "Changing ${path[i]} branch  to $branch"
git -C ${path[i]} branch temp
git -C ${path[i]} checkout temp
git -C ${path[i]} branch -D $branch
git -C ${path[i]} branch $branch
git -C ${path[i]} checkout $branch
git -C ${path[i]} branch -D temp
done
echo
fi

read -r -p "Do you wish to merge changes? [y/N] " response
response=${response,,}  
if [[ $response =~ ^(yes|y)$ ]]
then
for ((i = 0; i < $repos; i++)) 
do
echo "Merging changes to ${path[i]}"
# Exception
if [[ ${path[i]} == bootable/recovery ]]; then
remote="omnirom"
branch="android-6.0"
else
remote="CyanogenMod"
branch="cm-12.1"
fi
git -C ${path[i]} merge ${remote}/${branch}
echo
done
fi

read -r -p "Do you wish to push changes? [y/N] " response
response=${response,,}  
if [[ $response =~ ^(yes|y)$ ]]
then

#eval `ssh-agent -s`
#ssh-add

for ((i = 0; i < $repos; i++)) 
do
# Exception
if [[ ${path[i]} == bootable/recovery ]]; then
branch="android-6.0"
else
branch="cm-12.1"
fi
echo "Pushing ${path[i]} changes"
git="${gitstart}$(echo ${path[i]} | sed 's.\/._.g')${gitend}"
git -C ${path[i]} push ${git} ${branch}
done
fi

exit
