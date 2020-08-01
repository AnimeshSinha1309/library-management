import matplotlib.pyplot as plt
import datetime
import random
import numpy as np

issue_dates = []
return_dates = []
num_entries = 1000
fine_per_day = 1
borrow_time = 50


def setup():
    for i in range(num_entries):
        issue_dates.append(datetime.date(
            2020, random.randint(5, 6), random.randint(1, 30)))
    for i in range(num_entries):
        return_dates.append(datetime.date.today())


def plot_issue_day_of_week():
    # days_count = [3 for i in range(7)]
    days = ["Monday", "Tuesday", "Wednesday",
            "Thursday", "Friday", "Saturday", "Sunday"]
    days_count = {"Monday": 0, "Tuesday": 0, "Wednesday": 0,
                  "Thursday": 0, "Friday": 0, "Saturday": 0, "Sunday": 0}
    for issue_date in issue_dates:
        print(issue_date.weekday())
        days_count[days[issue_date.weekday()]
                   ] = days_count[days[issue_date.weekday()]] + 1
    print(days_count)
    plt.bar(days_count.keys(), days_count.values(), 0.5, color='g')
    plt.show()


def plot_issue_day_of_month():
    days_count = []
    for issue_date in issue_dates:
        # print(issue_date.weekday())
        days_count.append(issue_date.day)
    # print(days_count)
    arr = np.array(days_count)
    plt.hist(days_count, bins=np.arange(1, 32))
    plt.show()


def plot_return_duration():
    return_duration = [(return_dates[i] - issue_dates[i]).days
                       for i in range(num_entries)]
    arr = np.array(return_duration)
    # print(return_duration)
    plt.hist(return_duration, bins=np.arange(arr.min()-5, arr.max()+5))
    plt.show()


def plot_fines():
    return_duration = [(return_dates[i] - issue_dates[i]).days
                       for i in range(num_entries)]
    fines = []
    for rd in return_duration:
        if rd > borrow_time:
            fines.append(fine_per_day*(rd-borrow_time))
    arr = np.array(fines)
    # print(return_duration)
    plt.hist(fines, bins=np.arange(arr.min()-5, arr.max()+5))
    plt.show()


def plot_fines_pie():
    return_duration = [(return_dates[i] - issue_dates[i]).days
                       for i in range(num_entries)]
    fines = []
    finer_count = 0
    for rd in return_duration:
        if rd > borrow_time:
            finer_count += 1
    print(finer_count)
    plt.pie([finer_count, num_entries-finer_count],
            labels=["Not returned on time", "Returned on Time"])
    plt.show()


if __name__ == "__main__":
    setup()
    # plot_issue_day_of_week()
    # plot_issue_day_of_month()
    # plot_return_duration()
    # plot_fines()
    # plot_fines_pie()
