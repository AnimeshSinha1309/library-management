import matplotlib.pyplot as plt
import datetime
import random
import numpy as np

category_counts = {"maths": 12, "science": 3, "fiction": 5}

issue_dates = []
return_dates = []
num_entries = 1000
fine_per_day = 1
borrow_time = 7


def random_date(start, end):
    """Generate a random datetime between `start` and `end`"""
    # print(int((end-start).total_seconds))
    return start + datetime.timedelta(
        # Get a random amount of seconds between `start` and `end`
        random.randint(0, int((end - start).total_seconds()//(60*60*24))),
    )


def setup():
    for i in range(num_entries):
        issue_dates.append(random_date(
            datetime.date(year=2019, month=1, day=1), datetime.date.today()))
    for i in range(num_entries):
        return_dates.append(
            issue_dates[i]+datetime.timedelta(days=int(max(random.gauss(7, 4), 0))))
    print(issue_dates)


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
    colors = []
    for i in range(7):
        if days_count[days[i]] > 150:
            colors.append('r')
        else:
            colors.append('g')

    print(days_count)
    brlist = plt.bar(days_count.keys(), days_count.values(), 0.5, color='g')
    for i in range(7):
        brlist[i].set_color(colors[i])
    plt.show()


def plot_issue_day_of_month():
    days_count = []
    for issue_date in issue_dates:
        days_count.append(issue_date.day)
    # print(days_count)
    arr = np.array(days_count)
    plt.hist(days_count, bins=np.arange(1, 32), width=0.7)
    # ax.set_xticks(ax.get_xticks()[::2])
    plt.xticks(np.arange(1, 32, 7))
    plt.show()


def plot_issue_month():
    days_count = []
    for issue_date in issue_dates:
        # print(issue_date.weekday())
        days_count.append(issue_date.month)
    print(days_count)
    arr = np.array(days_count)
    plt.hist(days_count, bins=np.arange(1, 14),
             width=0.7, color='g')
    plt.xticks(np.arange(1, 14))
    plt.show()


# def plot_issue_year():
#     days_count = []
#     for issue_date in issue_dates:
#         # print(issue_date.weekday())
#         days_count.append(issue_date.day)
#     # print(days_count)
#     arr = np.array(days_count)
#     plt.hist(days_count, bins=np.arange(1, 32))
#     plt.show()


def plot_return_duration():
    return_duration = [(return_dates[i] - issue_dates[i]).days
                       for i in range(num_entries)]
    arr = np.array(return_duration)
    # print(return_duration)
    plt.hist(return_duration, bins=np.arange(
        arr.min(), arr.max()+2), width=0.8, color='g')
    plt.xticks(np.arange(arr.min(), arr.max()+2, 1))
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
    plt.hist(fines, bins=np.arange(arr.min(), arr.max()+2), width=0.8)
    plt.show()


def plot_fines_pie():
    return_duration = [(return_dates[i] - issue_dates[i]).days
                       for i in range(num_entries)]
    fines = []
    non_finer = 0
    finer_count_one_week = 0
    finer_count_two_weeks = 0
    for rd in return_duration:
        if rd <= borrow_time:
            non_finer += 1
        elif rd <= 14:
            finer_count_one_week += 1
        else:
            finer_count_two_weeks += 1
    # print(finer_count)
    plt.pie([finer_count_one_week, finer_count_two_weeks, non_finer],
            labels=["Returned late by less than a week"+str(finer_count_one_week), "Returned after two weeks"+str(finer_count_two_weeks), "Returned on Time"+str(non_finer)])
    plt.show()


def plot_category_counts():
    plt.bar(category_counts.keys(), category_counts.values(), 0.5, color='g')
    plt.show()


if __name__ == "__main__":
    setup()
    # plot_issue_day_of_week()
    # plot_issue_day_of_month()
    plot_issue_month()
    # plot_return_duration()
    # plot_fines()
    # plot_fines_pie()
    # plot_category_counts()
