#!/bin/sh

##############################################
##Add Group Name Function##

function addgroup_name {
echo "Please, Enter Group Name:"
read name

if [[ ! -e group.txt ]]; then
touch group.txt
fi

 if cut -d: -f1 group.txt|grep -qF "$name" 
  then
  echo $name "Group already exist"
 else
  echo -n $name>>group.txt
  echo "Please, Enter Group ID:"
  addgroup_id
 fi
}
##Add Group ID Function##

function addgroup_id {
read ID
 if cut -d: -f2 group.txt|grep -qF "$ID" 
  then
  sed -i '$d' group.txt
  echo "There is already a group with ID "$ID
 else
    echo ":"$ID>>group.txt
    echo "Group Successfully Added!"
 fi
}

####################################
## Add User Function ##
function adduser
{
echo "Please, Enter User Name: "
  read usrname

if [[ ! -e user.txt ]]; then
touch user.txt
fi

  if grep -qF "$usrname" user.txt
  then
   echo "User $usrname already exist"

  else

  ## echo -n $usrname>>user.txt
   addusrgroup
  fi

}
#####################################
## Add User's Group Function ##
function addusrgroup
{
 if [[ ! -e group.txt ]]; then
     echo "There is no groups to choose from! Please, Add Groups First"
     addgroup_name
 else

  echo "Please, Enter Group Name From the Following list: "
  cat group.txt | awk -F: '{print $1}'
  read usrgroup
  if grep -qF "$usrgroup" group.txt
  then
    echo -n $usrname>>user.txt
    echo -n ":"$usrgroup>>user.txt
    adduserpasswd
  else
sed -i '$d' user.txt
    echo "This group is not existed! choose another group."
    addusrgroup
  fi
 fi
}

################################################
## Add User Password Function ##

function adduserpasswd
{
  echo "Enter user password:"
  read pass
  echo ":"$pass>>user.txt
  echo "User Created Sucessfully!"
}
################################################
## Remove Group ID Function ##
function removegroup_id {
echo "Please, Enter The Group Name you want to remove: "
read idd
if cut -d: -f2 user.txt|grep -qF $idd
  then
  echo "you can't remove this group! you have to remove its users first"
 else
    if grep -qF "$idd" group.txt
    then
    sed -i '/'$idd'/d' group.txt
    echo "group removed successfully"
     else
       echo "there is no group with this name"
   fi
 fi
}
############################################
##Remove User Function##

function removeuser
{
    echo "Please, Enter User's Name: "
    read usrnam
    if grep -qF "$usrnam" user.txt
    then
    sed -i '/'$usrnam'/d' user.txt
    echo "User removed successfully!"
    else
       echo "there is no such a user"
   fi
}
############################################
## Change Password Function ##
function changepasswd
{ 
  echo "Please, Enter your User Name: "
  read usrname
if cut -d: -f1 user.txt|grep -qF $usrname
 then
  echo "Please, Enter your Old Password: "
  read oldpass
 if cut -d: -f3 user.txt|grep -qF $oldpass
 then
  echo "Enter your New Password: "
  read newpass
  sed -i -e "/$usrname/s/$oldpass/$newpass/" user.txt
  echo "Password changed successfully"
 else 
 echo "wrong password"
 fi
 else
  echo "there is no such a user"
fi

  
}

#####################################################
## Test username LogIn Function ##

function username {
echo "Enter User Name: "
read usr
if cut -d: -f1 user.txt|grep -qF $usr
then
 echo "Enter User Password: "
userpasswd

else
  echo "user $usr does not exist!"
fi
}

#####################################
## Test uaserpassword LogIn Function ##

function userpasswd {
read pass
var=$(cut -d: -f1,3 user.txt|grep $usr*|grep $pass)
if [[ -n $var ]]
 then
   echo "user $usr is connected"
 else
   echo "wrong passwd"
 fi

}
###############################################
################ MAIN FUNCTION ################
PS3='Please, Select an option: '
select option in add_group add_user remove_user remove_group test_login change_password EXIT
do

case $option in
"add_user")

        select user in enter_user_name BREAK
        do

        case $user in
        "enter_user_name")
          adduser
        ;;

        "BREAK")
          break
        ;;
        esac
        done;;

"add_group")
    select group in enter_group_name BREAK
        do

        case $group in
        "enter_group_name")
          addgroup_name
        ;;

        "BREAK")
        break
        ;;
        esac
        done
        ;;
"remove_group")
        select remove in enter_group_name BREAK
        do

        case $remove in
       "enter_group_name")
          removegroup_id
        ;;

        "BREAK")
        break
        ;;
        esac
        done
        ;;
"remove_user")
  select remove in enter_user_name BREAK
        do

        case $remove in
        "enter_user_name")
          removeuser
        ;;

        "BREAK")
        break
        ;;
        esac
done
        ;;
"test_login")

        select test in enter_user_name BREAK
        do

        case $test in
        "enter_user_name")
          username
        ;;

        "BREAK")
        break
        ;;

        esac
        done
        ;;

"change_password")
           changepasswd
        ;;

"EXIT")
        exit
        ;;
esac
done

