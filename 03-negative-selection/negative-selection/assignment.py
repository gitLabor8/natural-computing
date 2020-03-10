
import numpy as np
from sklearn import metrics
import subprocess
import matplotlib.pyplot as plt

# n = pattern length
# r = matched substring length
def run_negative_selection(n, r):
    output = subprocess.check_output("java -jar negsel2.jar -self english.train -n " + str(n) + " -r " + str(r) + " -c -l < english.test", shell=True)
    output = np.asarray(output.splitlines())
    english_test = [float(data.decode("utf-8")) for data in output]

    output = subprocess.check_output("java -jar negsel2.jar -self english.train -n " + str(n) + " -r " + str(r) + " -c -l < tagalog.test", shell=True)
    output = np.asarray(output.splitlines())
    tagalog_test = [float(data.decode("utf-8")) for data in output]

    return np.asarray(english_test), np.asarray(tagalog_test)


def calc_auc(english_test, tagalog_test, threshold):

    y_true1 = np.ones(english_test.size)
    y_true0 = np.zeros(tagalog_test.size)
    y_true = np.concatenate((y_true1, y_true0)) != 0


    y_pred = np.concatenate((english_test, tagalog_test))
    y_pred = np.where(y_pred>threshold, 0, 1)
    # print(y_pred)

    fpr, tpr, thresholds = metrics.roc_curve(y_true, y_pred)
    # plt.plot(fpr, tpr)
    # plt.title("ROC Curve")
    # plt.xlabel("False Positive Rate")
    # plt.ylabel("True Positive Rate")
    # plt.show()
    return metrics.auc(fpr, tpr)



def main():
    enlgish_test, tagalog_test = run_negative_selection(10, 4)
    threshold = np.mean([*enlgish_test, *tagalog_test])
    # print(np.mean(enlgish_test))
    # print(np.mean(tagalog_test))
    # print("threshold ="+str(threshold))
    auc = calc_auc(enlgish_test,tagalog_test,threshold)
    for r in range(1,8):
        enlgish_test, tagalog_test = run_negative_selection(10, r)
        threshold = np.mean([*enlgish_test, *tagalog_test])
        auc = calc_auc(enlgish_test,tagalog_test,threshold)
        print((str(r), str(auc)))

# Results:
# ('1', '0.5444004009476945')
# ('2', '0.5931292145070166')
# ('3', '0.7403180244213596')
# ('4', '0.7548979405868416')
# ('5', '0.6883998542008383')
# ('6', '0.6093721523601239')
# ('7', '0.5483870967741935')





main()
