import random


def generate_matrix(m, n, min_value, max_value):
    """
    Генерує матрицю m x n зі випадкових цілих чисел
    у діапазоні [min_value, max_value].
    """
    return [
        [random.randint(min_value, max_value) for _ in range(n)]
        for _ in range(m)
    ]


def print_matrix(matrix):
    """
    Виводить матрицю у табличному вигляді.
    """
    if not matrix:
        print("Матриця порожня.")
        return

    rows = len(matrix)
    cols = len(matrix[0])

    print("\n" + " " * 10, end="")
    for j in range(cols):
        print(f"{'стовпець ' + str(j + 1):>12}", end="")
    print()

    for i, row in enumerate(matrix):
        print(f"{'рядок ' + str(i + 1):>10}", end="")
        for value in row:
            print(f"{value:>12.2f}", end="")
        print()

    print()

def subtract_row_mean(matrix):
    """
    Від кожного елемента кожного рядка віднімає
    середнє арифметичне цього рядка.
    """
    result = []

    for row in matrix:
        average = sum(row) / len(row)
        new_row = [value - average for value in row]
        result.append(new_row)

    return result

def shift_right(matrix, k):
    """
    Виконує циклічний зсув матриці вправо на k позицій.
    """
    if not matrix:
        return matrix

    rows = len(matrix)
    cols = len(matrix[0])

    k %= cols

    for i in range(rows):
        matrix[i] = matrix[i][-k:] + matrix[i][:-k] if k != 0 else matrix[i]

    return matrix

def shift_up(matrix, k):
    """
    Виконує циклічний зсув матриці догори на k позицій.
    """
    if not matrix:
        return matrix

    rows = len(matrix)

    k %= rows

    matrix[:] = matrix[k:] + matrix[:k]

    return matrix

def remove_rows_columns_with_max(matrix):
    """
    Знаходить максимальне значення матриці та видаляє
    всі рядки й стовпці, які містять хоча б один максимум.
    """
    if not matrix:
        return []

    max_value = max(max(row) for row in matrix)

    rows_to_delete = set()
    cols_to_delete = set()

    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if matrix[i][j] == max_value:
                rows_to_delete.add(i)
                cols_to_delete.add(j)

    result = []

    for i in range(len(matrix)):
        if i in rows_to_delete:
            continue

        new_row = []

        for j in range(len(matrix[i])):
            if j not in cols_to_delete:
                new_row.append(matrix[i][j])

        if new_row:
            result.append(new_row)

    return result

def rotate_90_clockwise_in_place(matrix):
    """
    Повертає квадратну матрицю на 90 градусів за годинниковою
    стрілкою без створення додаткового масиву.

    Алгоритм:
    1. Транспонуємо матрицю.
    2. Розвертаємо кожен рядок.
    """
    n = len(matrix)

    if n == 0:
        return matrix

    for row in matrix:
        if len(row) != n:
            raise ValueError(
                "Для in-place повороту на 90° матриця повинна бути квадратною."
            )

    for i in range(n):
        for j in range(i + 1, n):
            matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]

    for i in range(n):
        matrix[i].reverse()

    return matrix


def create_schedule():
    """
    Створює розклад:
    schedule[group][day][lesson]
    """

    schedule = [
        [
            ["Математика", "Програмування", "Фізика", "Англійська"],
            ["Бази даних", "Математика", "Вільне вікно", "Програмування"],
            ["Фізика", "Програмування", "Математика", "Вільне вікно"],
            ["Англійська", "Бази даних", "Програмування", "Фізика"],
            ["Математика", "Вільне вікно", "Англійська", "Бази даних"]
        ],

        [
            ["Програмування", "Математика", "Фізика", "Вільне вікно"],
            ["Бази даних", "Англійська", "Математика", "Програмування"],
            ["Фізика", "Математика", "Вільне вікно", "Англійська"],
            ["Програмування", "Бази даних", "Фізика", "Математика"],
            ["Англійська", "Програмування", "Вільне вікно", "Бази даних"]
        ],

        [
            ["Математика", "Фізика", "Програмування", "Вільне вікно"],
            ["Англійська", "Бази даних", "Математика", "Програмування"],
            ["Фізика", "Вільне вікно", "Програмування", "Математика"],
            ["Бази даних", "Англійська", "Фізика", "Програмування"],
            ["Математика", "Програмування", "Вільне вікно", "Англійська"]
        ]
    ]

    return schedule


def print_schedule(schedule):
    """
    Виводить розклад усіх груп.
    """
    days = ["Понеділок", "Вівторок", "Середа", "Четвер", "П'ятниця"]

    for group in range(len(schedule)):
        print(f"\n========== Група {group + 1} ==========")

        for day in range(len(schedule[group])):
            print(f"\n{days[day]}:")

            for lesson in range(len(schedule[group][day])):
                print(
                    f"  {lesson + 1} пара: "
                    f"{schedule[group][day][lesson]}"
                )


def find_busiest_day(schedule, group):
    """
    Знаходить день із найбільшою кількістю пар
    для вибраної групи.
    """
    days = [
        "Понеділок",
        "Вівторок",
        "Середа",
        "Четвер",
        "П'ятниця"
    ]

    max_lessons = -1
    busiest_day = None

    for day in range(len(schedule[group])):
        count = 0

        for lesson in schedule[group][day]:
            if lesson != "Вільне вікно":
                count += 1

        if count > max_lessons:
            max_lessons = count
            busiest_day = days[day]

    return busiest_day, max_lessons


def find_days_with_windows(schedule, group):
    """
    Знаходить дні, у яких для вибраної групи
    є хоча б одне "Вільне вікно".
    """
    days = [
        "Понеділок",
        "Вівторок",
        "Середа",
        "Четвер",
        "П'ятниця"
    ]

    result = []

    for day in range(len(schedule[group])):
        for lesson in schedule[group][day]:
            if lesson == "Вільне вікно":
                result.append(days[day])
                break

    return result


def find_stream_lessons(schedule):
    """
    Перевіряє, чи проводиться один і той самий предмет
    у кількох групах в один і той самий день та на одну
    й ту саму пару.
    """

    result = []

    groups = len(schedule)
    days = len(schedule[0])
    lessons = len(schedule[0][0])

    for day in range(days):
        for lesson in range(lessons):

            subjects = {}

            for group in range(groups):
                subject = schedule[group][day][lesson]

                if subject != "Вільне вікно":
                    if subject not in subjects:
                        subjects[subject] = []

                    subjects[subject].append(group + 1)

            for subject, group_list in subjects.items():
                if len(group_list) >= 2:
                    result.append({
                        "day": day + 1,
                        "lesson": lesson + 1,
                        "subject": subject,
                        "groups": group_list
                    })

    return result

def main():

    m = 5
    n = 5
    min_value = 0
    max_value = 10

    matrix = generate_matrix(
        m,
        n,
        min_value,
        max_value
    )

    print("ПОЧАТКОВА МАТРИЦЯ:")
    print_matrix(matrix)

    matrix_mean = subtract_row_mean(matrix)

    print("ПІСЛЯ ВІДНІМАННЯ СЕРЕДНЬОГО:")
    print_matrix(matrix_mean)

    k = 2

    shifted_matrix = [row[:] for row in matrix]

    shift_right(shifted_matrix, k)
    shift_up(shifted_matrix, k)

    print(f"ПІСЛЯ ЦИКЛІЧНОГО ЗСУВУ НА {k}:")
    print_matrix(shifted_matrix)

    matrix_without_max = remove_rows_columns_with_max(matrix)

    print("МАКСИМАЛЬНІ ЕЛЕМЕНТИ ТА ЇХ РЯДКИ/СТОВПЦІ ВИДАЛЕНО:")
    print_matrix(matrix_without_max)


    rotate_matrix = generate_matrix(
        4,
        4,
        1,
        9
    )

    print("МАТРИЦЯ ДЛЯ ПОВОРОТУ:")
    print_matrix(rotate_matrix)

    rotate_90_clockwise_in_place(rotate_matrix)

    print("ПІСЛЯ ПОВОРОТУ НА 90° ЗА ГОДИННИКОВОЮ СТРІЛКОЮ:")
    print_matrix(rotate_matrix)



    print("\n\n==========================================")
    print("ТРИВИМІРНИЙ МАСИВ — РОЗКЛАД")
    print("==========================================")

    schedule = create_schedule()

    print_schedule(schedule)


    selected_group = 0

    busiest_day, number_of_lessons = find_busiest_day(
        schedule,
        selected_group
    )

    print(
        f"\nДля групи {selected_group + 1} "
        f"найбільше навантаження має день: "
        f"{busiest_day} ({number_of_lessons} пар)"
    )


    days_with_windows = find_days_with_windows(
        schedule,
        selected_group
    )

    print(
        f"Для групи {selected_group + 1} "
        f"дні з вікнами:"
    )

    for day in days_with_windows:
        print(f"  - {day}")


    streams = find_stream_lessons(schedule)

    print("\nПОТОКОВІ ЗАНЯТТЯ:")

    if not streams:
        print("Потокових занять не знайдено.")
    else:
        days = [
            "Понеділок",
            "Вівторок",
            "Середа",
            "Четвер",
            "П'ятниця"
        ]

        for stream in streams:
            print(
                f"  {days[stream['day'] - 1]}, "
                f"{stream['lesson']} пара: "
                f"{stream['subject']} — "
                f"групи {stream['groups']}"
            )



if __name__ == "__main__":
    main()
