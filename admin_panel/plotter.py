import csv
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
        # print(issue_date.weekday())
        days_count[days[issue_date.weekday()]
                   ] = days_count[days[issue_date.weekday()]] + 1
    colors = []
    for i in range(7):
        if days_count[days[i]] > 150:
            colors.append('r')
        else:
            colors.append('g')

    # print(days_count)
    # brlist = plt.bar(days_count.keys(), days_count.values(), 0.5, color='g')
    # for i in range(7):
    #     brlist[i].set_color(colors[i])
    # # plt.legend()
    # plt.title("Number of issues per day of week")
    # plt.xlabel("Day of week")
    # plt.ylabel("Number of books issued")
    # plt.savefig('plot_issue_day_of_week.png')
    # plt.clf()
    # plt.show()
    return days_count


def plot_issue_day_of_month():
    days_count = []
    for issue_date in issue_dates:
        days_count.append(issue_date.day)
    # print(days_count)
    arr = np.array(days_count)
    fine_payers = [0 for i in range(max(arr)+1)]
    for fine in days_count:
        fine_payers[fine] += 1
    # plt.hist(days_count, bins=np.arange(1, 32), width=0.7)
    # # ax.set_xticks(ax.get_xticks()[::2])
    # plt.xticks(np.arange(1, 32, 7))
    # plt.title("Number of issues per day of month")
    # plt.xlabel("Day of month")
    # plt.ylabel("Number of books issued")
    # plt.savefig('plot_issue_day_of_month.png')
    # plt.clf()
    # plt.show()
    return fine_payers


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
    plt.title("Number of issues per month")
    plt.xlabel("Month No.")
    plt.ylabel("Number of books issued")
    plt.savefig('plot_issue_month.png')
    plt.clf()
    # plt.show()


def plot_return_duration():
    return_duration = [(return_dates[i] - issue_dates[i]).days
                       for i in range(num_entries)]
    arr = np.array(return_duration)
    # print(return_duration)
    fine_payers = [0 for i in range(max(arr)+1)]
    for fine in return_duration:
        fine_payers[fine] += 1
    # plt.hist(return_duration, bins=np.arange(
    #     arr.min(), arr.max()+2), width=0.8, color='g')
    # plt.xticks(np.arange(arr.min(), arr.max()+2, 1))
    # plt.title("Return duration frequency")
    # plt.xlabel("Time in days from issue")
    # plt.ylabel("Books returned")
    # plt.savefig('plot_return_duration.png')
    # plt.clf()
    # plt.show()
    return fine_payers


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
    plt.title("Fine frequency")
    plt.xlabel("Fine value")
    plt.ylabel("No of people")
    plt.savefig('plot_fines.png')
    plt.clf()
    # plt.show()


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
            labels=["Returned in 8-14 days - "+str(finer_count_one_week), "Returned after 14 days - "+str(finer_count_two_weeks), "Returned on Time - "+str(non_finer)])
    plt.title("Pie Chart for Fine Paid (Total Books = "+str(num_entries)+")")
    plt.savefig('plot_fines_pie.png')
    plt.clf()
    # plt.show()


def plot_category_counts():
    plt.bar(category_counts.keys(), category_counts.values(), 0.5, color='g')
    plt.title("No of books issued in each catgory")
    plt.xlabel("Category")
    plt.ylabel("No of books")
    plt.savefig('plot_category_counts.png')
    plt.clf()
    # plt.show()


def produce_all():
    plot_issue_day_of_week()
    plot_issue_day_of_month()
    plot_issue_month()
    plot_return_duration()
    plot_fines()
    plot_fines_pie()
    plot_category_counts()


def write_to_csv():
    issue_dates_2 = []
    return_dates_2 = []
    for i_d in issue_dates:
        issue_dates_2.append(str(i_d)+'T00:00:00')
    for i_d in return_dates:
        return_dates_2.append(str(i_d)+'T00:00:00')
    # print(issue_dates_2)
    # print(return_dates_2)
    with open('dates.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["issue_date", "return_date"])
        for i_d, r_d in zip(issue_dates_2, return_dates_2):
            writer.writerow([i_d, r_d])


def fines_to_csv():
    return_duration = [(return_dates[i] - issue_dates[i]).days
                       for i in range(num_entries)]
    fines = []
    for rd in return_duration:
        if rd > borrow_time:
            fines.append(fine_per_day*(rd-borrow_time))
    arr = np.array(fines)
    fine_payers = [0 for i in range(max(fines)+1)]
    for fine in fines:
        fine_payers[fine] += 1
    return fine_payers
    # print(fine_payers)


def caller(issued, returned):
    issue_dates = issued
    return_dates = returned
    soln = []
    soln.append(plot_issue_day_of_week())
    soln.append(plot_issue_day_of_month())
    soln.append(plot_return_duration())
    soln.append(fines_to_csv())
    return soln


if __name__ == "__main__":
    setup()
    # produce_all()
    # write_to_csv()
    # fines_to_csv()
    soln = []
    soln.append(plot_issue_day_of_week())
    soln.append(plot_issue_day_of_month())
    soln.append(plot_return_duration())
    soln.append(fines_to_csv())
    print(soln)
