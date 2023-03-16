CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
set +e

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [ -f ListExamples.java ];
then
    echo "File Exists"
else
    echo "File Does Not Exist. Check if file has correct name or is under the right directory"
    exit
fi

cd ..

cp TestListExamples.java student-submission

cd student-submission

javac ListExamples.java 2> error1.txt

if [ $(wc -w error1.txt | awk '{print $1}') -eq 0 ]
then
    echo "Compiled Successfully"
else
    cat error1.txt
    echo "Compiler Failure"
    exit
fi

cd ..
cp -r lib student-submission
cd student-submission

javac -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" *.java
java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > results.txt 

cat results.txt

num_tests=$(grep -oE 'Tests run: ([0-9]+)' results.txt | grep -oE '[0-9]+')

num_fails=$(grep -oE 'Failures: ([0-9]+)' results.txt | grep -oE '[0-9]+')

grep -i "FAILURES" results.txt > failCheck.txt

grep " static List<String> filter(List<String> list, StringChecker sc)" ListExamples.java > method.txt

if [ $(wc -w method.txt | awk '{print $1}') -eq 0 ]
then echo "Incorrect filter method signature!"
fi


if [ $(wc -w failCheck.txt | awk '{print $1}') -eq 0 ]
then
    echo "TEST PASSED"
    echo "Score: 100%"
else 
    echo "TEST FAILED"
    echo "Score:" $((100 * ($num_tests-$num_fails) / $num_tests))"%"
    exit
fi
