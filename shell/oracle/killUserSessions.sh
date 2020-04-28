#!/bin/sh
# kill oracle user sessions
function _oracleplus(){
sqlplus /nolog << END
connect / as sysdba;
$1
exit;
END
}
echo "start select $1 session."
typeset -u toUser
toUser=$1
selectUS="select 'alter system kill session '''||sid||','||serial#||''' ;' from v\$session where username='$toUser';"
echo $selectUS
_oracleplus "$selectUS" |grep 'alter system' > onlinesession.sql
echo "start kill $1 session."
cat onlinesession.sql | while read line
do
echo $line
_oracleplus "$line"
done
echo "end kill $1 session."
