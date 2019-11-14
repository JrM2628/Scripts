import csv
import os

"""
ToDo: Clean this up 
It works well but it could be better
"""

datas = []
lab_number = "7"


with open("grading{}.csv".format(lab_number)) as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        datas.append(row[1:])

categories = datas[0]
max_points = datas[1]
datas = datas[2:]

output = []
if not os.path.exists("grades_lab{}\\".format(lab_number)):
    os.makedirs("grades_lab{}\\".format(lab_number))

for data_point in range(0, len(datas)):
    line = ""
    line += ("{}: {}".format(categories[0], datas[data_point][0]))
    line += "\n"
    for value in range(1, len(datas[data_point])-1):
        line += ("{}: {}/{}".format(categories[value], datas[data_point][value], max_points[value]))
        line += "\n"
    line += ("{}: {}".format(categories[-1], datas[data_point][-1]))
    line += "\n"
    output.append(line)

for student in range(0, len(output)):
    student_name = datas[student][0].replace(", ", "")
    file_name = "grades_lab{}\{}_lab{}.txt".format(lab_number, student_name, lab_number)
    print(file_name)
    file = open(file_name, "w")
    file.write(output[student])
    file.close()
