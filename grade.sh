CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm error1

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

echo 'javac ListExamples.java' > error1.txt

if [ $(wc -w error1.txt | awk '{print $1}') -eq 0 ]
then
    echo "Compiled Successfully"
else
    echo "Compiler Failure"
    exit
fi


cd ..
cp -r lib student-submission
cd student-submission



javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java
java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > results.txt

#######

grep -i "FAILURES" results.txt > failCheck.txt

if [ $(wc -w failCheck.txt | awk '{print $1}') -eq 0 ]
then
    echo "PASSED"
else 
    echo "FAILED"
    exit
fi