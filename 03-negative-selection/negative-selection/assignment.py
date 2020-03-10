
import numpy as np
from sklearn import metrics
import subprocess


def run_negative_selection(n, r):
    output = subprocess.check_output("java -jar negsel2.jar -self english.train -n " + str(n) + " -r " + str(r) + " -c -l < english.test", shell=True)
    output = np.asarray(output.splitlines())
    english_test = [float(data.decode("utf-8")) for data in output]

    output = subprocess.check_output("java -jar negsel2.jar -self english.train -n " + str(n) + " -r " + str(r) + " -c -l < tagalog.test", shell=True)
    output = np.asarray(output.splitlines())
    tagalog_test = [float(data.decode("utf-8")) for data in output]
    
    return english_test, tagalog_test

def main():
    enlgish_test, tagalog_test = run_negative_selection(10, 4)
    print(enlgish_test)
    print(tagalog_test)
main()
