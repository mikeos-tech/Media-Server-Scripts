#!/usr/bin/env python3
import requests
import uuid
import json
import datetime
import time
from calendar import monthrange

Personal_Key = "5fdeee69e438db97e784582db18d19f7b7af5198"
InBox_Key = 2276310805

def add_label(name):  # Adds the label to todoist
    reply = requests.post(
        "https://api.todoist.com/rest/v1/labels",
        data=json.dumps({
            "name": name,
            "color": 42,
            "favorite": True
        }),
        headers={
            "Content-Type": "application/json",
            "X-Request-Id": str(uuid.uuid4()),
            "Authorization": "Bearer " + Personal_Key
        }).json()
    return reply['id']   # read the labels id.


def add_holiday(info, label_id):   # Writes the holiday to todoist
    if "name" in info:
        # Build the meta-data
        event_name = info['name']
        descript = ""
        if info["location"] != "":
            descript += info["location"]
        if info["type"] != "":
            if descript != "":
                descript += " - "
            descript += info["type"]
        if info["description"] != "":
            if descript != "":
                descript += " - "
            descript += info["description"]
        event_date = info['date']
        event_date = event_date.replace("/", "-")
#    print("Add Date String: " + event_date)

        # Add the item
        requests.post(
            "https://api.todoist.com/rest/v1/tasks",
            data=json.dumps({
                "content": "***" + event_name + "***",  # Markdown formating to make name bold
                "due_string": event_date,
                "due_lang": "en",
                "priority": 4,
                "label_ids": [label_id],
                "description": descript
            }),
            headers={
                "Content-Type": "application/json",
                "X-Request-Id": str(uuid.uuid4()),
                "Authorization": "Bearer " + Personal_Key
            }).json()
    else:
        print("Error Reading Holiday Data!")
        quit()


def get_holiday(year, month, day):  # Reads abstractapi to get a holiday if there is one
    url = "https://holidays.abstractapi.com/v1/?api_key=add9fdbc13724c5b85c951311e2e32ea&country=GB&year=" + str(year) + "&month=" + str(month) + "&day=" + str(day)
    response = requests.get(url)
    data = response.text
    result = {}
    if data != "[]":
        x = data.replace("[", "")
        data = x.replace("{", "")
        x = data.replace("}", "")
        data = x.replace("]", "")
        y = data.split(",\"")  # It needs to split on the , and quote as comma may appear in values and keys will always have a quote, but values won't
        for i in y:
            i = i.replace("\"", "")
            pair = i.split(":")
            result[pair[0]] = pair[1]
        result["read"] = "True"  # Data was read
    else:
        result["read"] = "False"  # Data wasn't read
    return result


def find_record(content, date, label):  # Checks to see if a holiday already exists in todoist
    # get a list of all the tasks
#    id = 0
 #   print(content)
 #   print(date)
 #   print(label)
    data = requests.get(
        "https://api.todoist.com/rest/v1/tasks",
        params={
            "project_id": InBox_Key
        },
        headers={
            "Authorization": "Bearer " + Personal_Key
        }).json()

    # iterate the list to find the record
    for x in data:
        if x["content"] == content and x["due"]["date"] == date:  # and x["label_ids"][0] == label:

 #           print(x["due"]["date"] + " - " + date)
#            print(str(x["label_ids"][0]) + " - " + str(label))
 #           print(x["content"] + " - " + content)

            return x["id"]

def update_event(info, label_id, event_id):  # Updates an existing holiday in todoist
    # Build the meta-data
    if "name" in info:
        event_name = info['name']
        descript = ""
        if info["location"] != "":
            descript += info["location"]
        if info["type"] != "":
            if descript != "":
                descript += " - "
            descript += info["type"]
        if info["description"] != "":
            if descript != "":
                descript += " - "
            descript += info["description"]
        event_url = "https://api.todoist.com/rest/v1/tasks/" + str(event_id)
        event_date = info['date']
        event_date = event_date.replace("/", "-")

 #   print("In update: ")
 #   print(event_url)
 #   print("Update Date String: " + event_date)
 #   print(event_name)
 #   print(descript)

        # Update the item
        requests.post(
            event_url,
            data=json.dumps({
                "content": "***" + event_name + "***",  # Markdown formating to make name bold
                "due_string": event_date,
                "due_lang": "en",
                "priority": 4,
                "label_ids": [label_id],
                "description": descript
            }),
            headers={
                "Content-Type": "application/json",
                "X-Request-Id": str(uuid.uuid4()),
                "Authorization": "Bearer " + Personal_Key
            })
    else:
        print("Error Reading Holiday Data!")
        quit()
 #   print(data)
 #   print(response.status_code)
 #   print("\n\n")


# Execution starts here

# Work our the current date and the end date
current_date = datetime.date.today()
day = int(current_date.strftime("%d"))
month = int(current_date.strftime("%m"))
year = int(current_date.strftime("%Y"))
month_len = monthrange(year, month)[1] + 1

label_id = add_label("Holiday Date")  # Find the id for the label

for x in range(day, month_len):  # loop to iterate the date range
    holiday_info = get_holiday(year, month, day)
    if "error" in holiday_info:
        print("Error reading holiday Data!")
        quit()
 #   print(holiday_info)
    if "name" in holiday_info:
        id = find_record("***" + holiday_info["name"] + "***", holiday_info["date_year"] + "-" + holiday_info["date_month"] + "-" + holiday_info["date_day"], label_id)
        if id == None:
            add_holiday(holiday_info, label_id)
        else:
  #          print("Updated: " + holiday_info["name"] + " - " + str(id) )
            update_event(holiday_info, label_id, id)
    day = day + 1
    time.sleep(1)  # sleep for a second api requires this