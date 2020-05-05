import numpy as np
from sklearn import metrics
import subprocess
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, auc

# n = pattern length
# r = matched substring length
def run_negative_selection(n, r, foreign_filepath):
    output = subprocess.check_output("java -jar negsel2.jar -self english.train -n "
                + str(n) + " -r " + str(r) + " -c -l < english.test", shell=True)
    output = np.asarray(output.splitlines())
    english_test = [float(data.decode("utf-8")) for data in output]
    # print("english_test = " + str(english_test))

    output = subprocess.check_output("java -jar negsel2.jar -self english.train -n "
                + str(n) + " -r " + str(r) + " -c -l < " + foreign_filepath, shell=True)
    output = np.asarray(output.splitlines())
    foreign_test = [float(data.decode("utf-8")) for data in output]
    # print("other_output = " + str(foreign_test))

    return np.asarray(english_test), np.asarray(foreign_test)

# New auc calculation filled with feedback help from the assignment correction
def new_auc(english_test, foreign_test):
    y_true1 = np.zeros(english_test.size)
    y_true0 = np.ones(foreign_test.size)
    y_true = np.concatenate((y_true1, y_true0)) != 0  # labels  # contains 0 for
    # English lines, 1 for other language lines
    y_pred = np.concatenate((english_test, foreign_test))
    # different English and other Language lines
    fpr, tpr, _ = roc_curve(y_true, y_pred)  # roc function can directly handle
    # the negative selection anomaly scores, no need to binarize the scores or loop through thresholds yourself
    return auc(fpr, tpr)  # contains the AUC for this dataset
    # plt.plot(fpr, tpr)  # optionally plot ROC curve, with matplotlib

def exercise_3():
    filepaths = ["lang/hiligaynon.txt", "lang/middle-english.txt",
                 "lang/plautdietsch.txt", "lang/xhosa.txt"]
    for filepath in filepaths:
        english_test, foreign_test = run_negative_selection(10, 3, filepath)
        print((filepath, str(new_auc(english_test, foreign_test))))

def exercise_1_2():
    #Output for r=4 is the answer to exercise 1
    for r in range(1, 10):
        english_test, tagalog_test = run_negative_selection(10, r, "tagalog.test")
        auc = new_auc(english_test, tagalog_test)
        print((str(r), str(auc)))

def main():
    exercise_1_2()
    exercise_3()

if __name__ == "__main__":
    main()
