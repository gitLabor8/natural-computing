
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
    print("english_test = " + str(english_test))

    output = subprocess.check_output("java -jar negsel2.jar -self english.train -n "
                + str(n) + " -r " + str(r) + " -c -l < " + foreign_filepath, shell=True)
    output = np.asarray(output.splitlines())
    foreign_test = [float(data.decode("utf-8")) for data in output]
    print("other_output = " + str(foreign_test))

    return np.asarray(english_test), np.asarray(foreign_test)

# Old auc calculation, just here for reference
def calc_auc(english_test, foreign_test, threshold):
    y_true1 = np.ones(english_test.size)
    y_true0 = np.zeros(foreign_test.size)
    y_true = np.concatenate((y_true1, y_true0)) != 0

    y_pred = np.concatenate((english_test, foreign_test))
    y_pred = np.where(y_pred, 0, 1)

    fpr, tpr, thresholds = metrics.roc_curve(y_true, y_pred)
    return metrics.auc(fpr, tpr)

# New auc calculation filled with feedback help from the assignment correction
def new_auc(english_test, foreign_test):
    y_true1 = np.ones(english_test.size)
    y_true0 = np.zeros(foreign_test.size)
    y_true = np.concatenate((y_true1, y_true0)) != 0  # labels  # contains 0 for
    # English lines, 1 for other language lines
    y_pred = np.concatenate((english_test, foreign_test))
    # y_pred = np.where(y_pred, 0, 1) # scores  # list containing scores for the
    # different English and other Language lines
    fpr, tpr, _ = roc_curve(y_true, y_pred)  # roc function can directly handle
    # the negative selection anomaly scores, no need to binarize the scores or loop through thresholds yourself
    return auc(fpr, tpr)  # contains the AUC for this dataset
    # plt.plot(fpr, tpr)  # optionally plot ROC curve, with matplotlib

def main():
    filepaths = ["lang/hiligaynon.txt", "lang/middle-english.txt",
                 "lang/plautdietsch.txt", "lang/xhosa.txt"]
    for filepath in filepaths:
        english_test, foreign_test = run_negative_selection(10, 4, filepath)
        threshold = np.mean([*english_test, *foreign_test])
        print((filepath, str(new_auc(english_test, foreign_test))))

    # Results for other languages, with r=4
    # ('lang/hiligaynon.txt', '0.7624516129032258')
    # ('lang/middle-english.txt', '0.5265483870967742')
    # ('lang/plautdietsch.txt', '0.7294516129032257')
    # ('lang/hiligaynon.txt', '0.7624516129032258')


def find_r():
    for r in range(4, 5):
        english_test, tagalog_test = run_negative_selection(10, r, "tagalog.test")
        threshold = np.mean([*english_test, *tagalog_test])
        print("new auch?")
        auc = new_auc(english_test, tagalog_test)
        print((str(r), str(auc)))

    # Results:
    # ('1', '0.5444004009476945')
    # ('2', '0.5931292145070166')
    # ('3', '0.7403180244213596')
    # ('4', '0.7548979405868416')
    # ('5', '0.6883998542008383')
    # ('6', '0.6093721523601239')
    # ('7', '0.5483870967741935')
    # ('8', '0.5120967741935484')
    # ('9', '0.5120967741935484')


# find_r()
# main()

# Manual testing: this should yield "about 0.79"
output = subprocess.check_output("java -jar negsel2.jar -self english.train -n "
            + str(10) + " -r " + str(4) + " -c -l < english.test", shell=True)
output = np.asarray(output.splitlines())
english_test = [float(data.decode("utf-8")) for data in output]
print("english_test = " + str(english_test))

