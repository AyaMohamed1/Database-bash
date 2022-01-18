#!/bin/bash
read dir <<< $(pwd)
cd ~
mkdir -p Databases
cd Databases/
select choice in Create_Database  List_Databases Connect_To_Database Drop_Database
do
case $choice in

Create_Database)
echo "Enter database name to create without spaces"
read createDB
FILE0=$(pwd)/$createDB
if [[ $createDB = *" "* ]]; then
  echo "Invaild name with spaces"
elif test -d "$FILE0"; then
    echo "Invalid, Database already exists."    
else
  mkdir -p $createDB
fi
;;


List_Databases)
ls
;;

Connect_To_Database) 
echo "Enter database name to connect"
read connectDB
cd $connectDB/
select choice in Create_Table  List_Tables Drop_Table Insert_Into_Table Select_From_Table Delete_From_Table Update_Table Main_Menu
do
case $choice in

Create_Table)
echo "Enter table name to create without spaces"
read createTb
FILE=$(pwd)/$createTb
if [[ $createTb = *" "* ]]; then
  echo "Invaild name with spaces"
elif test -f "$FILE"; then
    echo "Invalid, Table already exists."
else     
touch $createTb
echo "Enter table's columns (name type) then separate columns by :, first column is primary key (num only) "
read insertedRow
printf "$insertedRow\n" >> $createTb
fi
;;


List_Tables)
ls
;;

Drop_Table) 
echo "Enter table name to remove"
read removeTb
rm -i $removeTb
;;


Insert_Into_Table)
echo "Enter table name to insert into"
read insertTb
FILE2=$(pwd)/$insertTb
if test -f "$FILE2"; then
echo "Enter table's columns separated by :, first column is primary key"
read inputRow
newPK=$(echo $inputRow | cut -f1 -d:)
read a <<< $(cut -f1 -d:  $insertTb | awk '/'$newPK'/ {print NR; exit}')
if [ -z "$a" ]
then
printf "$inputRow\n" >> $insertTb
else
echo "Invalid input, duplicated primary key"
fi
sort -n $insertTb > temp && mv temp $insertTb
else
echo "Invalid, Table doesn't exist."
fi
;;

Select_From_Table)
echo "Enter table name to select from"
read selectTb
echo "(all) To select all table - (key) To select by primary key"
read opt
if [ $opt == 'all' ]
then
cat $selectTb
elif [ $opt == 'key' ]
then
echo "Enter primary key to select data"
read selectPK
read a <<< $(cut -f1 -d:  $selectTb | awk '/'$selectPK'/ {print NR; exit}')
awk '{if(NR == var) print $0}' var="${a}" $selectTb
else
echo "enter a vaild option"
fi
;;

Delete_From_Table)
echo "Enter table name to delete from"
read selectTb
echo "Enter primary key to select data"
read selectPK
read d <<< $(cut -f1 -d:  $selectTb | awk '/'$selectPK'/ {print NR; exit}')
awk 'NR == var {next} {print}' var="${d}" $selectTb > temp && mv temp $selectTb
;;

Update_Table)
echo "Enter table name to update"
read updateTb
echo "Enter primary key to update data"
read deletePK
read b <<< $(cut -f1 -d:  $updateTb | awk '/'$deletePK'/ {print NR; exit}')
awk 'NR == var {next} {print}' var="${b}" $updateTb > temp && mv temp $updateTb
echo "Enter table's columns (int-sting) separated by :, first column is primary key"
read updateRow
newPKUpdate=$(echo $updateRow | cut -f1 -d:)
read c <<< $(cut -f1 -d:  $updateTb | awk '/'$newPKUpdate'/ {print NR; exit}')
if [ -z "$c" ]
then
printf "$updateRow" >> $updateTb
else
echo "Invalid input, duplicated primary key"
fi
;;

Main_Menu)
bash $dir/database.sh
;;

*) echo "please choose a valid option"
;;
esac
done
;;


Drop_Database)
echo "Enter database name to drop"
read deleteDB
rm -r $deleteDB
;;


*) echo "please choose a valid option"
;;
esac
done
