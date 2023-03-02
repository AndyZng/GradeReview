CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'


rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [ -f ListExamples.java ];
then
    echo "File Exists"
else
    echo "File Does Not Exist"
    exit
fi

cd ..

cp TestListExamples.java student-submission

set +e

cd student-submission

javac ListExamples.java 2> error1.txt
echo what is in error1?:

echo END OF error1
if [ $(wc -w error1.txt | awk '{print $1}') -eq 0 ]
then
    echo "Compiled Successfully"
else
    echo "Compiler Failure"
    exit
fi
rm error1.txt

cd ..
cp -r lib student-submission
cd student-submission



#javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java
javac -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" *.java
#java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > results.txt
 java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > results.txt 
#######

grep -i "FAILURES" results.txt > failCheck.txt

if [ $(wc -w failCheck.txt | awk '{print $1}') -eq 0 ]
then
    echo "PASSED"
else 
    echo "FAILED"
    exit
fi